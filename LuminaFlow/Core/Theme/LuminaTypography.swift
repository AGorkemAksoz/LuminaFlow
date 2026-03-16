//
//  LuminaTypography.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

struct LuminaTypography {
    static func headlineLarge() -> Font {
        .custom("Inter-SemiBold", size: 32)
    }
    
    static func subheadingMedium() -> Font {
            .custom("Inter-Medium", size: 18)
        }
        
    static func smallLabelCaps() -> Font {
        .custom("Inter-Regular", size: 12).uppercaseSmallCaps()
    }
}
