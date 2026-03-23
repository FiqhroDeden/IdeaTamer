import SwiftUI

struct OnboardingPage2: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.surface, Color.streakBG],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                stepFlow
                content
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                animate = true
            }
        }
    }

    // MARK: - Step Flow

    private var stepFlow: some View {
        HStack(spacing: 8) {
            stepIcon(icon: "lightbulb.fill", color: Color.hero, label: "Capture", step: 1)
            dottedLine
            stepIcon(icon: "chart.bar.fill", color: Color.streak, label: "Score", step: 2)
            dottedLine
            stepIcon(icon: "bolt.fill", color: Color.rival, label: "Focus", step: 3)
            dottedLine
            stepIcon(icon: "trophy.fill", color: Color.victory, label: "Ship", step: 4)
        }
        .padding(.bottom, 24)
    }

    private func stepIcon(icon: String, color: Color, label: String, step: Int) -> some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.card)
                    .frame(width: 48, height: 48)
                    .shadow(color: color.opacity(0.15), radius: 6)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
            }
            .scaleEffect(animate ? 1 : 0.6)
            .opacity(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(step) * 0.15), value: animate)

            Text(label)
                .font(.system(size: 9, weight: .bold))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.textMid)
        }
    }

    private var dottedLine: some View {
        Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            .foregroundStyle(Color.textPrimary.opacity(0.15))
            .frame(width: 16, height: 1)
            .padding(.bottom, 20)
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                Text("Capture. Score.")
                HStack(spacing: 0) {
                    Text("Focus. ")
                    Text("Ship.")
                        .foregroundStyle(Color.victory)
                }
            }
            .font(.custom("PlusJakartaSans-ExtraBold", size: 26))
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.center)

            Text("Score your ideas to find the best one. Activate it as your quest. Complete milestones. **Ship it.**")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
    }
}
