import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var store: CardStore

    var body: some View {
        NavigationStack {
            ZStack {
                DynamicBackdrop()

                ScrollView {
                    VStack(spacing: 18) {
                        header

                        ForEach(CardCategory.allCases) { category in
                            categoryCard(category)
                        }
                    }
                    .padding(18)
                    .padding(.bottom, 140)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Categorie")
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                Text("Trova più velocemente le tue tessere.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "square.grid.2x2.fill")
                .font(.title2)
                .foregroundStyle(CardlyUI.accent)
                .frame(width: 46, height: 46)
                .background(.ultraThinMaterial, in: Circle())
        }
    }

    private func categoryCard(_ category: CardCategory) -> some View {
        let cards = store.cards.filter { $0.category == category }

        return NavigationLink {
            CategoryCardsView(category: category)
        } label: {
            GlassCard(radius: 26) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(CardlyUI.accent.opacity(0.14))
                            .frame(width: 50, height: 50)

                        Image(systemName: category.symbol)
                            .foregroundStyle(CardlyUI.accent)
                            .font(.title3.weight(.semibold))
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(category.rawValue)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text("\(cards.count) tessere")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct CategoryCardsView: View {
    @EnvironmentObject private var store: CardStore
    let category: CardCategory

    private var cards: [LoyaltyCard] {
        store.cards.filter { $0.category == category }
    }

    var body: some View {
        ZStack {
            DynamicBackdrop()

            if cards.isEmpty {
                ContentUnavailableView(
                    "Nessuna tessera",
                    systemImage: category.symbol,
                    description: Text("Non hai ancora tessere in \(category.rawValue).")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(cards) { card in
                            NavigationLink {
                                CardDetailView(cardID: card.id)
                            } label: {
                                HeroCardView(card: card)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(18)
                    .padding(.bottom, 140)
                }
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
