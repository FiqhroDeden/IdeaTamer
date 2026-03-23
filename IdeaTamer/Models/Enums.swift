import Foundation

// MARK: - Notifications

extension Notification.Name {
    static let questCompleted = Notification.Name("questCompleted")
    static let leveledUp = Notification.Name("leveledUp")
}

// MARK: - App Errors

enum IdeaTamerError: Error, LocalizedError {
    case questAlreadyActive
    case inboxFull

    var errorDescription: String? {
        switch self {
        case .questAlreadyActive:
            "You already have an active quest. Complete or park it first."
        case .inboxFull:
            "Inbox is full. Score or remove existing ideas first."
        }
    }
}

// MARK: - Idea Status

enum IdeaStatus: String, Codable, CaseIterable {
    case inbox
    case parked
    case active
    case completed
}

// MARK: - Duel Result

enum DuelResult: String, Codable, CaseIterable {
    case win
    case loss
    case draw
}

// MARK: - Badge Type

enum BadgeType: String, Codable, CaseIterable, Identifiable {
    case firstBlood
    case streak7
    case superFocus
    case polisher
    case selfSurpassed
    case moonshot
    case streakMaster

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .firstBlood: "First Blood"
        case .streak7: "7-Day Focus"
        case .superFocus: "Super Focus"
        case .polisher: "Polisher"
        case .selfSurpassed: "Self Surpassed"
        case .moonshot: "Moonshot"
        case .streakMaster: "Streak Master"
        }
    }

    var description: String {
        switch self {
        case .firstBlood: "Complete your first quest"
        case .streak7: "Maintain a 7-day focus streak"
        case .superFocus: "Complete a quest with 5+ milestones, no parking"
        case .polisher: "Score an idea 90 or above"
        case .selfSurpassed: "Win a weekly duel (3+ rounds)"
        case .moonshot: "Complete 10 quests total"
        case .streakMaster: "Maintain a 30-day focus streak"
        }
    }

    var sfSymbol: String {
        switch self {
        case .firstBlood: "drop.fill"
        case .streak7: "flame.fill"
        case .superFocus: "bolt.fill"
        case .polisher: "sparkles"
        case .selfSurpassed: "figure.fencing"
        case .moonshot: "paperplane.fill"
        case .streakMaster: "flame.circle.fill"
        }
    }
}
