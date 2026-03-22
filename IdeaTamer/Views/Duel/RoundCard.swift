import SwiftUI

struct RoundCard: View {
    let round: DuelRound
    @State private var animateBar = false

    private var maxValue: Int {
        max(round.currentValue, round.pastValue, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            bars
        }
        .padding(14)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.heroDeep.opacity(0.05), radius: 8, y: 2)
        .onAppear {
            withAnimation(.easeOut(duration: AnimationDuration.duelBar).delay(0.2)) {
                animateBar = true
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: round.icon)
                    .font(.subheadline)
                    .foregroundStyle(iconColor)
                Text(round.name)
                    .font(.brand(.body))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
            }
            Spacer()
            resultBadge
        }
    }

    private var iconColor: Color {
        switch round.name {
        case "XP Earned": return Color.streak
        case "Milestones": return Color.victory
        case "Ideas Captured": return Color.hero
        default: return Color.streak
        }
    }

    @ViewBuilder
    private var resultBadge: some View {
        if round.won {
            Text("YOU WIN")
                .font(.brand(.label))
                .textCase(.uppercase)
                .fontWeight(.heavy)
                .foregroundStyle(Color.victoryDim)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.victoryBG, in: Capsule())
        } else if round.lost {
            Text("SHADOW WINS")
                .font(.brand(.label))
                .textCase(.uppercase)
                .fontWeight(.heavy)
                .foregroundStyle(Color.rival)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.rivalBG, in: Capsule())
        } else {
            Text("TIED")
                .font(.brand(.label))
                .textCase(.uppercase)
                .fontWeight(.heavy)
                .foregroundStyle(Color.textMid)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.surfaceLow, in: Capsule())
        }
    }

    // MARK: - Bars

    private var bars: some View {
        VStack(spacing: 4) {
            barRow(label: "You", value: round.currentValue, color: Color.hero, isHero: true)
            barRow(label: "Past", value: round.pastValue, color: Color.rival.opacity(0.4), isHero: false)
        }
    }

    private func barRow(label: String, value: Int, color: Color, isHero: Bool) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.brand(.label))
                .fontWeight(.bold)
                .foregroundStyle(isHero ? Color.hero : Color.rival.opacity(0.5))
                .frame(width: 28, alignment: .leading)

            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surfaceHigh)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(width: animateBar
                                ? geo.size.width * barFraction(value)
                                : 0
                            )
                    }
            }
            .frame(height: 10)

            Text("\(value)")
                .font(.brand(.body))
                .fontWeight(isHero ? .heavy : .regular)
                .foregroundStyle(isHero ? Color.textPrimary : Color.textLight)
                .frame(width: 32, alignment: .trailing)
        }
    }

    private func barFraction(_ value: Int) -> CGFloat {
        CGFloat(value) / CGFloat(maxValue)
    }
}
