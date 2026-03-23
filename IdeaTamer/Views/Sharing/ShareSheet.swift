import SwiftUI
import UIKit

enum ShareHelper {
    @MainActor
    static func share(_ image: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        // Find the topmost presented controller
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        topVC.present(activityVC, animated: true)
    }
}
