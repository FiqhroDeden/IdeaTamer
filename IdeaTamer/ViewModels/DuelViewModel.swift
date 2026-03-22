import Foundation
import SwiftData

@Observable
@MainActor
final class DuelViewModel {
    private let modelContext: ModelContext

    var rounds: [DuelRound] = []
    var momentum: Double = 0
    var isFirstWeek: Bool = true
    var currentWon: Int = 0
    var currentLost: Int = 0
    var duelHistory: [WeeklySnapshot] = []

    var scoreText: String {
        "\(currentWon) : \(currentLost)"
    }

    var statusText: String {
        if currentWon > currentLost { return "You lead" }
        if currentLost > currentWon { return "Shadow leads" }
        return "Tied"
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func load() {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)

        // Fetch most recent snapshot
        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        let lastSnapshot = try? modelContext.fetch(descriptor).first

        isFirstWeek = lastSnapshot == nil

        // Build rounds (current week vs last snapshot)
        rounds = DuelService.buildRounds(current: tracker, previous: lastSnapshot)

        // Compute current standing
        currentWon = rounds.filter(\.won).count
        currentLost = rounds.filter(\.lost).count

        // Momentum
        if let last = lastSnapshot {
            momentum = DuelService.computeMomentum(
                currentXP: tracker.xpEarned,
                previousXP: last.xpEarned
            )
        }

        // History
        let historyDescriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        duelHistory = (try? modelContext.fetch(historyDescriptor)) ?? []
    }
}
