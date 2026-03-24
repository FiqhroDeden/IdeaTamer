import Foundation
import Testing
import SwiftData
@testable import IdeaTamer

@MainActor
struct BadgeServiceTests {

    private func withContext(_ body: (ModelContext) throws -> Void) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Idea.self, Milestone.self, PlayerProfile.self,
            WeeklySnapshot.self, CurrentWeekTracker.self,
            configurations: config
        )
        try body(container.mainContext)
        withExtendedLifetime(container) {}
    }

    @Test func firstBlood_unlocksOnFirstQuestComplete() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            profile.questsCompletedCount = 1

            let badges = BadgeService.evaluate(profile: profile)
            #expect(badges.contains(.firstBlood))
            #expect(profile.hasBadge(.firstBlood))
        }
    }

    @Test func streak7_unlocksOnSevenDayStreak() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            profile.focusStreakCount = 7

            let badges = BadgeService.evaluate(profile: profile)
            #expect(badges.contains(.streak7))
        }
    }

    @Test func polisher_unlocksOnScoreAbove90() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            let idea = Idea(title: "High Scorer")
            idea.computedScore = 95
            context.insert(idea)

            let badges = BadgeService.evaluate(profile: profile, idea: idea)
            #expect(badges.contains(.polisher))
        }
    }

    @Test func moonshot_unlocksOnTenQuests() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            profile.questsCompletedCount = 10

            let badges = BadgeService.evaluate(profile: profile)
            #expect(badges.contains(.moonshot))
        }
    }

    @Test func noDuplicateUnlocks() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            profile.questsCompletedCount = 1

            let first = BadgeService.evaluate(profile: profile)
            #expect(first.contains(.firstBlood))

            let second = BadgeService.evaluate(profile: profile)
            #expect(!second.contains(.firstBlood))
            #expect(second.isEmpty)
        }
    }

    @Test func superFocus_unlocksWithFivePlusMilestones() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            let idea = Idea(title: "Big Quest", status: .completed)
            context.insert(idea)
            for i in 0..<5 {
                let m = Milestone(title: "M\(i)", sortOrder: i, idea: idea)
                m.isCompleted = true
                context.insert(m)
                idea.milestones.append(m)
            }

            let badges = BadgeService.evaluate(profile: profile, idea: idea)
            #expect(badges.contains(.superFocus))
        }
    }

    @Test func streakMaster_unlocksOnThirtyDayStreak() throws {
        try withContext { context in
            let profile = PlayerProfile.fetchOrCreate(context: context)
            profile.focusStreakCount = 30

            let badges = BadgeService.evaluate(profile: profile)
            #expect(badges.contains(.streakMaster))
        }
    }
}
