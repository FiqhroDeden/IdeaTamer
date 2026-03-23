import Foundation
import SwiftData

@Observable
@MainActor
final class ScoringViewModel {
    private let modelContext: ModelContext
    private(set) var lastXPEvent: XPEvent?

    var impactScore: Int = 5
    var effortScore: Int = 5
    var alignmentScore: Int = 5

    var previewScore: Int {
        ScoringFormula.compute(
            impact: impactScore,
            effort: effortScore,
            alignment: alignmentScore
        )
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Actions

    func saveScore(for idea: Idea) {
        idea.impactScore = impactScore
        idea.effortScore = effortScore
        idea.alignmentScore = alignmentScore
        idea.computedScore = previewScore
        idea.status = .parked

        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)

        lastXPEvent = XPService.awardScore(profile: profile, tracker: tracker)
        BadgeService.evaluate(profile: profile, idea: idea)

        if let event = lastXPEvent, event.didLevelUp, let newLevel = event.newLevel {
            NotificationCenter.default.post(name: .leveledUp, object: newLevel)
        }
    }

    func resetSliders() {
        impactScore = 5
        effortScore = 5
        alignmentScore = 5
    }

    /// Load existing scores if re-scoring an idea.
    func loadExistingScores(from idea: Idea) {
        impactScore = idea.impactScore ?? 5
        effortScore = idea.effortScore ?? 5
        alignmentScore = idea.alignmentScore ?? 5
    }
}
