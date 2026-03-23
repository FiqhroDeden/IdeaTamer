import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = "inbox"
    @State private var showOnboarding = false
    @State private var showLevelUp = false
    @State private var levelUpLevel = 1

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                Tab("Inbox", systemImage: "tray.and.arrow.down.fill", value: "inbox") {
                    InboxView()
                }

                Tab("Focus", systemImage: "bolt.fill", value: "focus") {
                    FocusView(selectedTab: $selectedTab)
                }

                Tab("Duel", systemImage: "figure.fencing", value: "duel") {
                    DuelView()
                }

                Tab("Park", systemImage: "square.grid.2x2.fill", value: "park") {
                    ParkView()
                }

                Tab("Done", systemImage: "trophy.fill", value: "done") {
                    DoneView()
                }
            }
            .tint(selectedTab == "duel" ? Color.rival : Color.hero)

            LevelUpOverlay(isShowing: $showLevelUp, level: levelUpLevel)
        }
        .task {
            let profile = PlayerProfile.fetchOrCreate(context: modelContext)
            if !profile.hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .leveledUp)) { notification in
            if let level = notification.object as? Int {
                levelUpLevel = level
                showLevelUp = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: [
                Idea.self,
                Milestone.self,
                PlayerProfile.self,
                WeeklySnapshot.self,
                CurrentWeekTracker.self,
            ] as [any PersistentModel.Type],
            inMemory: true
        )
}
