import SwiftUI

extension Animation {
    static let springFast   = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let springMedium = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.85)
}

// MARK: - Duration Constants

enum AnimationDuration {
    static let xpFloat: Double = 1.2
    static let confetti: Double = 2.0
    static let duelBar: Double = 0.7
    static let questComplete: Double = 0.3
    static let progressRing: Double = 0.6
    static let streakFire: Double = 0.5
    static let shadowPulse: Double = 2.0
    static let heroGlow: Double = 2.5
    static let onboardingFloat: Double = 3.0
}
