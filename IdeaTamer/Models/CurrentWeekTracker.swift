import Foundation
import SwiftData

@Model
final class CurrentWeekTracker {
    var weekStartDate: Date
    var xpEarned: Int
    var milestonesCompleted: Int
    var ideasCaptured: Int
    var questsCompleted: Int
    var streakDays: Int

    init() {
        self.weekStartDate = Date.now.startOfWeek
        self.xpEarned = 0
        self.milestonesCompleted = 0
        self.ideasCaptured = 0
        self.questsCompleted = 0
        self.streakDays = 0
    }

    // MARK: - Singleton Access

    @MainActor
    static func fetchOrCreate(context: ModelContext) -> CurrentWeekTracker {
        let descriptor = FetchDescriptor<CurrentWeekTracker>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let tracker = CurrentWeekTracker()
        context.insert(tracker)
        return tracker
    }

    // MARK: - Reset

    func reset(for weekStart: Date) {
        self.weekStartDate = weekStart
        self.xpEarned = 0
        self.milestonesCompleted = 0
        self.ideasCaptured = 0
        self.questsCompleted = 0
        self.streakDays = 0
    }
}
