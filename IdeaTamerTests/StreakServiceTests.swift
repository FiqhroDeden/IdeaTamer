import Foundation
import Testing
import SwiftData
@testable import IdeaTamer

@MainActor
struct StreakServiceTests {

    private func makeProfile() throws -> PlayerProfile {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Idea.self, Milestone.self, PlayerProfile.self,
            WeeklySnapshot.self, CurrentWeekTracker.self,
            configurations: config
        )
        return PlayerProfile.fetchOrCreate(context: container.mainContext)
    }

    @Test func firstCapture_startsStreakAtOne() throws {
        let profile = try makeProfile()
        StreakService.recordCapture(profile: profile)
        #expect(profile.captureStreakCount == 1)
        #expect(profile.captureStreakLastDate != nil)
    }

    @Test func sameDay_doesNotIncrement() throws {
        let profile = try makeProfile()
        let today = Date.now
        StreakService.recordCapture(profile: profile, date: today)
        #expect(profile.captureStreakCount == 1)

        StreakService.recordCapture(profile: profile, date: today)
        #expect(profile.captureStreakCount == 1)
    }

    @Test func consecutiveDay_increments() throws {
        let profile = try makeProfile()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        StreakService.recordCapture(profile: profile, date: yesterday)
        #expect(profile.captureStreakCount == 1)

        StreakService.recordCapture(profile: profile, date: .now)
        #expect(profile.captureStreakCount == 2)
    }

    @Test func missedDay_resetsToOne() throws {
        let profile = try makeProfile()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        StreakService.recordCapture(profile: profile, date: twoDaysAgo)
        profile.captureStreakCount = 5 // Simulate existing streak

        StreakService.recordCapture(profile: profile, date: .now)
        #expect(profile.captureStreakCount == 1)
    }

    @Test func checkStreakReset_resetsOnGap() throws {
        let profile = try makeProfile()
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        profile.captureStreakCount = 7
        profile.captureStreakLastDate = threeDaysAgo

        StreakService.checkStreakReset(profile: profile)
        #expect(profile.captureStreakCount == 0)
    }

    @Test func checkStreakReset_preservesIfYesterday() throws {
        let profile = try makeProfile()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        profile.captureStreakCount = 5
        profile.captureStreakLastDate = yesterday

        StreakService.checkStreakReset(profile: profile)
        #expect(profile.captureStreakCount == 5)
    }

    @Test func focusStreak_worksLikeCapture() throws {
        let profile = try makeProfile()
        StreakService.recordFocusDay(profile: profile)
        #expect(profile.focusStreakCount == 1)
    }
}
