import SwiftUI
import SwiftData
import UIKit

struct DuelView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DuelViewModel?
    @State private var isLoaded = false

    var body: some View {
        Group {
            if let vm = viewModel, isLoaded {
                if vm.isFirstWeek {
                    firstWeekView
                } else {
                    duelContent(vm: vm)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            let vm = DuelViewModel(modelContext: modelContext)
            vm.load()
            viewModel = vm
            isLoaded = true
        }
    }

    // MARK: - First Week

    private var firstWeekView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "figure.fencing")
                .font(.system(size: 48))
                .foregroundStyle(Color.rival)
            Text("Your first week")
                .font(.brand(.headline))
                .foregroundStyle(Color.textPrimary)
            Text("This week sets your baseline.\nNext week, you'll duel your past self.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(40)
    }

    // MARK: - Duel Content

    private func duelContent(vm: DuelViewModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                VSCard(
                    won: vm.currentWon,
                    lost: vm.currentLost,
                    momentum: vm.momentum,
                    isFirstWeek: false
                )
                roundCards(vm: vm)
                winBonusCard(vm: vm)
                shareButton(vm: vm)
                DuelHistory(snapshots: vm.duelHistory)
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 4) {
            Text("WEEKLY DUEL")
                .font(.brand(.label))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(Color.rival)
            Text("Compete with\nyourself.")
                .font(.brand(.display))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
            Text("Beat the person you were 7 days ago.")
                .font(.brand(.body))
                .foregroundStyle(Color.textMid)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Rounds

    private func roundCards(vm: DuelViewModel) -> some View {
        VStack(spacing: 8) {
            ForEach(vm.rounds) { round in
                RoundCard(round: round)
            }
        }
    }

    // MARK: - Win Bonus

    private func winBonusCard(vm: DuelViewModel) -> some View {
        VStack(spacing: 4) {
            Image(systemName: "trophy.fill")
                .font(.title3)
                .foregroundStyle(Color.victory)
            Text("Win 3+ rounds for")
                .font(.brand(.body))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            Text("+200 Bonus XP")
                .font(.brand(.headline))
                .foregroundStyle(Color.victory)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.victoryBG, Color.victory.opacity(0.05)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
    }

    // MARK: - Share

    private func shareButton(vm: DuelViewModel) -> some View {
        Button {
            if let image = ShareCardService.renderDuelCard(
                won: vm.currentWon,
                lost: vm.currentLost,
                momentum: vm.momentum
            ) {
                ShareHelper.share(image)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                Text("Share Results")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(Color.rival)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.rivalBG, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    NavigationStack {
        DuelView()
    }
    .modelContainer(
        for: [Idea.self, Milestone.self, PlayerProfile.self,
              WeeklySnapshot.self, CurrentWeekTracker.self] as [any PersistentModel.Type],
        inMemory: true
    )
}
