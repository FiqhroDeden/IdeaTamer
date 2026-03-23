import Foundation
import SwiftData

@Observable
@MainActor
final class InboxViewModel {
    private let modelContext: ModelContext
    private(set) var lastXPEvent: XPEvent?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Actions

    @discardableResult
    func captureIdea(title: String, description: String? = nil) -> Idea {
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

        return idea
    }

    func deleteIdea(_ idea: Idea) {
        modelContext.delete(idea)
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
    }
}
