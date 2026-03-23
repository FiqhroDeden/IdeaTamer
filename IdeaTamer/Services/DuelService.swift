import Foundation
import SwiftData

struct DuelRound: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let currentValue: Int
    let pastValue: Int
    var won: Bool { currentValue > pastValue }
    var lost: Bool { pastValue > currentValue }
}

enum DuelService {

    // MARK: - Week Boundary Check

    @MainActor
    static func checkAndCreateSnapshot(context: ModelContext) {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)
        let thisMonday = Date.now.startOfWeek

        guard tracker.weekStartDate < thisMonday else { return }

        // Create snapshot from completed week
        let snapshot = WeeklySnapshot(
            weekStartDate: tracker.weekStartDate,
            xpEarned: tracker.xpEarned,
            milestonesCompleted: tracker.milestonesCompleted,
            ideasCaptured: tracker.ideasCaptured,
            streakDays: tracker.streakDays
        )

        // Find previous snapshot for comparison
        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        let previousSnapshot = try? context.fetch(descriptor).first

        // Compare rounds
        if let previous = previousSnapshot {
            let (won, _) = compareRounds(
                current: snapshot,
                previous: previous
            )
            let result = evaluateResult(roundsWon: won)
            snapshot.duelResult = result

            // Award XP
            let profile = PlayerProfile.fetchOrCreate(context: context)
            _ = XPService.awardDuel(profile: profile, tracker: tracker, result: result)

            if result == .win {
                profile.unlockBadge(.selfSurpassed)
            }
        }

        context.insert(snapshot)
        tracker.reset(for: thisMonday)
    }

    // MARK: - Round Comparison

    static func compareRounds(
        current: WeeklySnapshot,
        previous: WeeklySnapshot
    ) -> (won: Int, lost: Int) {
        var won = 0
        var lost = 0

        if current.xpEarned > previous.xpEarned { won += 1 }
        else if current.xpEarned < previous.xpEarned { lost += 1 }

        if current.milestonesCompleted > previous.milestonesCompleted { won += 1 }
        else if current.milestonesCompleted < previous.milestonesCompleted { lost += 1 }

        if current.ideasCaptured > previous.ideasCaptured { won += 1 }
        else if current.ideasCaptured < previous.ideasCaptured { lost += 1 }

        if current.streakDays > previous.streakDays { won += 1 }
        else if current.streakDays < previous.streakDays { lost += 1 }

        return (won, lost)
    }

    static func buildRounds(
        current: CurrentWeekTracker,
        previous: WeeklySnapshot?
    ) -> [DuelRound] {
        let past = previous ?? WeeklySnapshot(weekStartDate: .now, xpEarned: 0, milestonesCompleted: 0, ideasCaptured: 0, streakDays: 0)
        return [
            DuelRound(name: "XP Earned", icon: "bolt.fill", currentValue: current.xpEarned, pastValue: past.xpEarned),
            DuelRound(name: "Milestones", icon: "checkmark.circle.fill", currentValue: current.milestonesCompleted, pastValue: past.milestonesCompleted),
            DuelRound(name: "Ideas Captured", icon: "lightbulb.fill", currentValue: current.ideasCaptured, pastValue: past.ideasCaptured),
            DuelRound(name: "Streak Days", icon: "flame.fill", currentValue: current.streakDays, pastValue: past.streakDays),
        ]
    }

    // MARK: - Momentum

    static func computeMomentum(currentXP: Int, previousXP: Int) -> Double {
        guard previousXP > 0 else { return 0 }
        let momentum = (Double(currentXP - previousXP) / Double(previousXP)) * 100
        return max(-99, min(999, momentum))
    }

    // MARK: - Result

    static func evaluateResult(roundsWon: Int) -> DuelResult {
        if roundsWon >= 3 { return .win }
        if roundsWon == 2 { return .draw }
        return .loss
    }
}
