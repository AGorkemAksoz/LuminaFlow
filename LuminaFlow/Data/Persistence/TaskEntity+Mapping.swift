//
//  TaskEntity+Mapping.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 8.08.2026.
//

import CoreData
import Foundation

enum TaskMappingError: LocalizedError {
    case missingID
    case missingTitle
    case invalidPriority(String)
    case invalidTag(String)
    
    var errorDescription: String? {
        switch self {
        case .missingID:
            return "Task entity'sinde id bulunamadı."
        case .missingTitle:
            return "Task entity'sinde başlık bulunamadı."
        case .invalidPriority(let rawValue):
            return "Geçersiz priority değeri: \(rawValue)"
        case .invalidTag(let rawValue):
            return "Geçersiz tag değeri: \(rawValue)"
        }
    }
}

extension TaskEntity {
    
    /// TaskEntity -> TaskItem
    func toDomain() throws -> TaskItem {
        guard let id = self.id else {
            throw TaskMappingError.missingID
        }
        
        guard let title = self.title else {
            throw TaskMappingError.missingTitle
        }
        
        guard let priority = TaskPriority(rawValue: self.priority ?? "") else {
            throw TaskMappingError.invalidPriority(self.priority ?? "nil")
        }
        
        let tag: TaskTag?
        
        if let raw = self.tag {
            guard let parsed = TaskTag(rawValue: raw) else {
                throw TaskMappingError.invalidTag(raw)
            }
            tag = parsed
        } else {
            tag = nil
        }
        
        /// 1) NSSet -> [SubtaskEntity]
        /// 2) order'a göre artan sırala
        /// 3) domain'e çevir
        let childEntities = (self.subtasks as? Set<SubtaskEntity>) ?? []
        let subtasks: [SubtaskItem] = childEntities
            .sorted { $0.order < $1.order}
            .compactMap { child in
                do {
                    return try child.toDomain()
                } catch {
                    print("Subtask mapping hatası:", error.localizedDescription)
                    return nil
                }
            }
        
        return TaskItem(
            id: id,
            title: title,
            description: self.taskDescription,
            dueDate: self.dueDate,
            reminder: self.reminderDate,
            isFinished: self.isFinished,
            priority: priority,
            tag: tag,
            subtasks: subtasks)
    }
    
    /// TaskItem -> mevcut entity'ye yaz
    func update(from item: TaskItem) {
        self.id = item.id
        self.title = item.title
        self.taskDescription = item.description
        self.dueDate = item.dueDate
        self.reminderDate = item.reminder
        self.isFinished = item.isFinished
        self.priority = item.priority.rawValue
        self.tag = item.tag?.rawValue
        
        guard let context = self.managedObjectContext else { return }
        
        let existing = (self.subtasks as? Set<SubtaskEntity>) ?? []
        existing.forEach { context.delete($0)}
        
        for (index, subtask) in item.subtasks.enumerated() {
            let child = SubtaskEntity(context: context)
            child.update(from: subtask, order: index, parent: self)
        }
    }
}

// MARK: - SubtaskEntity <-> SubtaskItem
extension SubtaskEntity {
    func toDomain() throws -> SubtaskItem {
        guard let id = self.id else {
            throw TaskMappingError.missingID
        }
        
        guard let title = self.title else {
            throw TaskMappingError.missingTitle
        }
        
        return SubtaskItem(id: id,
                           title: title,
                           isCompleted: self.isCompleted)
    }
    
    func update(from item: SubtaskItem, order: Int, parent: TaskEntity) {
        self.id = item.id
        self.title = item.title
        self.isCompleted = item.isCompleted
        self.order = Int32(order)
        self.task = parent
    }
}

extension TaskItem {
    
    /// TaskItem -> yeni bir TaskEntity oluştur ve doldur
    @discardableResult
    func toEntity(context: NSManagedObjectContext) -> TaskEntity {
        let entity = TaskEntity(context: context)
        entity.update(from: self)
        return entity
    }
}


extension Array where Element == TaskEntity {
    /// Bozuk kayıtları loglayarak domain array'ine çevirir
    func toDomain() -> [TaskItem] {
        compactMap { entity in
            do {
                return try entity.toDomain()
            } catch {
                print("Task mapping hatası: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
