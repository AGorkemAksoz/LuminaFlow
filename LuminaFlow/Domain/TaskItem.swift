//
//  TaskItem.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 4.05.2026.
//

import Foundation

struct TaskItem: Identifiable {
    var id: UUID = UUID()
    let title: String
    let description: String?
    let dueDate: Date?
    let isFinished: Bool
    
    func togglingFinished() -> TaskItem {
        return TaskItem(id: self.id,
                        title: self.title,
                        description: self.description,
                        dueDate: self.dueDate,
                        isFinished: !self.isFinished)
    }
}
