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
}
