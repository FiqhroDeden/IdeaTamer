import SwiftUI

extension View {
    /// Applies Liquid Glass card styling with consistent padding and corner radius.
    func glassCard() -> some View {
        self
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
