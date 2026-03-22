import SwiftUI
import UIKit

struct LevelUpOverlay: View {
    @Binding var isShowing: Bool
    let level: Int

    @State private var scale: CGFloat = 0
    @State private var titleOpacity: Double = 0

    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing = false }

                VStack(spacing: 16) {
                    Text("LEVEL UP")
                        .font(.brand(.label))
                        .textCase(.uppercase)
                        .tracking(2)
                        .foregroundStyle(Color.victory)

                    Text("\(level)")
                        .font(.custom("PlusJakartaSans-ExtraBold", size: 72))
                        .foregroundStyle(Color.textPrimary)
                        .scaleEffect(scale)

                    Text(XP.title(for: level))
                        .font(.brand(.headline))
                        .foregroundStyle(Color.hero)
                        .opacity(titleOpacity)

                    Text("Tap to continue")
                        .font(.brand(.caption))
                        .foregroundStyle(Color.textLight)
                        .padding(.top, 20)
                        .opacity(titleOpacity)
                }
                .padding(40)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
            }
            .onAppear {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)

                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.0
                }
                withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                    titleOpacity = 1.0
                }
            }
            .onDisappear {
                scale = 0
                titleOpacity = 0
            }
        }
    }
}

#Preview {
    LevelUpOverlay(isShowing: .constant(true), level: 5)
}
