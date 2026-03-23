import SwiftUI
import UIKit

// MARK: - Color Hex Initializer

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Hero Blue — "You, right now"

extension Color {
    static let heroBG    = Color(light: Color(hex: "EBF2FF"), dark: Color(hex: "1A2740"))
    static let heroLight = Color(hex: "A8C8FF")
    static let heroMid   = Color(hex: "4D8FFF")
    static let hero      = Color(hex: "1B6EF2")
    static let heroDim   = Color(hex: "0A4FBD")
    static let heroDeep  = Color(hex: "0A3578")
}

// MARK: - Rival Red — "Past you, the enemy"

extension Color {
    static let rivalBG    = Color(light: Color(hex: "FFF0ED"), dark: Color(hex: "3D1F18"))
    static let rivalLight = Color(hex: "FFB8AA")
    static let rivalMid   = Color(hex: "FF6B52")
    static let rival      = Color(hex: "E5432A")
    static let rivalDim   = Color(hex: "B22D18")
    static let rivalDeep  = Color(hex: "721C0F")
}

// MARK: - Victory Emerald — completions, XP, success

extension Color {
    static let victoryBG    = Color(light: Color(hex: "E6F7EF"), dark: Color(hex: "1A3328"))
    static let victoryLight = Color(hex: "5CE0A0")
    static let victory      = Color(hex: "12B76A")
    static let victoryDim   = Color(hex: "0D7A48")
}

// MARK: - Streak Amber — streaks, urgency, rewards

extension Color {
    static let streakBG    = Color(light: Color(hex: "FFF6E5"), dark: Color(hex: "3D2E0A"))
    static let streakLight = Color(hex: "FFCB57")
    static let streak      = Color(hex: "F5A623")
    static let streakDim   = Color(hex: "B87A0A")
}

// MARK: - Surface Neutrals (adaptive for dark mode)

extension Color {
    static let surface     = Color(light: Color(hex: "F8F7F6"), dark: Color(hex: "1C1C1E"))
    static let surfaceLow  = Color(light: Color(hex: "F1F0EF"), dark: Color(hex: "2C2C2E"))
    static let surfaceHigh = Color(light: Color(hex: "E3E2E0"), dark: Color(hex: "3A3A3C"))
    static let card        = Color(light: .white, dark: Color(hex: "2C2C2E"))
    static let textPrimary = Color(light: Color(hex: "2E2F2F"), dark: Color(hex: "F5F5F5"))
    static let textMid     = Color(light: Color(hex: "5B5C5B"), dark: Color(hex: "ABABAB"))
    static let textLight   = Color(light: Color(hex: "8A8B8A"), dark: Color(hex: "787878"))
}

// MARK: - Light/Dark Color Helper

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Adaptive Shadow

extension Color {
    /// Card shadow that's visible in both light and dark modes.
    static let cardShadow = Color(light: Color(hex: "0A3578").opacity(0.07), dark: Color.black.opacity(0.25))
}

// MARK: - Score Color Coding

extension Color {
    static func scoreColor(_ score: Int) -> Color {
        if score >= 70 { return .victory }
        if score >= 40 { return .streak }
        return .hero
    }
}
