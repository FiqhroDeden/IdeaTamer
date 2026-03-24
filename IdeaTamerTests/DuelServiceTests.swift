import Foundation
import Testing
import SwiftData
@testable import IdeaTamer

struct DuelServiceTests {

    // MARK: - Round Comparison

    @Test func compareRounds_allWin() {
        let current = WeeklySnapshot(weekStartDate: .now, xpEarned: 100, milestonesCompleted: 5, ideasCaptured: 10, questsCompleted: 2, streakDays: 7)
        let previous = WeeklySnapshot(weekStartDate: .now, xpEarned: 50, milestonesCompleted: 3, ideasCaptured: 5, questsCompleted: 1, streakDays: 3)

        let (won, lost) = DuelService.compareRounds(current: current, previous: previous)
        #expect(won == 4)
        #expect(lost == 0)
    }

    @Test func compareRounds_mixed() {
        let current = WeeklySnapshot(weekStartDate: .now, xpEarned: 100, milestonesCompleted: 2, ideasCaptured: 10, questsCompleted: 2, streakDays: 3)
        let previous = WeeklySnapshot(weekStartDate: .now, xpEarned: 50, milestonesCompleted: 5, ideasCaptured: 5, questsCompleted: 1, streakDays: 7)

        let (won, lost) = DuelService.compareRounds(current: current, previous: previous)
        #expect(won == 2) // XP and quests shipped
        #expect(lost == 2) // milestones and streaks
    }

    @Test func compareRounds_tied() {
        let current = WeeklySnapshot(weekStartDate: .now, xpEarned: 50, milestonesCompleted: 3, ideasCaptured: 5, questsCompleted: 1, streakDays: 7)
        let previous = WeeklySnapshot(weekStartDate: .now, xpEarned: 50, milestonesCompleted: 3, ideasCaptured: 5, questsCompleted: 1, streakDays: 7)

        let (won, lost) = DuelService.compareRounds(current: current, previous: previous)
        #expect(won == 0)
        #expect(lost == 0)
    }

    // MARK: - Momentum

    @Test func momentum_positive() {
        let momentum = DuelService.computeMomentum(currentXP: 110, previousXP: 100)
        #expect(momentum == 10.0)
    }

    @Test func momentum_negative() {
        let momentum = DuelService.computeMomentum(currentXP: 50, previousXP: 100)
        #expect(momentum == -50.0)
    }

    @Test func momentum_zeroDivision() {
        let momentum = DuelService.computeMomentum(currentXP: 100, previousXP: 0)
        #expect(momentum == 0)
    }

    @Test func momentum_clampedMax() {
        let momentum = DuelService.computeMomentum(currentXP: 10000, previousXP: 1)
        #expect(momentum == 999)
    }

    // MARK: - Result Determination

    @Test func result_threeWins_isWin() {
        #expect(DuelService.evaluateResult(roundsWon: 3) == .win)
        #expect(DuelService.evaluateResult(roundsWon: 4) == .win)
    }

    @Test func result_twoWins_isDraw() {
        #expect(DuelService.evaluateResult(roundsWon: 2) == .draw)
    }

    @Test func result_oneOrZeroWins_isLoss() {
        #expect(DuelService.evaluateResult(roundsWon: 1) == .loss)
        #expect(DuelService.evaluateResult(roundsWon: 0) == .loss)
    }
}
