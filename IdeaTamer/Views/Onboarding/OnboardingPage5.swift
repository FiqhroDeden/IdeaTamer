import SwiftUI

struct OnboardingPage5: View {
    let onGetStarted: () -> Void
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.surface, Color.heroBG],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                appIdentity
                featureChips
                content
                Spacer()
                ctaButton
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                animate = true
            }
        }
    }

    // MARK: - App Identity

    private var appIdentity: some View {
        VStack(spacing: 12) {
            // App icon
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: Color.hero.opacity(0.2), radius: 8)
                .scaleEffect(animate ? 1 : 0.7)
                .opacity(animate ? 1 : 0)

            Text("IdeaTamer")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 22))
                .foregroundStyle(Color.hero)
        }
        .padding(.bottom, 20)
    }

    // MARK: - Feature Chips

    private var featureChips: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                featureChip(icon: "bolt.fill", text: "One quest focus", color: Color.hero)
                featureChip(icon: "figure.fencing", text: "Weekly duels", color: Color.rival)
            }
            HStack(spacing: 8) {
                featureChip(icon: "flame.fill", text: "Streaks & XP", color: Color.streak)
                featureChip(icon: "square.grid.2x2.fill", text: "Widgets", color: Color.victory)
            }
        }
        .padding(.bottom, 20)
    }

    private func featureChip(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(color)
            Text(text)
                .font(.custom("PlusJakartaSans-SemiBold", size: 11))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.card, in: Capsule())
        .shadow(color: Color.cardShadow, radius: 4, y: 1)
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 12) {
            Text("Stop collecting.\nStart **finishing.**")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 26))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Text("Free. Offline. No accounts. Your ideas, your quests, your legacy.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - CTA

    private var ctaButton: some View {
        Button {
            onGetStarted()
        } label: {
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
