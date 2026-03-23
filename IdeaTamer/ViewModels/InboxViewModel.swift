import Foundation
import SwiftData

@Observable
@MainActor
final class InboxViewModel {
    private let modelContext: ModelContext
    private(set) var lastXPEvent: XPEvent?

    static let unscoredCap = 10

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Inbox Cap

    var unscoredCount: Int {
        let inboxStatus = IdeaStatus.inbox.rawValue
        let descriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.statusRaw == inboxStatus && $0.computedScore == nil }
        )
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    var isInboxFull: Bool { unscoredCount >= Self.unscoredCap }

    // MARK: - Actions

    @discardableResult
    func captureIdea(title: String, description: String? = nil) throws -> Idea {
        guard !isInboxFull else { throw IdeaTamerError.inboxFull }

        Haptics.light()
        let idea = Idea(title: title, descriptionText: description)
        modelContext.insert(idea)

        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)

        lastXPEvent = XPService.awardCapture(profile: profile, tracker: tracker)
        StreakService.recordCapture(profile: profile)
        BadgeService.evaluate(profile: profile)

        if let event = lastXPEvent, event.didLevelUp, let newLevel = event.newLevel {
            NotificationCenter.default.post(name: .leveledUp, object: newLevel)
        }

        WidgetService.updateWidgetData(context: modelContext)
        return idea
    }

    func deleteIdea(_ idea: Idea) {
        modelContext.delete(idea)
        WidgetService.updateWidgetData(context: modelContext)
    }

    func parkIdea(_ idea: Idea) {
        guard idea.isScored else { return }
        idea.status = .parked
        WidgetService.updateWidgetData(context: modelContext)
    }

    func activateIdea(_ idea: Idea) throws {
        guard idea.isScored else { return }
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
        WidgetService.updateWidgetData(context: modelContext)
    }
}
