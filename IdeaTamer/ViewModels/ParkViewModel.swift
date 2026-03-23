import Foundation
import SwiftData

@Observable
@MainActor
final class ParkViewModel {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Staleness

    static let staleDays = 30

    func isStale(_ idea: Idea) -> Bool {
        let cutoff = Calendar.current.date(byAdding: .day, value: -Self.staleDays, to: .now) ?? .now
        return idea.createdAt < cutoff
    }

    // MARK: - Actions

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
        WidgetService.updateWidgetData(context: modelContext)
    }

    func deleteIdea(_ idea: Idea) {
        modelContext.delete(idea)
        WidgetService.updateWidgetData(context: modelContext)
    }
}
