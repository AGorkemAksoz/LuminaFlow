//
//  DependencyContainer.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 2.08.2026.
//

import Foundation

@MainActor
final class DependencyContainer {
    let calendar: Calendar
    let taskRepository: TaskRepository
    let reminderScheduler: ReminderScheduler
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController,  calendar: Calendar = .autoupdatingCurrent) {
        var cal = calendar
        cal.firstWeekday = 2 // Monday-first week strip
        self.calendar = cal
        self.persistenceController = persistenceController
        self.taskRepository = CoreDataTaskRepository(
            persistenceController: persistenceController,
            calendar: cal
        )
        self.reminderScheduler = UserNotificationsReminderScheduler(calendar: cal)
    }
    
    func makeDashboardViewModel() -> DashboardViewModel {
        return DashboardViewModel(repository: taskRepository,
                                  calendar: calendar,
                                  reminderScheduler: reminderScheduler)
    }
    
    func makeCreateTaskViewModel(initialDueDate: Date = Date()) -> CreateTaskViewModel {
        return CreateTaskViewModel(repository: taskRepository,
                                   calendar: calendar,
                                   reminderScheduler: reminderScheduler,
                                   initialDueDate: initialDueDate)
    }
}
