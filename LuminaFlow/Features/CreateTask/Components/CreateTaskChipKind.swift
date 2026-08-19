//
//  CreateTaskChipKind.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 5.08.2026.
//

import SwiftUI

enum CreateTaskChipKind {
    case date(label: String), priority(label: String), reminder(label: String), tag(label: String)
    
    var template: CreateTaskChipTemplate {
        switch self {
        case .date(let label):
            CreateTaskChipTemplate(imageName: "calendar",
                                    title: label,
                                    backgroundColor: .chipTodayBackground,
                                    typography: .createTaskDateChipLabel)
        case .priority(let label):
            CreateTaskChipTemplate(imageName: "flag",
                                   title: label,
                                    backgroundColor: .chipPriorityBackground,
                                    typography: .createTaskPriorityChipLabel)
            
        case .reminder(let label):
            CreateTaskChipTemplate(imageName: "bell",
                                   title: label,
                                    backgroundColor: .chipReminderBackground,
                                    typography: .createTaskReminderChipLabel)
            
        case .tag(let label):
            CreateTaskChipTemplate(imageName: "tag",
                                   title: label,
                                    backgroundColor: .chipInboxBackground,
                                    typography: .createTaskInboxChipLabel)
            
        }
    }
}

struct CreateTaskChipTemplate {
    let imageName: String
    let title: String
    let backgroundColor: Color
    let typography: LuminaTypography
}

