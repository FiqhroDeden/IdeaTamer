import Foundation
import SwiftData

@Observable
@MainActor
final class DoneViewModel {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Computed Stats

    func fetchCompletedIdeas() -> [Idea] {
        let completedStatus = IdeaStatus.completed.rawValue
        let descriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.statusRaw == completedStatus },
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func totalXPFromCompleted() -> Int {
        fetchCompletedIdeas().reduce(0) { $0 + $1.xpEarned }
    }

    func averageCompletionDays() -> Double {
        let ideas = fetchCompletedIdeas()
        let withDays = ideas.compactMap(\.completionDays)
        guard !withDays.isEmpty else { return 0 }
        return Double(withDays.reduce(0, +)) / Double(withDays.count)
    }
}
