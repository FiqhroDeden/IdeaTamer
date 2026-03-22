import SwiftUI

struct ScoreBadge: View {
    let score: Int

    private var color: Color {
        Color.scoreColor(score)
    }

    var body: some View {
        Text("\(score)")
            .font(.brand(.label))
            .fontWeight(.heavy)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    HStack(spacing: 12) {
        ScoreBadge(score: 84)
        ScoreBadge(score: 42)
        ScoreBadge(score: 25)
    }
    .padding()
}
