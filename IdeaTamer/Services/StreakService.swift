import Foundation

enum StreakService {

    // MARK: - Capture Streak

    static func recordCapture(profile: PlayerProfile, date: Date = .now) {
        if let lastDate = profile.captureStreakLastDate {
            if lastDate.isSameDay(as: date) {
                // Already captured today — no-op
                return
            } else if lastDate.isYesterday || Calendar.current.isDate(
                Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!,
                inSameDayAs: date
            ) {
                // Consecutive day
                profile.captureStreakCount += 1
            } else {
                // Missed a day — reset
                profile.captureStreakCount = 1
            }
        } else {
            // First capture ever
            profile.captureStreakCount = 1
        }
        profile.captureStreakLastDate = date
    }

    // MARK: - Focus Streak

    static func recordFocusDay(profile: PlayerProfile, date: Date = .now) {
        if let lastDate = profile.focusStreakLastDate {
            if lastDate.isSameDay(as: date) {
                return
            } else if lastDate.isYesterday || Calendar.current.isDate(
                Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!,
                inSameDayAs: date
            ) {
                profile.focusStreakCount += 1
            } else {
                profile.focusStreakCount = 1
            }
        } else {
            profile.focusStreakCount = 1
        }
        profile.focusStreakLastDate = date
    }

    // MARK: - Reset Check (App Launch)

    static func checkStreakReset(profile: PlayerProfile, date: Date = .now) {
        if let lastCapture = profile.captureStreakLastDate {
            if !lastCapture.isSameDay(as: date) && !lastCapture.isYesterday {
                profile.captureStreakCount = 0
            }
        }
        if let lastFocus = profile.focusStreakLastDate {
            if !lastFocus.isSameDay(as: date) && !lastFocus.isYesterday {
                profile.focusStreakCount = 0
            }
        }
    }
}
