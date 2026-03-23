import SwiftUI
import SwiftData

struct CapturePaceIndicator: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentCaptures = 0
    @State private var pastCaptures = 0

    private var diff: Int { currentCaptures - pastCaptures }
    private var maxVal: Int { max(currentCaptures, pastCaptures, 1) }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("CAPTURES THIS WEEK")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(Color.textMid)
                Spacer()
                Text(diff >= 0 ? "+\(diff) ahead" : "\(diff) behind")
                    .font(.brand(.label))
                    .fontWeight(.heavy)
                    .foregroundStyle(diff >= 0 ? Color.hero : Color.rival)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.surfaceHigh)

                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.hero)
                        .frame(width: geo.size.width * barFraction(currentCaptures))

                    // Past marker (dashed line)
                    if pastCaptures > 0 {
                        Circle()
                            .fill(Color.rival.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .offset(x: geo.size.width * barFraction(pastCaptures) - 5)
                    }
                }
            }
            .frame(height: 10)

            HStack {
                Text("You: \(currentCaptures)")
                    .font(.brand(.label))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.hero)
                Spacer()
                Text("Past you: \(pastCaptures)")
                    .font(.brand(.label))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.rival.opacity(0.6))
            }
        }
        .padding(16)
        .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        .task { loadData() }
    }

    private func barFraction(_ value: Int) -> CGFloat {
        CGFloat(value) / CGFloat(maxVal)
    }

    private func loadData() {
        let tracker = CurrentWeekTracker.fetchOrCreate(context: modelContext)
        currentCaptures = tracker.ideasCaptured

        var descriptor = FetchDescriptor<WeeklySnapshot>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        pastCaptures = (try? modelContext.fetch(descriptor).first)?.ideasCaptured ?? 0
    }
}
