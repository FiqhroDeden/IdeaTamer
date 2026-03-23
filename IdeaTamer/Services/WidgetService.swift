import Foundation
import SwiftData
import WidgetKit

/// Updates widget data from current SwiftData state and triggers widget refresh.
enum WidgetService {
    @MainActor
    static func updateWidgetData(context: ModelContext) {
        // Fetch active quest
        let activeStatus = IdeaStatus.active.rawValue
        var questDescriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.statusRaw == activeStatus }
        )
        questDescriptor.fetchLimit = 1
        let activeQuest = try? context.fetch(questDescriptor).first

        // Fetch singletons
        let profile = PlayerProfile.fetchOrCreate(context: context)
        let tracker = CurrentWeekTracker.fetchOrCreate(context: context)

        let data = WidgetData(
            activeQuestTitle: activeQuest?.title,
            activeQuestMilestoneTotal: activeQuest?.milestones.count ?? 0,
            activeQuestMilestoneCompleted: activeQuest?.completedMilestoneCount ?? 0,
            activeQuestActivatedAt: activeQuest?.activatedAt,
            totalXP: profile.totalXP,
            currentLevel: profile.currentLevel,
            levelTitle: XP.title(for: profile.currentLevel),
            captureStreakCount: profile.captureStreakCount,
            focusStreakCount: profile.focusStreakCount,
            questsCompletedCount: profile.questsCompletedCount,
            weeklyXP: tracker.xpEarned,
            lastUpdated: .now
        )

        data.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
