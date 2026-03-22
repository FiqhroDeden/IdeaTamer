import Foundation
import SwiftData

@Model
final class Idea {
    var id: UUID
    var title: String
    var descriptionText: String?
    var impactScore: Int?
    var effortScore: Int?
    var alignmentScore: Int?
    var computedScore: Int?
    var statusRaw: String
    var xpEarned: Int
    var createdAt: Date
    var activatedAt: Date?
    var completedAt: Date?
    var completionDays: Int?

    @Relationship(deleteRule: .cascade, inverse: \Milestone.idea)
    var milestones: [Milestone]

    // MARK: - Computed

    var status: IdeaStatus {
        get { IdeaStatus(rawValue: statusRaw) ?? .inbox }
        set { statusRaw = newValue.rawValue }
    }

    var isScored: Bool { computedScore != nil }

    var completedMilestoneCount: Int {
        milestones.filter(\.isCompleted).count
    }

    var milestoneProgress: Double {
        guard !milestones.isEmpty else { return 0 }
        return Double(completedMilestoneCount) / Double(milestones.count)
    }

    // MARK: - Init

    init(
        title: String,
        descriptionText: String? = nil,
        status: IdeaStatus = .inbox
    ) {
        self.id = UUID()
        self.title = String(title.prefix(120))
        self.descriptionText = descriptionText
        self.statusRaw = status.rawValue
        self.xpEarned = 0
        self.createdAt = .now
        self.milestones = []
    }
}
