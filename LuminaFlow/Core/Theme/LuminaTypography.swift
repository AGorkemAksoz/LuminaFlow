//
//  LuminaTypography.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.03.2026.
//

import SwiftUI

enum InterFont: String {
    case light = "Inter18pt-Light"       // Konsolundaki tam isim
    case regular = "Inter24pt-Regular"   // Konsolundaki tam isim
    case semibold = "Inter24pt-SemiBold" // Konsolundaki tam isim
    case bold = "Inter28pt-Bold"         // Konsolundaki tam isim
}

struct LuminaTypography {
    
    // Headline Large (Semibold - 24pt ailesinden)
    static func headlineLarge() -> Font {
        .custom(InterFont.semibold.rawValue, size: 32)
    }
    
    // Subheading Medium (Regular - 24pt ailesinden)
    static func subheadingMedium() -> Font {
        .custom(InterFont.regular.rawValue, size: 20)
    }
    
    // Body (Regular - 24pt veya 18pt seçilebilir, 18pt daha okunaklıdır)
    static func body() -> Font {
        .custom(InterFont.regular.rawValue, size: 16)
    }
    
    // Small Label Caps (Light - 18pt ailesinden)
    static func smallLabelCaps() -> Font {
        .custom(InterFont.light.rawValue, size: 12)
    }
}

struct LuminaTextStyle: ViewModifier {
    enum Style {
        case headline, subheading, body, smallCaps
    }
    
    var style: Style
    
    func body(content: Content) -> some View {
        switch style {
        case .headline:
            content
                .font(LuminaTypography.headlineLarge())
                .foregroundColor(Color.luminaPrimaryAction) // Siyah tonu
                .lineSpacing(4)
                
        case .subheading:
            content
                .font(LuminaTypography.subheadingMedium())
                .foregroundColor(Color.luminaPrimaryAction)
                
        case .body:
            content
                .font(LuminaTypography.body())
                .foregroundColor(.secondary) // Açıklamalar için gri tonu
                
        case .smallCaps:
            content
                .font(LuminaTypography.smallLabelCaps())
                .textCase(.uppercase)
                .kerning(1.5) // Harf arası açma, "Caps" görünümü için şarttır
                .foregroundColor(Color.luminaAccentBlue)
        }
    }
}

extension View {
    func luminaStyle(_ style: LuminaTextStyle.Style) -> some View {
        self.modifier(LuminaTextStyle(style: style))
    }
}
