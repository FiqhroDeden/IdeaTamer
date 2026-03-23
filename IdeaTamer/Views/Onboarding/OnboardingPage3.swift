import SwiftUI

struct OnboardingPage3: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.surface, Color.rivalBG],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                vsIllustration
                content
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onAppear { animate = true }
    }

    // MARK: - VS Illustration

    private var vsIllustration: some View {
        HStack(spacing: 20) {
            avatarColumn(
                letter: "Y",
                label: "You now",
                color: Color.hero,
                floatUp: true
            )

            Text("VS")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 20))
                .foregroundStyle(Color.textPrimary.opacity(0.2))

            avatarColumn(
                letter: nil,
                label: "Past you",
                color: Color.rival,
                floatUp: false
            )
        }
        .frame(height: 160)
        .padding(.bottom, 24)
    }

    private func avatarColumn(letter: String?, label: String, color: Color, floatUp: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 64, height: 64)
                    .shadow(color: color.opacity(0.25), radius: 8)

                if let letter {
                    Text(letter)
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
            .offset(y: animate ? (floatUp ? -6 : 6) : (floatUp ? 6 : -6))
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)

            Text(label)
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                Text("Your only rival")
                HStack(spacing: 0) {
                    Text("is ")
                    Text("yesterday's you.")
                        .foregroundStyle(Color.rival)
                }
            }
            .font(.custom("PlusJakartaSans-ExtraBold", size: 26))
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.center)

            Text("Every week, you duel your past self. Ship more quests, complete more milestones, and keep your streak to **win.**")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
    }
}
