//
//  LuminaTypography.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

// MARK: - Typography Model
struct LuminaTypography {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat
    let kerning: CGFloat
    let textCase: Text.Case?

    init(
        font: Font,
        color: Color,
        lineSpacing: CGFloat = 0,
        kerning: CGFloat = 0,
        textCase: Text.Case? = nil
    ) {
        self.font        = font
        self.color       = color
        self.lineSpacing = lineSpacing
        self.kerning     = kerning
        self.textCase    = textCase
    }
}

// MARK: - Styles
extension LuminaTypography {
    
    // MARK: 1. Top Bar / Header
    
    /// "GOOD MORNING" — Inter Regular 14px / #64748B / Uppercase / kerning: 0.05em
    static let welcomeMessage = LuminaTypography(
        font: LuminaFont.welcomeMessageFont(),
        color: .luminaMutedSlate,
        lineSpacing: 2.8,
        kerning: 0.7,
        textCase: .uppercase
    )
    
    /// "Alex Johnson" — Inter Bold 20px / #0F172A / kerning: -0.02em
    static let userName = LuminaTypography(
        font: LuminaFont.usernameFont(),
        color: .luminaDarkNavy,
        lineSpacing: 4.0,
        kerning: -0.4
    )
    
    // MARK: 2. Date Picker / Timeline
    
    /// "October 2023" — Inter SemiBold 18px / #0F172A / kerning: -0.01em
    static let monthYear = LuminaTypography(
        font: LuminaFont.monthYearFont(),
        color: .luminaDarkNavy,
        lineSpacing: 3.6,
        kerning: -0.18
    )
    
    /// Day label unselected ("Mon") — Inter Medium 12px / #94A3B8
    static let dayLabel = LuminaTypography(
        font: LuminaFont.dayLabelFont(),
        color: .luminaLightSlate,
        lineSpacing: 2.4
    )
    
    /// Day label selected ("Wed") — Inter Medium 12px / #FFFFFF
    static let dayLabelSelected = LuminaTypography(
        font: LuminaFont.dayLabelSelectedFont(),
        color: .white,
        lineSpacing: 2.4
    )
    
    /// Date number unselected ("12") — Inter Bold 16px / #0F172A / kerning: -0.01em
    static let dateNumber = LuminaTypography(
        font: LuminaFont.dateNumberFont(),
        color: .luminaDarkNavy,
        lineSpacing: 0,
        kerning: -0.16
    )
    
    /// Date number selected ("14") — Inter Bold 16px / #FFFFFF / kerning: -0.01em
    static let dateNumberSelected = LuminaTypography(
        font: LuminaFont.dateNumberSelected(),
        color: .white,
        lineSpacing: 0,
        kerning: -0.16
    )
    
    // MARK: 3. Progress Section
    
    /// "Daily Progress" — Inter SemiBold 14px / #64748B
    static let progressHeadline = LuminaTypography(
        font: LuminaFont.progressHeadlineFont(),
        color: .luminaMutedSlate,
        lineSpacing: 2.8
    )
    
    /// "4 of 7 tasks completed" — Inter Bold 18px / #0F172A / kerning: -0.01em
    static let progressState = LuminaTypography(
        font: LuminaFont.progressStateFont(),
        color: .luminaDarkNavy,
        lineSpacing: 3.6,
        kerning: -0.18
    )
    
    // MARK: 4. Main Content Sections
    
    /// "Priority", "Up Next" — Inter Bold 22px / #0F172A / kerning: -0.02em
    static let sectionHeadline = LuminaTypography(
        font: LuminaFont.sectionHeadlineFont(),
        color: .luminaDarkNavy,
        lineSpacing: 4.4,
        kerning: -0.44
    )
    
    // MARK: 5. Task Cards
    
    /// Task title — Inter SemiBold 16px / #0F172A / kerning: -0.01em
    static let taskTitle = LuminaTypography(
        font: LuminaFont.taskTitleFont(),
        color: .luminaDarkNavy,
        lineSpacing: 4.8,
        kerning: -0.16
    )
    
    /// Time metadata ("10:00 AM") — Inter Medium 12px / #94A3B8 / Uppercase
    static let timeMetadata = LuminaTypography(
        font: LuminaFont.timeMetadataFont(),
        color: .luminaLightSlate,
        lineSpacing: 2.4,
        textCase: .uppercase
    )
    
    /// Category tag ("WORK") — Inter Bold 10px / kerning: 0.08em / Uppercase
    /// Renk kullanım yerinde .foregroundColor() ile override edilmeli
    static let tag = LuminaTypography(
        font: LuminaFont.tagFont(),
        color: .clear,
        lineSpacing: 0,
        kerning: 0.8,
        textCase: .uppercase
    )
    
    // MARK: 6. Navigation Bar
    
    /// Nav label unselected — Inter Medium 10px / #94A3B8
    static let navLabelInactive = LuminaTypography(
        font: LuminaFont.navLabelFont(),
        color: .luminaLightSlate,
        lineSpacing: 2.0
    )
    
    /// Nav label selected — Inter Medium 10px / #2563EB
    static let navLabelActive = LuminaTypography(
        font: LuminaFont.navLabelFont(),
        color: .brandBlueColor,
        lineSpacing: 2.0
    )
    
    static let createTaskNavCancel = LuminaTypography(
        font: LuminaFont.createTaskCancelFont(),
        color: .luminaDarkNavy)
    
    static let createTaskHeadline = LuminaTypography(
        font: LuminaFont.createTaskHeadlineFont(),
        color: .createTaskHandle)
    
    static let createTaskDetail = LuminaTypography(
        font: LuminaFont.createTaskDetailsFont(),
        color: .createTaskHandle)
    
    static let createTaskDateChipLabel = LuminaTypography(
        font: LuminaFont.chipLabelFont(),
        color: .chipTodayForeground)
    
    static let createTaskPriorityChipLabel = LuminaTypography(
        font: LuminaFont.chipLabelFont(),
        color: .chipPriorityForeground)
    
    static let createTaskReminderChipLabel = LuminaTypography(
        font: LuminaFont.chipLabelFont(),
        color: .chipReminderForeground)
    
    static let createTaskInboxChipLabel = LuminaTypography(
        font: LuminaFont.chipLabelFont(),
        color: .chipInboxForeground)
    
    static let createTaskSaveButton = LuminaTypography(
        font: LuminaFont.saveTaskLabelFont(),
        color: .saveTaskForeground)
}

// MARK: - ViewModifier
struct LuminaTextStyle: ViewModifier {
    let style: LuminaTypography

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing)
            .kerning(style.kerning)
            .textCase(style.textCase)
    }
}

// MARK: - View Extension
extension View {
    func luminaStyle(_ style: LuminaTypography) -> some View {
        modifier(LuminaTextStyle(style: style))
    }
}
