import SwiftUI

struct OnboardingPage4: View {
    @State private var animate = false

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
                rewardsIllustration
                content
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animate = true
            }
        }
    }

    // MARK: - Rewards Illustration

    private var rewardsIllustration: some View {
        VStack(spacing: 12) {
            // XP + Level row
            HStack(spacing: 12) {
                rewardCard(
                    icon: "star.fill",
                    iconColor: Color.victory,
                    title: "+75 XP",
                    subtitle: "Per milestone"
                )
                rewardCard(
                    icon: "shield.fill",
                    iconColor: Color.hero,
                    title: "Level Up",
                    subtitle: "Spark → Legend"
                )
            }

            // Streak + Badge row
            HStack(spacing: 12) {
                rewardCard(
                    icon: "flame.fill",
                    iconColor: Color.streak,
                    title: "Streaks",
                    subtitle: "Daily focus"
                )
                rewardCard(
                    icon: "medal.fill",
                    iconColor: Color.rival,
                    title: "Badges",
                    subtitle: "7 to unlock"
                )
            }
        }
        .padding(.bottom, 24)
    }

    private func rewardCard(icon: String, iconColor: Color, title: String, subtitle: String) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.custom("PlusJakartaSans-Bold", size: 14))
                    .foregroundStyle(Color.textPrimary)
                Text(subtitle)
                    .font(.custom("PlusJakartaSans-Regular", size: 11))
                    .foregroundStyle(Color.textMid)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.heroDeep.opacity(0.05), radius: 6, y: 2)
        .scaleEffect(animate ? 1 : 0.85)
        .opacity(animate ? 1 : 0)
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                Text("Every action")
                HStack(spacing: 0) {
                    Text("earns ")
                    Text("rewards.")
                        .foregroundStyle(Color.victory)
                }
            }
            .font(.custom("PlusJakartaSans-ExtraBold", size: 26))
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.center)

            Text("Earn XP for finishing milestones, not just collecting ideas. Level up, unlock badges, and build your streak.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
    }
}
