//
//  TaskPriority.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 6.08.2026.
//

import Foundation

enum TaskPriority: String, CaseIterable, Codable {
    case urgent = "urgent"
    case high = "high"
    case medium = "medium"
    case low = "low"
    
    var title: String {
        switch self {
        case .urgent:
            return "Urgent"
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        }
    }
    
    var description: String {
        switch self {
        case .urgent:
            return "Needs immediate attention"
        case .high:
            return "Top of the list"
        case .medium:
            return "Standard priority"
        case .low:
            return "Get to it eventually"
        }
    }
    
    var iconName: String {
        switch self {
        case .urgent:
            return "u.square"
        case .high:
            return "h.square"
        case .medium:
            return "m.square"
        case .low:
            return "l.square"
        }
    }
}
