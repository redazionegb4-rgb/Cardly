import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: CardStore

    private var favorites: [LoyaltyCard] {
        store.cards.filter(\.isFavorite)
    }

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "Nessun preferito",
                        systemImage: "star",
                        description: Text("Apri una tessera e aggiungila ai preferiti.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(favorites) { card in
                                NavigationLink {
                                    CardDetailView(cardID: card.id)
                                } label: {
                                    CardTile(card: card)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Preferiti")
        }
    }
}
