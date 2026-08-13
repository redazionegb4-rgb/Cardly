import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: CardStore
    private var favorites: [LoyaltyCard] { store.cards.filter(\.favorite) }

    var body: some View {
        NavigationStack {
            ZStack {
                DynamicBackdrop()
                if favorites.isEmpty {
                    GlassCard(radius: 34) {
                        VStack(spacing: 14) {
                            Image(systemName: "star").font(.system(size: 42)).foregroundStyle(CardlyUI.accent)
                            Text("Nessun preferito").font(.title3.bold())
                            Text("Le tessere che usi di più appariranno qui.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favorites) { card in
                                NavigationLink {
                                    CardDetailView(cardID: card.id)
                                } label: { HeroCardView(card: card) }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(18)
                        .padding(.bottom, 140)
                    }
                }
            }
            .navigationTitle("Preferiti")
        }
    }
}
