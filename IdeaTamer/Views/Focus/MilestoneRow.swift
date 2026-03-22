import SwiftUI

struct MilestoneRow: View {
    let milestone: Milestone
    let isFirstUncompleted: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .center, spacing: 10) {
                checkbox
                titleContent
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Checkbox

    @ViewBuilder
    private var checkbox: some View {
        if milestone.isCompleted {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.victory)
        } else if isFirstUncompleted {
            ZStack {
                Circle()
                    .strokeBorder(Color.hero, lineWidth: 2)
                    .frame(width: 18, height: 18)
                Circle()
                    .fill(Color.hero)
                    .frame(width: 6, height: 6)
                    .modifier(PulseModifier())
            }
        } else {
            Circle()
                .strokeBorder(Color.textLight.opacity(0.4), lineWidth: 2)
                .frame(width: 18, height: 18)
        }
    }

    // MARK: - Title

    private var titleContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(milestone.title)
                .font(.brand(.body))
                .fontWeight(milestone.isCompleted ? .regular : .bold)
                .foregroundStyle(milestone.isCompleted ? Color.textMid : Color.textPrimary)
                .strikethrough(milestone.isCompleted, color: Color.victory.opacity(0.3))

            if milestone.isCompleted, let date = milestone.completedAt {
                Text(date, style: .relative)
                    .font(.brand(.caption))
                    .foregroundStyle(Color.textLight)
            } else if isFirstUncompleted {
                Text("IN PROGRESS")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.hero)
            }
        }
    }
}

// MARK: - Pulse

private struct PulseModifier: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 1.0 : 0.3)
            .animation(
                .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear { isPulsing = true }
    }
}
