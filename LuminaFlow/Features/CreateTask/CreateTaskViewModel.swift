//
//  CreateTaskViewModel.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 3.08.2026.
//

import Foundation

@MainActor
final class CreateTaskViewModel: ObservableObject, Identifiable {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var dueDate: Date = Date()
    @Published var priority: TaskPriority = .medium
    @Published var reminderDate: Date? = nil
    @Published var taskTag: TaskTag? = nil
    @Published private(set) var isSaving: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    // AddSubtask Properties
    @Published var subtaskItems: [SubtaskItem] = []

    // Taslak (üstteki input alanı)
    @Published var draftTitle = ""
    
    // Async Actor repository dependency
    private let repository: TaskRepository
    private let reminderScheduler: ReminderScheduler
    let calendar: Calendar
    let id = UUID()
    
    init(repository: TaskRepository,
         calendar: Calendar = .autoupdatingCurrent,
         reminderScheduler: ReminderScheduler,
         initialDueDate: Date = Date()) {
        self.repository = repository
        self.calendar = calendar
        self.reminderScheduler = reminderScheduler
        self.dueDate = calendar.startOfDay(for: initialDueDate)
    }
    
    var onTaskCreated: (() -> Void)?
    
    var dueDateChipTitle: String {
        TaskDateFormatting.dueLabel(for: dueDate, calendar: calendar)
    }
    
    var reminderChipTitle: String {
        guard let reminderDate else { return "Reminder" }
        return reminderDate.formatted(date: .omitted, time: .shortened)
        // örn. "03:30" veya locale’e göre "3:30 AM"
    }
    
    func save() async {
        do {
            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard trimmedTitle.count > 0 else {
                // TODO: Error types will add
                errorMessage = "Title can't be empty"
                return
            }
            
            isSaving = true
            defer { isSaving = false}
            
            let taskItem = TaskItem(title: trimmedTitle,
                                    description: description.isEmpty ? nil : description,
                                    dueDate: dueDate,
                                    reminder: reminderDate,
                                    isFinished: false,
                                    priority: priority,
                                    tag: taskTag,
                                    subtasks: subtaskItems)
            
            try await repository.add(taskItem)
            
            if taskItem.reminder != nil {
                let allowed = await reminderScheduler.requestAuthorization()
                if allowed {
                    do {
                        try await reminderScheduler.schedule(for: taskItem)
                    } catch {
                        // soft: log / isteğe bağlı ayrı mesaj
                    }
                }
            }
            errorMessage = nil
            
            onTaskCreated?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Alert functions
    func clearError() {
        errorMessage = nil
    }
    
    func retry() async {
        await save()
    }
    
    // MARK: - Add Subtask Functions
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
extension CreateTaskViewModel: SubtaskDrafting {}
