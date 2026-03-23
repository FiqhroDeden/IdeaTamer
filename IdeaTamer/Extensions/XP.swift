import Foundation

enum XP {
    // MARK: - XP Award Constants

    static let capture = 5
    static let score = 25
    static let milestone = 75
    static let questComplete = 500
    static let duelWin = 200
    static let duelDraw = 50
    static let captureStreak = 10
    static let focusStreak = 30

    // MARK: - Level Formula

    /// XP required for a specific level: 100 × level.
    /// Cumulative XP for level N = sum(100 × i for i in 1...N).
    static func levelFor(xp: Int) -> Int {
        var level = 0
        var remaining = xp
        while remaining >= (level + 1) * 100 {
            level += 1
            remaining -= level * 100
        }
        return max(1, level)
    }

    /// XP progress within the current level (0.0 to 1.0).
    static func progressInLevel(xp: Int) -> Double {
        let level = levelFor(xp: xp)
        let cumulativeForLevel = (1...level).reduce(0) { $0 + $1 * 100 }
        let xpIntoCurrentLevel = xp - cumulativeForLevel
        let xpNeededForNext = (level + 1) * 100
        return Double(xpIntoCurrentLevel) / Double(xpNeededForNext)
    }

    // MARK: - Level Titles

    static let levelTitles: [Int: String] = [
        1: "Spark",
        5: "Flame",
        10: "Creator",
        15: "Legendary Creator",
        20: "Grandmaster",
        25: "Legend",
    ]

    /// Returns the title for the given level (uses highest matching threshold).
    static func title(for level: Int) -> String {
        let sortedKeys = levelTitles.keys.sorted(by: >)
        for key in sortedKeys {
            if level >= key {
                return levelTitles[key] ?? "Spark"
            }
        }
        return "Spark"
    }
}
