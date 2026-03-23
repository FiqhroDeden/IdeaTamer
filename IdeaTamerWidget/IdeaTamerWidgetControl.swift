import AppIntents
import SwiftUI
import WidgetKit

struct QuickCaptureControl: ControlWidget {
    static let kind = "app.fiqhrodedhen.IdeaTamer.QuickCapture"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: QuickCaptureIntent()) {
                Label("Capture Idea", systemImage: "plus.circle.fill")
            }
        }
        .displayName("Quick Capture")
        .description("Open IdeaTamer to capture a new idea.")
    }
}
