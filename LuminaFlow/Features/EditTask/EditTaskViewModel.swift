//
//  EditTaskViewModel.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 6.10.2026.
//

import Foundation

@MainActor
final class EditTaskViewModel: ObservableObject, Identifiable {
    @Published var title: String
    @Published var description: String
    @Published var dueDate: Date
    @Published var priority: TaskPriority
    @Published var reminderDate: Date?
    @Published var taskTag: TaskTag?
    @Published private(set) var isSaving: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    // MARK: Edit Subtask Properties
    @Published var subtaskItems: [SubtaskItem] = []
    /// Taslak (üstteki input alanı)
    @Published var draftTitle = ""

    private let repository: TaskRepository
    private let reminderScheduler: ReminderScheduler
    private let original: TaskItem
    let calendar: Calendar
    let id = UUID()
    
    var onTaskUpdated: (() -> Void)?
    
    init(task: TaskItem,
        repository: TaskRepository,
        reminderScheduler: ReminderScheduler,
         calendar: Calendar = .autoupdatingCurrent) {
        self.original = task
        self.repository = repository
        self.reminderScheduler = reminderScheduler
        self.calendar = calendar
        
        // Fill the field with the originals
        self.title = task.title
        self.description = task.description ?? ""
        self.dueDate = calendar.startOfDay(for: task.dueDate ?? Date())
        self.priority = task.priority
        self.reminderDate = task.reminder
        self.taskTag = task.tag
        self.subtaskItems = task.subtasks
    }
    
    var dueDateChipTitle: String {
        TaskDateFormatting.dueLabel(for: dueDate, calendar: calendar)
    }
    
    var reminderChipTitle: String {
        guard let reminderDate else { return "Reminder" }
        return reminderDate.formatted(date: .omitted, time: .shortened)
    }
    
    func save() async {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Title can't be empty"
            return
        }
        
        isSaving = true
        defer { isSaving = false }
        
        let updatedTask = TaskItem(id: original.id,
                                  title: trimmedTitle,
                                  description: description.isEmpty ? nil : description,
                                  dueDate: dueDate,
                                  reminder: reminderDate,
                                  isFinished: original.isFinished,
                                  priority: priority,
                                   tag: taskTag,
                                   subtasks: subtaskItems)
        
        do {
            try await repository.update(updatedTask)
            
            if updatedTask.reminder != nil {
                let allowed = await reminderScheduler.requestAuthorization()
                if allowed {
                    do { try await reminderScheduler.schedule(for: updatedTask) } catch { }
                }
            } else {
                await reminderScheduler.cancel(for: updatedTask.id)
            }
            
            errorMessage = nil
            onTaskUpdated?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() { errorMessage = nil }
    func retry() async { await save() }
    
    // MARK: - Edit Subtask Functions
    var canAdd: Bool {
        !draftTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func addDraft() {
        guard canAdd else { return }
        let item = SubtaskItem(title: draftTitle.trimmingCharacters(in: .whitespaces),
                               isCompleted: false)
        subtaskItems.append(item)
        draftTitle = ""
    }

    func toggle(_ item: SubtaskItem) {
        guard let i = subtaskItems.firstIndex(of: item) else { return }
        subtaskItems[i].isCompleted.toggle()
    }

    func delete(_ item: SubtaskItem) {
        subtaskItems.removeAll { $0.id == item.id }
    }

    /// Sürükle-bırak ile sıralama: `idString` taşınan öğe, `target` bırakılan öğe.
    func move(idString: String, onto target: SubtaskItem) {
        guard let uuid = UUID(uuidString: idString),
              let from = subtaskItems.firstIndex(where: { $0.id == uuid }),
              let to = subtaskItems.firstIndex(of: target),
              from != to else { return }
            let moved = subtaskItems.remove(at: from)
        subtaskItems.insert(moved, at: to)
    }

}

// MARK: - SubtaskDrafting Protocol Variables and Functions
extension EditTaskViewModel: SubtaskDrafting {}
