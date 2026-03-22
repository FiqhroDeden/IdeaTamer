import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = "inbox"

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Inbox", systemImage: "tray.and.arrow.down.fill", value: "inbox") {
                NavigationStack {
                    InboxView()
                }
            }

            Tab("Focus", systemImage: "bolt.fill", value: "focus") {
                NavigationStack {
                    FocusView()
                }
            }

            Tab("Duel", systemImage: "figure.fencing", value: "duel") {
                NavigationStack {
                    DuelPlaceholder()
                }
            }

            Tab("Park", systemImage: "square.grid.2x2.fill", value: "park") {
                NavigationStack {
                    ParkView()
                }
            }

            Tab("Done", systemImage: "trophy.fill", value: "done") {
                NavigationStack {
                    DonePlaceholder()
                }
            }
        }
        .tint(selectedTab == "duel" ? Color.rival : Color.hero)
    }
}

// MARK: - Placeholder Views

private struct InboxPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray.and.arrow.down.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.hero)
            Text("Inbox")
                .font(.brand(.headline))
            Text("Capture your ideas here")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
    }
}

private struct FocusPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.hero)
            Text("Focus")
                .font(.brand(.headline))
            Text("Your active quest appears here")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
    }
}

private struct DuelPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.fencing")
                .font(.system(size: 48))
                .foregroundStyle(Color.rival)
            Text("Duel")
                .font(.brand(.headline))
            Text("Compete with your past self")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
    }
}

private struct ParkPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.hero)
            Text("Park")
                .font(.brand(.headline))
            Text("Ranked ideas waiting for activation")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
    }
}

private struct DonePlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.hero)
            Text("Done")
                .font(.brand(.headline))
            Text("Your Hall of Fame")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
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
