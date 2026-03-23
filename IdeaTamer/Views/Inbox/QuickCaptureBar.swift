import SwiftUI

struct QuickCaptureBar: View {
    @Binding var showXPFloat: Bool
    var isAtCap: Bool = false
    let onCapture: (String) -> Void

    @State private var title = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 4) {
            if isAtCap {
                capMessage
            }

            HStack(spacing: 6) {
                TextField("Capture an idea...", text: $title)
                    .font(.brand(.body))
                    .focused($isFocused)
                    .onSubmit(submitCapture)
                    .textFieldStyle(.plain)
                    .disabled(isAtCap)

                captureButton
            }
            .padding(6)
            .padding(.leading, 10)
            .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.heroDeep.opacity(0.07), radius: 14, y: 4)
            .opacity(isAtCap ? 0.5 : 1)
        }
    }

    // MARK: - Subviews

    private var capMessage: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption2)
            Text("Inbox full — score or remove ideas first")
                .font(.brand(.label))
        }
        .foregroundStyle(Color.streakDim)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
    }

    private var captureButton: some View {
        Button(action: submitCapture) {
            HStack(spacing: 4) {
                Text("+5 XP")
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
        .disabled(isAtCap || title.trimmingCharacters(in: .whitespaces).isEmpty)
        .opacity(isAtCap || title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
    }

    // MARK: - Actions

    private func submitCapture() {
        guard !isAtCap else { return }
        let trimmed = String(title.trimmingCharacters(in: .whitespaces).prefix(120))
        guard !trimmed.isEmpty else { return }
        onCapture(trimmed)
        title = ""
        showXPFloat = true
        isFocused = false
    }
}
