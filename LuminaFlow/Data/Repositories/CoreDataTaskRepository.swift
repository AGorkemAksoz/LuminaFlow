//
//  CoreDataTaskRepository.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 8.08.2026.
//

import CoreData
import Foundation

actor CoreDataTaskRepository: TaskRepository {
    
    private let context: NSManagedObjectContext
    private let calendar: Calendar
    
    init(persistenceController: PersistenceController, calendar: Calendar = .autoupdatingCurrent) {
        self.context = persistenceController.container.newBackgroundContext()
        self.calendar = calendar
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    /// Returns the task due on the given day, sorted by dueDate ascending
    func fetchTasks(for date: Date) async throws -> [TaskItem] {
        let dayStart = calendar.startOfDay(for: date)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
            return []
        }
        
        return try await context.perform {
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(
                format: "(dueDate >= %@) AND (dueDate < %@)",
                dayStart as NSDate,
                dayEnd as NSDate
            )
            request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.dueDate,
                                                        ascending: true)]
            
            let entities = try self.context.fetch(request)
            return entities.toDomain()
        }
    }
    
    func add(_ taskItem: TaskItem) async throws {
        try await context.perform {
            let existing = try self.fetchEntity(id: taskItem.id, in: self.context)
            guard existing == nil else {
                throw RepositoryError.duplicate(taskItem.id)
            }
            
            taskItem.toEntity(context: self.context)
            try self.context.save()
        }
    }
    
    func update(_ taskItem: TaskItem) async throws {
        try await context.perform {
            guard let entity = try self.fetchEntity(id: taskItem.id, in: self.context) else {
                throw RepositoryError.notFound(taskItem.id)
            }
            
            entity.update(from: taskItem)
            try self.context.save()
        }
    }
    
    func delete(_ id: UUID) async throws {
        try await context.perform {
            guard let existing = try self.fetchEntity(id: id, in: self.context) else {
                throw RepositoryError.notFound(id)
            }
            
            self.context.delete(existing)
            try self.context.save()
        }
    }
    
    // MARK: - Private helpers
    
    /// Not actor-isolated on purpose: only touches the `context` passed in,
    /// so it must be safe to call from inside `context.perform`'s closure
    /// (which runs on the context's own queue, not the actor's).
    nonisolated private func fetchEntity(id: UUID, in context: NSManagedObjectContext) throws -> TaskEntity? {
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
