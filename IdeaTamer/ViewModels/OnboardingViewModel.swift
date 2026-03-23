import Foundation
import SwiftData

@Observable
@MainActor
final class OnboardingViewModel {
    private let modelContext: ModelContext
    var currentPage = 0

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func completeOnboarding() {
        let profile = PlayerProfile.fetchOrCreate(context: modelContext)
        profile.hasCompletedOnboarding = true
    }
}
