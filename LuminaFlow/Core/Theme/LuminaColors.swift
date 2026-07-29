//
//  LuminaColors.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

extension Color {
    // Design System - Color Palette
    static let luminaBackground = Color(hex: "#FAFAFA")
    static let luminaSoftBlue = Color(hex: "#E8F1F8")
    static let luminaAccentBlue = Color(hex: "#306FF1")
    static let luminaAccentPurple = Color(hex: "#BDB2FF")
    static let luminaSeedBlue = Color(hex: "#2B6CEE")
    
    // UI Elements
    static let luminaPrimaryAction = Color(hex: "#1A1A1A")
    static let luminaSecondaryAction = Color(hex: "#E8F1F8")
    
    static let luminaMutedSlate = Color(hex: "#64748B")
    static let luminaDarkNavy = Color(hex: "#0F172A")
    static let luminaLightSlate = Color(hex: "#94A3B8")
    
    static let brandBlueColor = Color(hex: "#2563EB")
    
    static let strategyTagTextColor = Color(hex: "#7C3AED")
    static let strategyBackgroundColor = Color(hex: "#F5D3FF")
    
    static let wellnessTagTextColor = Color(hex: "#059669")
    static let wellnessTagBackgroundColor = Color(hex: "ECFDF5")
    
    static let personalTagTextColor = Color(hex: "#475569")
    static let personalTagBackgroundColor = Color(hex: "#F1F5F9")
    
    static let selectedDateTextColor = Color(hex: "#FFFFFF")
    
    
    // MARK: - Create Task

    /// Sheet surface (beyaz kart yüzeyi)
    static let createTaskSurface = Color(hex: "#FFFFFF")

    /// Grab handle
    static let createTaskHandle = Color(hex: "#D1D5DB") // Light Gray

    /// Title field caret / focus (opsiyonel)
    static let createTaskFocus = Color(hex: "#306FF1")

    /// Details placeholder — mevcut muted slate ile aynı ama semantic isim
    static let createTaskPlaceholder = Color(hex: "#94A3B8") // = luminaLightSlate

    /// Chip: Today
    static let chipTodayBackground = Color(hex: "#E8F1F8") // = softBlue
    static let chipTodayForeground = Color(hex: "#2563EB") // = brandBlue

    /// Chip: Priority
    static let chipPriorityBackground = Color(hex: "#EDE9FE") // soft violet
    static let chipPriorityForeground = Color(hex: "#7C3AED") // = strategyTagText

    /// Chip: Reminders
    static let chipReminderBackground = Color(hex: "#EDE9FE")
    static let chipReminderForeground = Color(hex: "#7C3AED")

    /// Chip: Inbox (default / list picker)
    static let chipInboxBackground = Color(hex: "#F1F5F9") // = personalTag bg
    static let chipInboxForeground = Color(hex: "#0F172A") // = darkNavy

    /// Subtasks empty state
    static let subtaskDashedBorder = Color(hex: "#CBD5E1")
    static let subtaskIconCircle = Color(hex: "#E2E8F0")
    static let subtaskMuted = Color(hex: "#94A3B8")

    /// Primary CTA
    static let saveTaskBackground = Color(hex: "#4F6EF7") // blue-violet, mock’taki Save
    static let saveTaskForeground = Color(hex: "#FFFFFF")
    static let saveTaskShadow = Color(hex: "#4F6EF7").opacity(0.35)
}
