//
//  TaskItem.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 4.05.2026.
//

import Foundation

struct TaskItem: Identifiable, Hashable {
    var id: UUID = UUID()
    let title: String
    let description: String?
    let dueDate: Date?
    let reminder: Date?
    let isFinished: Bool
    let priority: TaskPriority
    let tag: TaskTag?
    var subtasks: [SubtaskItem] = []
    
    func togglingFinished() -> TaskItem {
        return TaskItem(id: self.id,
                        title: self.title,
                        description: self.description,
                        dueDate: self.dueDate,
                        reminder: self.reminder,
                        isFinished: !self.isFinished,
                        priority: self.priority,
                        tag: self.tag,
                        subtasks: self.subtasks)
    }
    
    func togglingSubtask(id: UUID) -> TaskItem? {
        guard let i = subtasks.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        var copy = self
        copy.subtasks[i].isCompleted.toggle()
        return copy
    }
}
