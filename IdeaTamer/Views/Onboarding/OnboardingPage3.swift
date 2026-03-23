import SwiftUI

struct OnboardingPage3: View {
    let onGetStarted: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.surface, Color.victoryBG],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                stepFlow
                content
                Spacer()
                ctaButton
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Step Flow

    private var stepFlow: some View {
        HStack(spacing: 8) {
            stepIcon(icon: "lightbulb.fill", color: Color.hero, label: "Capture")
            dottedLine
            stepIcon(icon: "chart.bar.fill", color: Color.streak, label: "Score")
            dottedLine
            stepIcon(icon: "figure.fencing", color: Color.rival, label: "Focus")
            dottedLine
            stepIcon(icon: "trophy.fill", color: Color.victory, label: "Ship")
        }
        .padding(.bottom, 24)
    }

    private func stepIcon(icon: String, color: Color, label: String) -> some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.card)
                    .frame(width: 48, height: 48)
                    .shadow(color: color.opacity(0.1), radius: 4)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
            }
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

            Text("One quest at a time. Earn XP. Beat your shadow. Share your wins with the world.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - CTA

    private var ctaButton: some View {
        Button(action: onGetStarted) {
            Text("Start Your Journey")
                .font(.brand(.title))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: 260)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [Color.hero, Color.heroDim], startPoint: .leading, endPoint: .trailing),
                    in: RoundedRectangle(cornerRadius: 16)
                )
                .shadow(color: Color.hero.opacity(0.25), radius: 8)
        }
        .padding(.bottom, 20)
    }
}
