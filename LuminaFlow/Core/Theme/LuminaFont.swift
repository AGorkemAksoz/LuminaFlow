//
//  LuminaFont.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 23.04.2026.
//

import SwiftUI

// MARK: - Inter Font Enum
enum InterFont: String {
    case regular    = "Inter-Regular"
    case thin       = "Inter-Regular_Thin"
    case extraLight = "Inter-Regular_ExtraLight"
    case light      = "Inter-Regular_Light"
    case medium     = "Inter-Regular_Medium"
    case semiBold   = "Inter-Regular_SemiBold"
    case bold       = "Inter-Regular_Bold"
    case extraBold  = "Inter-Regular_ExtraBold"
    case black      = "Inter-Regular_Black"
}

struct LuminaFont {
    static func welcomeMessageFont() -> Font {
        .custom(InterFont.regular.rawValue, size: 14)
    }
    
    static func usernameFont() -> Font {
        .custom(InterFont.bold.rawValue, size: 20)
    }
    
    static func monthYearFont() -> Font {
        .custom(InterFont.semiBold.rawValue, size: 18)
    }
    
    static func dayLabelFont() -> Font {
        .custom(InterFont.medium.rawValue, size: 12)
    }
    
    static func dayLabelSelectedFont() -> Font {
        .custom(InterFont.medium.rawValue, size: 12)
    }
    
    static func dateNumberFont() -> Font {
        .custom(InterFont.bold.rawValue, size: 16)
    }
    
    static func dateNumberSelected() -> Font {
        .custom(InterFont.bold.rawValue, size: 16)
    }
    
    static func progressHeadlineFont() -> Font {
        .custom(InterFont.semiBold.rawValue, size: 14)
    }
    
    static func progressStateFont() -> Font {
        .custom(InterFont.bold.rawValue, size: 18)
    }
    
    static func sectionHeadlineFont() -> Font {
        .custom(InterFont.bold.rawValue, size: 22)
    }
    
    static func taskTitleFont() -> Font {
        .custom(InterFont.semiBold.rawValue, size: 16)
    }
    
    static func timeMetadataFont() -> Font {
        .custom(InterFont.medium.rawValue, size: 12)
    }
    
    static func tagFont() -> Font {
        .custom(InterFont.bold.rawValue, size: 10)
    }
    
    static func navLabelFont() -> Font {
        .custom(InterFont.medium.rawValue, size: 10)
    }
    
    static func createTaskCancelFont() -> Font { .custom(InterFont.medium.rawValue, size: 16) }
    static func createTaskHeadlineFont() -> Font { .custom(InterFont.bold.rawValue, size: 28) }
    static func createTaskDetailsFont() -> Font { .custom(InterFont.regular.rawValue, size: 16) }
    static func chipLabelFont() -> Font { .custom(InterFont.semiBold.rawValue, size: 14) }
    static func subtaskLabelFont() -> Font { .custom(InterFont.medium.rawValue, size: 14) }
    static func saveTaskLabelFont() -> Font { .custom(InterFont.bold.rawValue, size: 17) }
}
