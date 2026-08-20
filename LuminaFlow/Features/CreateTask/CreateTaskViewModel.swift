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
        let today = calendar.startOfDay(for: Date())
        let dueDay = calendar.startOfDay(for: dueDate)
        
        if calendar.isDate(dueDay, inSameDayAs: today) {
            return "Today"
        }
        
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
           calendar.isDate(dueDay, inSameDayAs: tomorrow){
            return "Tomorrow"
        }
        
        return dueDay.formatted(date: .numeric, time: .shortened)
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
                                    tag: taskTag)
            
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
}
