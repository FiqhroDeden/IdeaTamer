import SwiftUI

struct UndoToast: View {
    let message: String
    let onUndo: () -> Void
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            HStack(spacing: 12) {
                Image(systemName: "trash")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                Text(message)
                    .font(.brand(.body))
                    .foregroundStyle(.white)
                Spacer()
                Button("Undo") {
                    Haptics.light()
                    onUndo()
                    withAnimation(.springFast) {
                        isShowing = false
                    }
                }
                .font(.brand(.title))
                .fontWeight(.bold)
                .foregroundStyle(Color.hero)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.textPrimary, in: RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 20)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.springFast) {
                        isShowing = false
                    }
                }
            }
        }
    }
}
