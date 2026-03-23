import SwiftUI
import SwiftData

struct MasteryCard: View {
    @Environment(\.modelContext) private var modelContext
    @State private var levelTitle = "Spark"
    @State private var progress: Double = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                Text("MASTERY")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.7))

                Text(levelTitle)
                    .font(.brand(.headline))
                    .foregroundStyle(.white)

                // XP progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(0.2))
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.victoryLight)
                            .frame(width: geo.size.width * progress)
                            .shadow(color: Color.victoryLight.opacity(0.4), radius: 4)
                    }
                }
                .frame(height: 10)
            }

            // Watermark trophy
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white.opacity(0.15))
                .offset(x: 16, y: 16)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.hero, Color.heroDim],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24)
        )
        .task { loadData() }
    }

    private func loadData() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        levelTitle = XP.title(for: profile.currentLevel)
        progress = XP.progressInLevel(xp: profile.totalXP)
    }
}
