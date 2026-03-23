import SwiftUI
import SwiftData

struct PlayerHeader: View {
    @Environment(\.modelContext) private var modelContext
    @State private var level = 1
    @State private var title = "Spark"
    @State private var xp = 0
    @State private var progress: Double = 0

    var body: some View {
        HStack(spacing: 8) {
            // App logo
            HStack(spacing: 6) {
                Image(systemName: "bolt.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.hero)
                Text("IdeaTamer")
                    .font(.brand(.title))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.hero)
            }

            Spacer()

            // Level badge
            Text("LVL \(level)")
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(Color.hero)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.heroBG, in: Capsule())
        }
        .task { loadProfile() }
        .onChange(of: level) { _, _ in }
    }

    private func loadProfile() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        level = profile.currentLevel
        title = XP.title(for: profile.currentLevel)
        xp = profile.totalXP
        progress = XP.progressInLevel(xp: profile.totalXP)
    }
}
