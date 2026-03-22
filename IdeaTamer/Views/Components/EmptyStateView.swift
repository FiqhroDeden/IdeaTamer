import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(Color.textLight)
            Text(title)
                .font(.brand(.headline))
                .foregroundStyle(Color.textPrimary)
            Text(subtitle)
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

#Preview {
    EmptyStateView(
        systemImage: "lightbulb.slash",
        title: "No ideas yet",
        subtitle: "Capture your first idea to get started"
    )
}
