import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: CardStore

    private var favorites: [LoyaltyCard] {
        store.cards.filter(\.favorite)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackground()

                if favorites.isEmpty {
                    LiquidGlass {
                        VStack(spacing: 14) {
                            Image(systemName: "star")
                                .font(.system(size: 40))
                                .foregroundStyle(LiquidDesign.accent)
                            Text("Nessun preferito")
                                .font(.title3.bold())
                            Text("Aggiungi ai preferiti le tessere che usi più spesso.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favorites) { card in
                                NavigationLink {
                                    CardDetailView(cardID: card.id)
                                } label: {
                                    PrismCardView(card: card)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Preferiti")
        }
    }
}
