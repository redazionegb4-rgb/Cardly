import SwiftUI

enum MainSection {
    case wallet, favorites, settings
}

struct MainShell: View {
    @State private var section: MainSection = .wallet
    @State private var showAdd = false

    var body: some View {
        Group {
            switch section {
            case .wallet:
                WalletView(showAdd: $showAdd)
            case .favorites:
                FavoritesView()
            case .settings:
                SettingsView()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .padding(.bottom, 6)
        }
        .sheet(isPresented: $showAdd) {
            AddEditCardView()
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 0) {
            navButton(.wallet, icon: "wallet.pass.fill", title: "Wallet")
            navButton(.favorites, icon: "star.fill", title: "Preferiti")

            Button {
                section = .wallet
                showAdd = true
            } label: {
                ZStack {
                    Circle()
                        .fill(CardlyUI.accent.gradient)
                        .frame(width: 58, height: 58)
                        .shadow(color: CardlyUI.accent.opacity(0.32), radius: 16, y: 7)

                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Aggiungi tessera")

            navButton(.settings, icon: "slider.horizontal.3", title: "Impostazioni")
        }
        .frame(height: 72)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 0.8)
        }
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
    }

    private func navButton(_ target: MainSection, icon: String, title: String) -> some View {
        Button {
            withAnimation(.snappy) {
                section = target
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))

                Text(title)
                    .font(.system(size: 10, weight: .semibold))
            }
            .foregroundStyle(section == target ? CardlyUI.accent : .secondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
