import SwiftUI

enum MainSection {
    case wallet
    case favorites
    case categories
    case settings
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

            case .categories:
                CategoriesView()

            case .settings:
                SettingsView()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
                .padding(.horizontal, 14)
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
                        .frame(width: 62, height: 62)
                        .shadow(
                            color: CardlyUI.accent.opacity(0.34),
                            radius: 18,
                            y: 8
                        )

                    Image(systemName: "plus")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Aggiungi tessera")

            navButton(.categories, icon: "square.grid.2x2.fill", title: "Categorie")
            navButton(.settings, icon: "slider.horizontal.3", title: "Impostazioni")
        }
        .frame(height: 78)
        .padding(.horizontal, 8)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 32, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 0.8)
        }
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
    }

    private func navButton(
        _ target: MainSection,
        icon: String,
        title: String
    ) -> some View {
        Button {
            withAnimation(.snappy) {
                section = target
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))

                Text(title)
                    .font(.system(size: 9.5, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .foregroundStyle(
                section == target
                ? CardlyUI.accent
                : .secondary
            )
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
