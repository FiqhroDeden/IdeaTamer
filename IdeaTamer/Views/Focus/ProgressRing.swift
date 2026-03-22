import SwiftUI

struct ProgressRing: View {
    let progress: Double
    var size: CGFloat = 160
    var lineWidth: CGFloat = 14

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.surfaceHigh, lineWidth: lineWidth)

            // Fill
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.hero,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.hero.opacity(0.2), radius: 4)
                .animation(.springMedium, value: progress)

            // Center label
            VStack(spacing: 2) {
                Text("\(Int(progress * 100))%")
                    .font(.custom("PlusJakartaSans-ExtraBold", size: size * 0.19))
                    .foregroundStyle(Color.textPrimary)
                Text("MASTERY")
                    .font(.brand(.label))
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.textLight)
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressRing(progress: 0.43)
        ProgressRing(progress: 1.0, size: 100, lineWidth: 10)
    }
}
