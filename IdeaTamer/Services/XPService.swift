import Foundation

struct XPEvent {
    let amount: Int
    let previousLevel: Int
    let newLevel: Int?

    var didLevelUp: Bool { newLevel != nil }
}

enum XPService {

    // MARK: - Core

    @MainActor
    static func awardXP(
        _ amount: Int,
        profile: PlayerProfile,
        tracker: CurrentWeekTracker
    ) -> XPEvent {
        let previousLevel = profile.currentLevel
        profile.totalXP += amount
        tracker.xpEarned += amount

        let calculatedLevel = XP.levelFor(xp: profile.totalXP)
        if calculatedLevel > previousLevel {
            profile.currentLevel = calculatedLevel
            return XPEvent(amount: amount, previousLevel: previousLevel, newLevel: calculatedLevel)
        }
        return XPEvent(amount: amount, previousLevel: previousLevel, newLevel: nil)
    }

    // MARK: - Convenience

    @MainActor
    static func awardCapture(profile: PlayerProfile, tracker: CurrentWeekTracker) -> XPEvent {
        tracker.ideasCaptured += 1
        return awardXP(XP.capture, profile: profile, tracker: tracker)
    }

    @MainActor
    static func awardScore(profile: PlayerProfile, tracker: CurrentWeekTracker) -> XPEvent {
        awardXP(XP.score, profile: profile, tracker: tracker)
    }

    @MainActor
    static func awardMilestone(profile: PlayerProfile, tracker: CurrentWeekTracker) -> XPEvent {
        tracker.milestonesCompleted += 1
        return awardXP(XP.milestone, profile: profile, tracker: tracker)
    }

    @MainActor
    static func awardQuestComplete(profile: PlayerProfile, tracker: CurrentWeekTracker) -> XPEvent {
        awardXP(XP.questComplete, profile: profile, tracker: tracker)
    }

    @MainActor
    static func awardDuel(profile: PlayerProfile, tracker: CurrentWeekTracker, result: DuelResult) -> XPEvent? {
        switch result {
        case .win:
            return awardXP(XP.duelWin, profile: profile, tracker: tracker)
        case .draw:
            return awardXP(XP.duelDraw, profile: profile, tracker: tracker)
        case .loss:
            return nil
        }
    }
}
