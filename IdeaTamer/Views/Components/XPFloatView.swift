import SwiftUI

struct XPFloatView: View {
    let amount: Int
    @Binding var isShowing: Bool

    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        if isShowing {
            Text("+\(amount) XP")
                .font(.brand(.label))
                .fontWeight(.heavy)
                .foregroundStyle(Color.victory)
                .textCase(.uppercase)
                .tracking(1)
                .offset(y: offset)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: AnimationDuration.xpFloat)) {
                        offset = -60
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.xpFloat) {
                        isShowing = false
                        offset = 0
                        opacity = 1
                    }
                }
        }
    }
}

#Preview {
    XPFloatView(amount: 10, isShowing: .constant(true))
}
