import Foundation
import Testing
import SwiftData
@testable import IdeaTamer

@MainActor
struct StreakServiceTests {

    private func withProfile(_ body: (PlayerProfile) throws -> Void) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Idea.self, Milestone.self, PlayerProfile.self,
            WeeklySnapshot.self, CurrentWeekTracker.self,
            configurations: config
        )
        let profile = PlayerProfile.fetchOrCreate(context: container.mainContext)
        try body(profile)
        withExtendedLifetime(container) {}
    }

    @Test func firstCapture_startsStreakAtOne() throws {
        try withProfile { profile in
            StreakService.recordCapture(profile: profile)
            #expect(profile.captureStreakCount == 1)
            #expect(profile.captureStreakLastDate != nil)
        }
    }

    @Test func sameDay_doesNotIncrement() throws {
        try withProfile { profile in
            let today = Date.now
            StreakService.recordCapture(profile: profile, date: today)
            #expect(profile.captureStreakCount == 1)

            StreakService.recordCapture(profile: profile, date: today)
            #expect(profile.captureStreakCount == 1)
        }
    }

    @Test func consecutiveDay_increments() throws {
        try withProfile { profile in
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            StreakService.recordCapture(profile: profile, date: yesterday)
            #expect(profile.captureStreakCount == 1)

            StreakService.recordCapture(profile: profile, date: .now)
            #expect(profile.captureStreakCount == 2)
        }
    }

    @Test func missedDay_resetsToOne() throws {
        try withProfile { profile in
            let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: .now)!
            StreakService.recordCapture(profile: profile, date: twoDaysAgo)
            profile.captureStreakCount = 5

            StreakService.recordCapture(profile: profile, date: .now)
            #expect(profile.captureStreakCount == 1)
        }
    }

    @Test func checkStreakReset_resetsOnGap() throws {
        try withProfile { profile in
            let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
            profile.captureStreakCount = 7
            profile.captureStreakLastDate = threeDaysAgo

            StreakService.checkStreakReset(profile: profile)
            #expect(profile.captureStreakCount == 0)
        }
    }

    @Test func checkStreakReset_preservesIfYesterday() throws {
        try withProfile { profile in
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            profile.captureStreakCount = 5
            profile.captureStreakLastDate = yesterday

            StreakService.checkStreakReset(profile: profile)
            #expect(profile.captureStreakCount == 5)
        }
    }

    @Test func focusStreak_worksLikeCapture() throws {
        try withProfile { profile in
            StreakService.recordFocusDay(profile: profile)
            #expect(profile.focusStreakCount == 1)
        }
    }
}
