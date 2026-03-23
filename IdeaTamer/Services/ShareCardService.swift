import SwiftUI
import UIKit

@MainActor
enum ShareCardService {

    static func renderQuestCard(idea: Idea) -> UIImage? {
        let view = QuestShareCard(
            title: idea.title,
            score: idea.computedScore,
            completionDays: idea.completionDays,
            xpEarned: idea.xpEarned
        )
        .environment(\.colorScheme, .light)
        return render(view)
    }

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
