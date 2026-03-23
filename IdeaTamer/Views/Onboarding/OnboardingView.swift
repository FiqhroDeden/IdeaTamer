import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    private let pageColors: [Color] = [.hero, .rival, .victory]

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentPage) {
                OnboardingPage1()
                    .tag(0)
                OnboardingPage2()
                    .tag(1)
                OnboardingPage3 {
                    completeOnboarding()
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            VStack {
                topBar
                Spacer()
                pageIndicator
                    .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Spacer()
            if currentPage < 2 {
                Button("Skip") {
                    completeOnboarding()
                }
                .font(.brand(.title))
                .fontWeight(.bold)
                .foregroundStyle(Color.hero)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? pageColors[index] : Color.textPrimary.opacity(0.15))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.springFast, value: currentPage)
            }
        }
    }

    // MARK: - Actions

    private func completeOnboarding() {
        let vm = OnboardingViewModel(modelContext: modelContext)
        vm.completeOnboarding()
        dismiss()
    }
}
