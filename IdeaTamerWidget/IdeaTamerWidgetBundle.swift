import WidgetKit
import SwiftUI

@main
struct IdeaTamerWidgetBundle: WidgetBundle {
    var body: some Widget {
        ActiveQuestWidget()
        QuestProgressAccessory()
        StreakAccessory()
        LevelAccessory()
        QuickCaptureControl()
    }
}
