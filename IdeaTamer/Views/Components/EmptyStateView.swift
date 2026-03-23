import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let subtitle: String
    var iconColor: Color = Color.hero
    var gradientColors: [Color] = [Color.heroBG, Color.surface]

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Icon with colored background circle
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [iconColor.opacity(0.15), iconColor.opacity(0.05), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)

                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 88, height: 88)

                Image(systemName: systemImage)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(iconColor)
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.brand(.headline))
                    .foregroundStyle(Color.textPrimary)

                Text(subtitle)
                    .font(.brand(.body))
                    .foregroundStyle(Color.textMid)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    EmptyStateView(
        systemImage: "lightbulb.max",
        title: "No ideas yet",
        subtitle: "Capture your first idea and start your quest to greatness",
        iconColor: Color.hero
    )
}
