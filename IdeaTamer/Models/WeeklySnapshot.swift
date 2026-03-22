import Foundation
import SwiftData

@Model
final class WeeklySnapshot {
    var id: UUID
    var weekStartDate: Date
    var xpEarned: Int
    var milestonesCompleted: Int
    var ideasCaptured: Int
    var streakDays: Int
    var duelResultRaw: String?

    var duelResult: DuelResult? {
        get {
            guard let raw = duelResultRaw else { return nil }
            return DuelResult(rawValue: raw)
        }
        set { duelResultRaw = newValue?.rawValue }
    }

    init(
        weekStartDate: Date,
        xpEarned: Int,
        milestonesCompleted: Int,
        ideasCaptured: Int,
        streakDays: Int
    ) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.xpEarned = xpEarned
        self.milestonesCompleted = milestonesCompleted
        self.ideasCaptured = ideasCaptured
        self.streakDays = streakDays
    }
}
