//
//  SubtaskItem.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 8.10.2026.
//

import Foundation

struct SubtaskItem: Identifiable, Hashable {
    var id: UUID = UUID()
    let title: String
    var isCompleted: Bool
    
    
    func togglingFinished() -> SubtaskItem {
        return SubtaskItem(id: self.id,
                           title: self.title,
                           isCompleted: !self.isCompleted)
    }
}
