import SwiftUI

struct IdeaCard: View {
    let idea: Idea

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            scoreIndicator
            ideaContent
            Spacer()
            if idea.status == .active {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(Color.hero)
                    .font(.body)
            }
        }
        .padding(16)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.cardShadow, radius: 14, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(idea.title), \(idea.isScored ? "score \(idea.computedScore ?? 0)" : "unscored")")
        .accessibilityHint("Tap to score this idea")
    }

    // MARK: - Subviews

    @ViewBuilder
    private var scoreIndicator: some View {
        if let score = idea.computedScore {
            ScoreBadge(score: score)
        } else {
            unscoredDot
        }
    }

    private var unscoredDot: some View {
        Circle()
            .fill(Color.textLight.opacity(0.4))
            .frame(width: 8, height: 8)
            .modifier(PulsingModifier())
            .padding(.top, 6)
    }

    private var ideaContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(idea.title)
                .font(.brand(.title))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
            Text(idea.createdAt, style: .relative)
                .font(.brand(.caption))
                .foregroundStyle(Color.textLight)
        }
    }
}

// MARK: - Pulsing Animation

private struct PulsingModifier: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 1.0 : 0.4)
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear { isPulsing = true }
    }
}
