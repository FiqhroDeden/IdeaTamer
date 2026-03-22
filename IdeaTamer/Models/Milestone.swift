import Foundation
import SwiftData

@Model
final class Milestone {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var completedAt: Date?
    var sortOrder: Int
    var idea: Idea?

    init(title: String, sortOrder: Int, idea: Idea? = nil) {
        self.id = UUID()
        self.title = String(title.prefix(200))
        self.isCompleted = false
        self.sortOrder = sortOrder
        self.idea = idea
    }
}
