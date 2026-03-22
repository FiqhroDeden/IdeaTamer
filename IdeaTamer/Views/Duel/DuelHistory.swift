import SwiftUI

struct DuelHistory: View {
    let snapshots: [WeeklySnapshot]

    private var wins: Int { snapshots.filter { $0.duelResult == .win }.count }
    private var losses: Int { snapshots.filter { $0.duelResult == .loss }.count }
    private var draws: Int { snapshots.filter { $0.duelResult == .draw }.count }

    var body: some View {
        if !snapshots.isEmpty {
            VStack(spacing: 8) {
                Text("PAST DUELS")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.textLight)

                HStack(spacing: 6) {
                    ForEach(snapshots.prefix(8)) { snapshot in
                        resultSquare(snapshot.duelResult)
                    }
                }

                Text("\(wins)W · \(losses)L · \(draws)D")
                    .font(.brand(.caption))
                    .foregroundStyle(Color.textMid)
            }
            .padding(.top, 8)
        }
    }

    private func resultSquare(_ result: DuelResult?) -> some View {
        let (letter, bgColor, textColor): (String, Color, Color) = {
            switch result {
            case .win: return ("W", Color.heroBG, Color.hero)
            case .loss: return ("L", Color.rivalBG, Color.rival)
            case .draw: return ("D", Color.surfaceHigh, Color.textLight)
            case nil: return ("—", Color.surfaceLow, Color.textLight)
            }
        }()

        return Text(letter)
            .font(.brand(.label))
            .fontWeight(.bold)
            .foregroundStyle(textColor)
            .frame(width: 28, height: 28)
            .background(bgColor, in: RoundedRectangle(cornerRadius: 8))
    }
}
