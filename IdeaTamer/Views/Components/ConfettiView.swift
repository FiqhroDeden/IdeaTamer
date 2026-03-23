import SwiftUI

struct ConfettiView: View {
    @Binding var isShowing: Bool

    private let colors: [Color] = [
        .hero, .rival, .victory, .streak, .heroLight, .rivalLight
    ]
    private let particleCount = 24

    var body: some View {
        if isShowing {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<particleCount, id: \.self) { index in
                        ConfettiParticle(
                            color: colors[index % colors.count],
                            delay: Double.random(in: 0...0.5),
                            screenHeight: geo.size.height
                        )
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: -10
                        )
                    }
                }
            }
            .allowsHitTesting(false)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.confetti + 0.5) {
                    isShowing = false
                }
            }
        }
    }
}

// MARK: - Particle

private struct ConfettiParticle: View {
    let color: Color
    let delay: Double
    let screenHeight: CGFloat

    @State private var offset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1

    private let width = CGFloat.random(in: 4...7)
    private let height = CGFloat.random(in: 3...5)

    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(color)
            .frame(width: width, height: height)
            .rotationEffect(.degrees(rotation))
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeIn(duration: Double.random(in: 1.4...2.4))
                    .delay(delay)
                ) {
                    offset = screenHeight + 50
                    rotation = Double.random(in: 360...720)
                    opacity = 0
                }
            }
    }
}
