//
//  CreateTaskChipKind.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 5.08.2026.
//

import SwiftUI

enum CreateTaskChipKind {
    case date(label: String), priority(label: String), reminder, inbox
    
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
            
        case .reminder:
            CreateTaskChipTemplate(imageName: "bell",
                                    title: "Reminder",
                                    backgroundColor: .chipReminderBackground,
                                    typography: .createTaskReminderChipLabel)
            
        case .inbox:
            CreateTaskChipTemplate(imageName: "tray",
                                    title: "Inbox",
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

