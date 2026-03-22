import SwiftUI
import SwiftData

struct DuelBannerMini: View {
    @Environment(\.modelContext) private var modelContext
    @State private var won = 0
    @State private var lost = 0
    @State private var isFirstWeek = true

    var body: some View {
        if !isFirstWeek {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.fencing")
                            .font(.caption)
                            .foregroundStyle(Color.rival)
                        Text("WEEKLY DUEL")
                            .font(.brand(.label))
                            .textCase(.uppercase)
                            .tracking(1)
                            .foregroundStyle(Color.rival)
                    }
                    Text(statusText)
                        .font(.brand(.body))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.textPrimary)
                }
                Spacer()
                HStack(spacing: -8) {
                    Circle()
                        .fill(Color.hero.opacity(0.15))
                        .frame(width: 36, height: 36)
                        .overlay {
                            Text("Y")
                                .font(.caption)
                                .fontWeight(.black)
                                .foregroundStyle(Color.hero)
                        }
                    Circle()
                        .fill(Color.rival.opacity(0.15))
                        .frame(width: 36, height: 36)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundStyle(Color.rival)
                        }
                }
            }
            .padding(14)
            .background(
                LinearGradient(
                    colors: [Color.heroBG, Color.rivalBG],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .task { loadData() }
        }
    }

    private var statusText: String {
        if won > lost { return "Winning \(won)—\(lost) against past you" }
        if lost > won { return "Losing \(won)—\(lost) to past you" }
        return "Tied \(won)—\(lost) with past you"
    }

    private func loadData() {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)
        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        guard let lastSnapshot = try? modelContext.fetch(descriptor).first else {
            isFirstWeek = true
            return
        }
        isFirstWeek = false
        let rounds = DuelService.buildRounds(current: tracker, previous: lastSnapshot)
        won = rounds.filter(\.won).count
        lost = rounds.filter(\.lost).count
    }
}
