//
//  InMemoryTaskRepository.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 30.07.2026.
//

import Foundation

actor InMemoryTaskRepository: TaskRepository {
    private var tasks: [TaskItem]
    private let calendar: Calendar
    
    init(tasks: [TaskItem] = [], calendar: Calendar = .autoupdatingCurrent) {
        self.tasks = tasks
        self.calendar = calendar
    }
    
    /// Returns the tasks due on the given day, sorted by dueDate ascending.
    func fetchTasks(for date: Date) async throws -> [TaskItem] {
        let dayStart = calendar.startOfDay(for: date)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)
        else { return [] }
        return tasks.compactMap { task -> (task: TaskItem , due: Date)? in
            guard let due = task.dueDate, due >= dayStart, due < dayEnd else {
                return nil                 // tarihsiz VEYA aralık dışı → düş
            }
            return (task, due)
        }
        .sorted { $0.due < $1.due }
        .map(\.task)
    }
    
    func add(_ taskItem: TaskItem) async throws {
        guard !tasks.contains(where: {$0.id == taskItem.id}) else {
            throw RepositoryError.duplicate(taskItem.id)
        }
        tasks.append(taskItem)
    }
    
    func update(_ taskItem: TaskItem) async throws {
        guard let i = tasks.firstIndex(where: {$0.id == taskItem.id}) else {
            throw RepositoryError.notFound(taskItem.id)
        }
        tasks[i] = taskItem
    }
    
    func delete(_ id: UUID) async throws {
        guard let i = tasks.firstIndex(where: {$0.id == id}) else {
            throw RepositoryError.notFound(id)
        }
        
        tasks.remove(at: i)
    }
  
}
