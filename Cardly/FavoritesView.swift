import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: CardStore

    private var favorites: [LoyaltyCard] {
        store.cards.filter(\.isFavorite)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CardlyBackground()

                if favorites.isEmpty {
                    ContentUnavailableView(
                        "Nessun preferito",
                        systemImage: "star",
                        description: Text("Apri una tessera e tocca Preferiti.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(favorites) { card in
                                NavigationLink {
                                    CardDetailView(cardID: card.id)
                                } label: {
                                    WalletCardView(card: card)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Preferiti")
        }
    }
}
