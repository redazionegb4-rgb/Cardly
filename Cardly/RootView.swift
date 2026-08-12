import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Wallet", systemImage: "wallet.pass.fill") }

            FavoritesView()
                .tabItem { Label("Preferiti", systemImage: "star.fill") }

            SettingsView()
                .tabItem { Label("Impostazioni", systemImage: "gearshape.fill") }
        }
        .tint(CardlyTheme.blue)
    }
}
