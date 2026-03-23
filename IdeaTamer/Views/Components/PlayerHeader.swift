import SwiftUI
import SwiftData

struct PlayerHeader: View {
    @Environment(\.modelContext) private var modelContext
    @State private var level = 1
    @State private var momentum: Double = 0
    @State private var hasMomentum = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Logo + App Name — far left
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(
                                colors: [Color.hero, Color.heroDim],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 32, height: 32)
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Text("IdeaTamer")
                        .font(.brand(.headline))
                        .foregroundStyle(Color.hero)
                }

                Spacer(minLength: 0)

                // Momentum + Level — far right
                HStack(spacing: 6) {
                    if hasMomentum {
                        MomentumBadge(value: momentum)
                    }
                    Text("LVL \(level)")
                        .font(.brand(.label))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.hero)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.heroBG, in: Capsule())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.surface)

            // Divider for contrast
            Divider()
                .foregroundStyle(Color.surfaceHigh.opacity(0.5))
        }
        .task { loadData() }
    }

    private func loadData() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        level = profile.currentLevel

        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)
        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        if let last = try? modelContext.fetch(descriptor).first {
            momentum = DuelService.computeMomentum(currentXP: tracker.xpEarned, previousXP: last.xpEarned)
            hasMomentum = true
        }
    }
}
