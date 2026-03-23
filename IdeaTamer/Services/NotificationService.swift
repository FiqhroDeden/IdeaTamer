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
        content.title = "Don't break your streak!"
        content.body = "Capture an idea today to keep your streak alive. 🔥"
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
