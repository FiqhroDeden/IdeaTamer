import AppIntents

struct QuickCaptureIntent: AppIntent {
    static var title: LocalizedStringResource = "Capture Idea"
    static var description: IntentDescription = "Open IdeaTamer to capture a new idea."
    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}
