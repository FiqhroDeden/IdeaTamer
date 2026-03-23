import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
final class FocusViewModel {
    private let modelContext: ModelContext
    var activeQuest: Idea?
    private(set) var lastXPEvent: XPEvent?
    private(set) var newBadges: [BadgeType] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchActiveQuest()
    }

    // MARK: - Quest Management

    func fetchActiveQuest() {
        let activeStatus = IdeaStatus.active.rawValue
        var descriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.statusRaw == activeStatus }
        )
        descriptor.fetchLimit = 1
        activeQuest = try? modelContext.fetch(descriptor).first
    }

    func activateIdea(_ idea: Idea) throws {
        let activeStatus = IdeaStatus.active.rawValue
        let descriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.statusRaw == activeStatus }
        )
        let activeCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        guard activeCount == 0 else {
            throw IdeaTamerError.questAlreadyActive
        }
        idea.status = .active
        idea.activatedAt = .now
        activeQuest = idea
    }

    func parkQuest(_ idea: Idea) {
        idea.status = .parked
        idea.activatedAt = nil
        activeQuest = nil
    }

    func completeQuest(_ idea: Idea) {
        Haptics.success()
        idea.status = .completed
        idea.completedAt = .now
        if let activatedAt = idea.activatedAt {
            idea.completionDays = Date.daysBetween(activatedAt, and: .now)
        }

        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)

        profile.questsCompletedCount += 1
        lastXPEvent = XPService.awardQuestComplete(profile: profile, tracker: tracker)
        idea.xpEarned += XP.questComplete
        newBadges = BadgeService.evaluate(profile: profile, idea: idea)

        if let event = lastXPEvent, event.didLevelUp, let newLevel = event.newLevel {
            NotificationCenter.default.post(name: .leveledUp, object: newLevel)
        }

        activeQuest = nil
    }

    // MARK: - Milestone Management

    func addMilestone(to idea: Idea, title: String) {
        let nextOrder = (idea.milestones.map(\.sortOrder).max() ?? -1) + 1
        let milestone = Milestone(title: title, sortOrder: nextOrder, idea: idea)
        modelContext.insert(milestone)
        idea.milestones.append(milestone)
    }

    func completeMilestone(_ milestone: Milestone) {
        Haptics.medium()
        milestone.isCompleted = true
        milestone.completedAt = .now

        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)

        lastXPEvent = XPService.awardMilestone(profile: profile, tracker: tracker)
        milestone.idea?.xpEarned += XP.milestone

        if let event = lastXPEvent, event.didLevelUp, let newLevel = event.newLevel {
            NotificationCenter.default.post(name: .leveledUp, object: newLevel)
        }
    }

    func uncompleteMilestone(_ milestone: Milestone) {
        milestone.isCompleted = false
        milestone.completedAt = nil
    }

    func deleteMilestone(_ milestone: Milestone) {
        if let idea = milestone.idea {
            idea.milestones.removeAll { $0.id == milestone.id }
        }
        modelContext.delete(milestone)
    }

    func reorderMilestones(_ idea: Idea, from source: IndexSet, to destination: Int) {
        var sorted = idea.milestones.sorted { $0.sortOrder < $1.sortOrder }
        sorted.move(fromOffsets: source, toOffset: destination)
        for (index, milestone) in sorted.enumerated() {
            milestone.sortOrder = index
        }
    }
}
