import SwiftUI

struct QuickCaptureBar: View {
    @Binding var showXPFloat: Bool
    let onCapture: (String) -> Void

    @State private var title = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 6) {
            TextField("Capture an idea...", text: $title)
                .font(.brand(.body))
                .focused($isFocused)
                .onSubmit(submitCapture)
                .textFieldStyle(.plain)

            captureButton
        }
        .padding(6)
        .padding(.leading, 10)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.heroDeep.opacity(0.07), radius: 14, y: 4)
    }

    // MARK: - Subviews

    private var captureButton: some View {
        Button(action: submitCapture) {
            HStack(spacing: 4) {
                Text("+10 XP")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                Image(systemName: "plus.circle.fill")
                    .font(.subheadline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.hero, in: RoundedRectangle(cornerRadius: 12))
        }
        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
        .opacity(title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
    }

    // MARK: - Actions

    private func submitCapture() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        onCapture(trimmed)
        title = ""
        showXPFloat = true
        isFocused = false
    }
}
