import Foundation

enum BadgeService {

    /// Evaluates all badge conditions and unlocks any newly earned badges.
    /// Returns the list of newly unlocked badges.
    @discardableResult
    static func evaluate(profile: PlayerProfile, idea: Idea? = nil) -> [BadgeType] {
        var newBadges: [BadgeType] = []

        // First Blood — complete first quest
        if !profile.hasBadge(.firstBlood) && profile.questsCompletedCount >= 1 {
            profile.unlockBadge(.firstBlood)
            newBadges.append(.firstBlood)
        }

        // 7-Day Focus Streak
        if !profile.hasBadge(.streak7) && profile.focusStreakCount >= 7 {
            profile.unlockBadge(.streak7)
            newBadges.append(.streak7)
        }

        // Super Focus — complete quest with 5+ milestones
        if !profile.hasBadge(.superFocus),
           let idea,
           idea.status == .completed,
           idea.milestones.count >= 5 {
            profile.unlockBadge(.superFocus)
            newBadges.append(.superFocus)
        }

        // Polisher — score an idea ≥90
        if !profile.hasBadge(.polisher),
           let idea,
           let score = idea.computedScore,
           score >= 90 {
            profile.unlockBadge(.polisher)
            newBadges.append(.polisher)
        }

        // Self Surpassed — checked in DuelService (Sprint 6)
        // Skipped here

        // Moonshot — complete 10 quests
        if !profile.hasBadge(.moonshot) && profile.questsCompletedCount >= 10 {
            profile.unlockBadge(.moonshot)
            newBadges.append(.moonshot)
        }

        // Streak Master — 30-day focus streak
        if !profile.hasBadge(.streakMaster) && profile.focusStreakCount >= 30 {
            profile.unlockBadge(.streakMaster)
            newBadges.append(.streakMaster)
        }

        return newBadges
    }
}
