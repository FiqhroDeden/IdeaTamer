import Testing
import SwiftData
@testable import IdeaTamer

@MainActor
struct BadgeServiceTests {

    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Idea.self, Milestone.self, PlayerProfile.self,
            WeeklySnapshot.self, CurrentWeekTracker.self,
            configurations: config
        )
        return container.mainContext
    }

    @Test func firstBlood_unlocksOnFirstQuestComplete() throws {
        let context = try makeContext()
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.questsCompletedCount = 1

        let badges = BadgeService.evaluate(profile: profile)
        #expect(badges.contains(.firstBlood))
        #expect(profile.hasBadge(.firstBlood))
    }

    @Test func streak7_unlocksOnSevenDayStreak() throws {
        let context = try makeContext()
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.captureStreakCount = 7

        let badges = BadgeService.evaluate(profile: profile)
        #expect(badges.contains(.streak7))
    }

    @Test func polisher_unlocksOnScoreAbove90() throws {
        let context = try makeContext()
        let profile = PlayerProfile.fetchOrCreate(context: context)
        let idea = Idea(title: "High Scorer")
        idea.computedScore = 95
        context.insert(idea)

        let badges = BadgeService.evaluate(profile: profile, idea: idea)
        #expect(badges.contains(.polisher))
    }

    @Test func moonshot_unlocksOnTenQuests() throws {
        let context = try makeContext()
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.questsCompletedCount = 10

        let badges = BadgeService.evaluate(profile: profile)
        #expect(badges.contains(.moonshot))
    }

    @Test func noDuplicateUnlocks() throws {
        let context = try makeContext()
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.questsCompletedCount = 1

        let first = BadgeService.evaluate(profile: profile)
        #expect(first.contains(.firstBlood))

        let second = BadgeService.evaluate(profile: profile)
        #expect(!second.contains(.firstBlood))
        #expect(second.isEmpty)
    }

    @Test func superFocus_unlocksWithFivePlusMilestones() throws {
        let context = try makeContext()
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

    @Test func streakMaster_unlocksOnThirtyDayStreak() throws {
        let context = try makeContext()
        let profile = PlayerProfile.fetchOrCreate(context: context)
        profile.captureStreakCount = 30

        let badges = BadgeService.evaluate(profile: profile)
        #expect(badges.contains(.streakMaster))
    }
}
