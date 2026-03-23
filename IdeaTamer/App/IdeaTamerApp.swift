import SwiftUI
import SwiftData
import WidgetKit

@main
struct IdeaTamerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Idea.self,
            Milestone.self,
            PlayerProfile.self,
            WeeklySnapshot.self,
            CurrentWeekTracker.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    let context = sharedModelContainer.mainContext
                    #if DEBUG
                    SeedDataService.populate(context: context)
                    #endif
                    DuelService.checkAndCreateSnapshot(context: context)
                    let profile = PlayerProfile.fetchOrCreate(context: context)
                    StreakService.checkStreakReset(profile: profile)

                    // Re-schedule notifications if enabled
                    if profile.streakRemindersEnabled {
                        NotificationService.scheduleStreakReminder(
                            hour: profile.streakReminderHour,
                            minute: profile.streakReminderMinute
                        )
                    }
                    if profile.questNudgeEnabled {
                        NotificationService.scheduleQuestNudge()
                    }

                    WidgetService.updateWidgetData(context: context)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
