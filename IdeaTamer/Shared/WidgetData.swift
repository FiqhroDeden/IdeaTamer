import Foundation

/// Lightweight data bridge between main app and widget extension.
/// Stored in shared UserDefaults via App Groups.
struct WidgetData: Codable {
    // MARK: - Active Quest

    var activeQuestTitle: String?
    var activeQuestMilestoneTotal: Int
    var activeQuestMilestoneCompleted: Int
    var activeQuestActivatedAt: Date?

    // MARK: - Player Stats

    var totalXP: Int
    var currentLevel: Int
    var levelTitle: String
    var captureStreakCount: Int
    var focusStreakCount: Int
    var questsCompletedCount: Int

    // MARK: - Weekly Stats

    var weeklyXP: Int

    // MARK: - Meta

    var lastUpdated: Date

    // MARK: - Shared UserDefaults

    static let suiteName = "group.app.fiqhrodedhen.IdeaTamer"
    static let key = "widgetData"

    static var empty: WidgetData {
        WidgetData(
            activeQuestTitle: nil,
            activeQuestMilestoneTotal: 0,
            activeQuestMilestoneCompleted: 0,
            activeQuestActivatedAt: nil,
            totalXP: 0,
            currentLevel: 1,
            levelTitle: "Spark",
            captureStreakCount: 0,
            focusStreakCount: 0,
            questsCompletedCount: 0,
            weeklyXP: 0,
            lastUpdated: .now
        )
    }

    static func load() -> WidgetData {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(WidgetData.self, from: data)
        else {
            return .empty
        }
        return decoded
    }

    func save() {
        guard let defaults = UserDefaults(suiteName: WidgetData.suiteName),
              let data = try? JSONEncoder().encode(self)
        else { return }
        defaults.set(data, forKey: WidgetData.key)
    }
}
