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
    
    var errorDescription: String? {
        switch self {
        case .missingID:
            return "Task entity'sinde id bulunamadı."
        case .missingTitle:
            return "Task entity'sinde başlık bulunamadı."
        case .invalidPriority(let rawValue):
            return "Geçersiz priority değeri: \(rawValue)"
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
        
        return TaskItem(
            id: id,
            title: title,
            description: self.taskDescription,
            dueDate: self.dueDate,
            isFinished: self.isFinished,
            priority: priority)

    }
    
    /// TaskItem -> mevcut entity'ye yaz
    func update(from item: TaskItem) {
        self.id = item.id
        self.title = item.title
        self.taskDescription = item.description
        self.dueDate = item.dueDate
        self.isFinished = item.isFinished
        self.priority = item.priority.rawValue
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
