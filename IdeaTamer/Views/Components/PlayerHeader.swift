import SwiftUI
import SwiftData

struct PlayerHeader: View {
    @Environment(\.modelContext) private var modelContext
    @State private var level = 1
    @State private var momentum: Double = 0
    @State private var hasMomentum = false
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Logo + App Name — far left
                HStack(spacing: 8) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text("IdeaTamer")
                        .font(.brand(.headline))
                        .foregroundStyle(Color.hero)
                }

                Spacer(minLength: 0)

                // Momentum + Level + Settings — far right
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

                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.textLight)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.surface)

            Divider()
                .foregroundStyle(Color.surfaceHigh.opacity(0.5))
        }
        .task { loadData() }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
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
