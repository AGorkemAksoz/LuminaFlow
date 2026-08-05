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
    
    init(calendar: Calendar = .autoupdatingCurrent) {
        var cal = calendar
        cal.firstWeekday = 2 // Monday-first week strip
        self.calendar = cal
        self.taskRepository = InMemoryTaskRepository(calendar: cal)
    }
    
    func makeDashboardViewModel() -> DashboardViewModel {
        return DashboardViewModel(repository: taskRepository,
                                  calendar: calendar)
    }
    
    func makeCreateTaskViewModel(initialDueDate: Date = Date()) -> CreateTaskViewModel {
        return CreateTaskViewModel(repository: taskRepository,
                                   calendar: calendar,
                                   initialDueDate: initialDueDate)
    }
}
