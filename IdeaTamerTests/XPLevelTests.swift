import Testing
@testable import IdeaTamer

struct XPLevelTests {

    // MARK: - Level Calculation

    @Test func zeroXP_returnsLevelOne() {
        #expect(XP.levelFor(xp: 0) == 1)
    }

    @Test func ninetyNineXP_returnsLevelOne() {
        // Level 1 requires 100 XP, so 99 is still level 1 (via max(1, 0))
        #expect(XP.levelFor(xp: 99) == 1)
    }

    @Test func hundredXP_returnsLevelOne() {
        // 100 XP = exactly level 1 threshold (100×1), remaining = 0
        #expect(XP.levelFor(xp: 100) == 1)
    }

    @Test func threeHundredXP_returnsLevelTwo() {
        // Level 1 = 100, Level 2 = 200. Cumulative = 300.
        #expect(XP.levelFor(xp: 300) == 2)
    }

    @Test func fifteenHundredXP_returnsLevelFive() {
        // Cumulative: 100 + 200 + 300 + 400 + 500 = 1500
        #expect(XP.levelFor(xp: 1500) == 5)
    }

    @Test func sixThousandXP_returnsLevelTen() {
        // Cumulative for level 10 = sum(100×i for i in 1...10) = 5500
        // 6000 - 5500 = 500 remaining, next level needs 1100, so still 10
        #expect(XP.levelFor(xp: 6000) == 10)
    }

    // MARK: - Level Titles

    @Test func levelOne_titleIsSpark() {
        #expect(XP.title(for: 1) == "Spark")
    }

    @Test func levelFive_titleIsFlame() {
        #expect(XP.title(for: 5) == "Flame")
    }

    @Test func levelTen_titleIsCreator() {
        #expect(XP.title(for: 10) == "Creator")
    }

    @Test func levelThree_titleIsSpark() {
        // Level 3 is between 1 and 5, should get highest matching = "Spark"
        #expect(XP.title(for: 3) == "Spark")
    }

    @Test func levelTwentyFive_titleIsLegend() {
        #expect(XP.title(for: 25) == "Legend")
    }

    // MARK: - Progress in Level

    @Test func progressInLevel_returnsValueBetweenZeroAndOne() {
        let progress = XP.progressInLevel(xp: 150)
        #expect(progress >= 0.0 && progress <= 1.0)
    }

    @Test func progressInLevel_atLevelBoundary_returnsZero() {
        // At exactly 300 XP (level 2 cumulative), progress into next level = 0
        let progress = XP.progressInLevel(xp: 300)
        #expect(progress == 0.0)
    }

    // MARK: - XP Constants

    @Test func xpConstants_areCorrect() {
        #expect(XP.capture == 10)
        #expect(XP.score == 25)
        #expect(XP.milestone == 50)
        #expect(XP.questComplete == 500)
        #expect(XP.duelWin == 200)
        #expect(XP.duelDraw == 50)
        #expect(XP.captureStreak == 15)
        #expect(XP.focusStreak == 20)
    }
}
