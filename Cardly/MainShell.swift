import SwiftUI

enum MainSection {
    case wallet, favorites, settings
}

struct MainShell: View {
    @State private var section: MainSection = .wallet
    @State private var showAdd = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch section {
                case .wallet: WalletView(showAdd: $showAdd)
                case .favorites: FavoritesView()
                case .settings: SettingsView()
                }
            }

            HStack(spacing: 28) {
                tabButton(.wallet, "wallet.pass.fill")
                tabButton(.favorites, "star.fill")

                Button {
                    showAdd = true
                    section = .wallet
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(CardlyUI.accent.gradient, in: Circle())
                        .shadow(color: CardlyUI.accent.opacity(0.35), radius: 18, y: 8)
                }

                tabButton(.settings, "slider.horizontal.3")
                tabButton(.wallet, "sparkles")
                    .opacity(0)
                    .allowsHitTesting(false)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 11)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 0.8))
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
        }
        .sheet(isPresented: $showAdd) {
            AddEditCardView()
        }
    }

    private func tabButton(_ target: MainSection, _ icon: String) -> some View {
        Button {
            withAnimation(.snappy) { section = target }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(section == target ? CardlyUI.accent : .secondary)
                .frame(width: 34, height: 34)
        }
    }
}
