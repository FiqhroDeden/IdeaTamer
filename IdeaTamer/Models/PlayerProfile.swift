import Foundation
import SwiftData

@Model
final class PlayerProfile {
    var totalXP: Int
    var currentLevel: Int
    var captureStreakCount: Int
    var captureStreakLastDate: Date?
    var focusStreakCount: Int
    var focusStreakLastDate: Date?
    var unlockedBadges: [String]
    var questsCompletedCount: Int
    var hasCompletedOnboarding: Bool

    init() {
        self.totalXP = 0
        self.currentLevel = 1
        self.captureStreakCount = 0
        self.focusStreakCount = 0
        self.unlockedBadges = []
        self.questsCompletedCount = 0
        self.hasCompletedOnboarding = false
    }

    // MARK: - Singleton Access

    @MainActor
    static func fetchOrCreate(context: ModelContext) -> PlayerProfile {
        let descriptor = FetchDescriptor<PlayerProfile>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let profile = PlayerProfile()
        context.insert(profile)
        return profile
    }

    // MARK: - Badge Helpers

    func hasBadge(_ badge: BadgeType) -> Bool {
        unlockedBadges.contains(badge.rawValue)
    }

    func unlockBadge(_ badge: BadgeType) {
        guard !hasBadge(badge) else { return }
        unlockedBadges.append(badge.rawValue)
    }
}
