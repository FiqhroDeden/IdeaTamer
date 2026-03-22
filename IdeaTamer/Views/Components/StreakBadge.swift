import SwiftUI

struct StreakBadge: View {
    let count: Int
    let label: String

    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 4) {
            Text("\(count) \(label)")
                .font(.brand(.label))
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.streak)
            Text("🔥")
                .font(.caption)
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .animation(
                    count > 0
                        ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
                        : .default,
                    value: isPulsing
                )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.streakBG, in: Capsule())
        .onAppear {
            if count > 0 { isPulsing = true }
        }
    }
}

#Preview {
    HStack {
        StreakBadge(count: 5, label: "Days")
        StreakBadge(count: 0, label: "Days")
    }
}
