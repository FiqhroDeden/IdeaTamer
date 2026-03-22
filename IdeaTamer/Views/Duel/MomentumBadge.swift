import SwiftUI

struct MomentumBadge: View {
    let value: Double

    private var isPositive: Bool { value >= 0 }
    private var color: Color { isPositive ? Color.victory : Color.rival }
    private var icon: String { isPositive ? "arrow.up.right" : "arrow.down.right" }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .fontWeight(.bold)
            Text(String(format: "%+.0f%%", value))
                .font(.brand(.label))
                .fontWeight(.heavy)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12), in: Capsule())
    }
}

#Preview {
    HStack {
        MomentumBadge(value: 12)
        MomentumBadge(value: -5)
        MomentumBadge(value: 0)
    }
}
