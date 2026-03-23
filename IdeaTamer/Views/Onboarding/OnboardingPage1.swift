import SwiftUI

struct OnboardingPage1: View {
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
                illustration
                content
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onAppear { animate = true }
    }

    // MARK: - Illustration

    private var illustration: some View {
        ZStack {
            // Center person
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hero.opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Color.hero)
                }
                .offset(y: animate ? -4 : 4)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)

            // Floating bubbles
            floatingBubble(icon: "lightbulb", color: Color.rival, x: -60, y: -50, delay: 0.2)
            floatingBubble(icon: "lightbulb", color: Color.streak, x: 55, y: -40, delay: 0.8)
            floatingBubble(icon: "lightbulb", color: Color.hero, x: -50, y: 40, delay: 0.5)
            floatingBubble(icon: "lightbulb", color: Color.victory, x: 50, y: 50, delay: 0.6)
        }
        .frame(height: 180)
        .padding(.bottom, 24)
    }

    private func floatingBubble(icon: String, color: Color, x: CGFloat, y: CGFloat, delay: Double) -> some View {
        Circle()
            .fill(color.opacity(0.1))
            .frame(width: 36, height: 36)
            .overlay {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color.opacity(0.6))
            }
            .offset(x: x, y: y + (animate ? -8 : 0))
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true).delay(delay), value: animate)
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 12) {
            Text("You have too\nmany ideas.")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 26))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Text("And that's the problem. More ideas won't help. **Finishing one will.**")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
    }
}
