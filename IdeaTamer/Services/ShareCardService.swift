import SwiftUI
import UIKit

@MainActor
enum ShareCardService {

    /// For Focus tab — in-progress quest with milestone checklist
    static func renderProgressCard(idea: Idea) -> UIImage? {
        let milestones = idea.milestones
            .sorted { $0.sortOrder < $1.sortOrder }
            .map { (title: $0.title, done: $0.isCompleted) }

        let view = ProgressShareCard(
            title: idea.title,
            progress: idea.milestoneProgress,
            milestones: milestones
        )
        .environment(\.colorScheme, .light)
        return render(view)
    }

    /// For Done tab — completed/shipped quest
    static func renderQuestCard(idea: Idea) -> UIImage? {
        var xp = idea.xpEarned
        if xp == 0 {
            xp = XP.capture
            if idea.isScored { xp += XP.score }
            xp += idea.completedMilestoneCount * XP.milestone
            if idea.status == .completed { xp += XP.questComplete }
        }
        let view = QuestShareCard(
            title: idea.title,
            score: idea.computedScore,
            completionDays: idea.completionDays,
            xpEarned: xp,
            milestoneCount: idea.milestones.count
        )
        .environment(\.colorScheme, .light)
        return render(view)
    }

    /// For Duel tab
    static func renderDuelCard(won: Int, lost: Int, momentum: Double) -> UIImage? {
        let view = DuelShareCard(won: won, lost: lost, momentum: momentum)
            .environment(\.colorScheme, .light)
        return render(view)
    }

    private static func render<V: View>(_ view: V) -> UIImage? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3.0
        return renderer.uiImage
    }
}
