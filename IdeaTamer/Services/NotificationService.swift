import Foundation
import UserNotifications

enum NotificationService {

    // MARK: - Permission

    static func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    static func checkPermissionStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    // MARK: - Streak Reminder

    static func scheduleStreakReminder(hour: Int = 21, minute: Int = 0) {
        cancelStreakReminder()

        let content = UNMutableNotificationContent()
        content.title = "Keep your focus alive!"
        content.body = "Make progress on your quest today to keep your streak going. 🔥"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "streak-reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Quest Nudge

    static func scheduleQuestNudge() {
        let content = UNMutableNotificationContent()
        content.title = "Your quest is waiting"
        content.body = "Make progress on your active quest today. Every milestone counts! ⚡"
        content.sound = .default

        // Fire after 48 hours of inactivity
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 48 * 3600, repeats: false)
        let request = UNNotificationRequest(
            identifier: "quest-nudge",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// Re-schedule quest nudge (call after each milestone completion)
    static func resetQuestNudge() {
        cancelQuestNudge()
        scheduleQuestNudge()
    }

    // MARK: - Target Date Reminder

    static func scheduleTargetDateReminder(questTitle: String, targetDate: Date) {
        cancelTargetDateReminders()

        let center = UNUserNotificationCenter.current()

        // Day-of reminder (9:00 AM on target date)
        let dayOfContent = UNMutableNotificationContent()
        dayOfContent.title = "Target date is today!"
        dayOfContent.body = "Your quest \"\(questTitle)\" deadline is today. Time to ship! 🎯"
        dayOfContent.sound = .default

        var dayOfComponents = Calendar.current.dateComponents([.year, .month, .day], from: targetDate)
        dayOfComponents.hour = 9
        dayOfComponents.minute = 0

        let dayOfTrigger = UNCalendarNotificationTrigger(dateMatching: dayOfComponents, repeats: false)
        let dayOfRequest = UNNotificationRequest(
            identifier: "target-date-reminder",
            content: dayOfContent,
            trigger: dayOfTrigger
        )
        center.add(dayOfRequest)

        // Eve reminder (9:00 AM, one day before target date)
        guard let eve = Calendar.current.date(byAdding: .day, value: -1, to: targetDate),
              eve > .now else { return }

        let eveContent = UNMutableNotificationContent()
        eveContent.title = "1 day left"
        eveContent.body = "Your quest \"\(questTitle)\" deadline is tomorrow. Final push! ⏱"
        eveContent.sound = .default

        var eveComponents = Calendar.current.dateComponents([.year, .month, .day], from: eve)
        eveComponents.hour = 9
        eveComponents.minute = 0

        let eveTrigger = UNCalendarNotificationTrigger(dateMatching: eveComponents, repeats: false)
        let eveRequest = UNNotificationRequest(
            identifier: "target-date-eve-reminder",
            content: eveContent,
            trigger: eveTrigger
        )
        center.add(eveRequest)
    }

    static func cancelTargetDateReminders() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [
                "target-date-reminder",
                "target-date-eve-reminder",
            ])
    }

    // MARK: - Cancel

    static func cancelStreakReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["streak-reminder"])
    }

    static func cancelQuestNudge() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["quest-nudge"])
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
