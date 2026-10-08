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
                                  tag: taskTag)
        
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
}
