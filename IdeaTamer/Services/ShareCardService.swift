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
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }

    static func renderDuelCard(won: Int, lost: Int, momentum: Double) -> UIImage? {
        let view = DuelShareCard(won: won, lost: lost, momentum: momentum)
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
