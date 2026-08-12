import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: CardStore
    @State private var searchText = ""
    @State private var showingAdd = false
    @State private var selectedCategory: CardCategory?

    private var filtered: [LoyaltyCard] {
        store.cards.filter { card in
            let matchesSearch = searchText.isEmpty ||
                card.name.localizedCaseInsensitiveContains(searchText) ||
                card.subtitle.localizedCaseInsensitiveContains(searchText) ||
                card.number.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || card.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    hero

                    categoryScroller

                    if filtered.isEmpty {
                        ContentUnavailableView(
                            store.cards.isEmpty ? "Nessuna tessera" : "Nessun risultato",
                            systemImage: store.cards.isEmpty ? "wallet.pass" : "magnifyingglass",
                            description: Text(store.cards.isEmpty ?
                                              "Aggiungi la tua prima carta fedeltà con il pulsante +." :
                                              "Prova a cambiare ricerca o categoria.")
                        )
                        .padding(.top, 28)
                    } else {
                        LazyVStack(spacing: 14) {
                            ForEach(filtered) { card in
                                NavigationLink {
                                    CardDetailView(cardID: card.id)
                                } label: {
                                    CardTile(card: card)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Cardly")
            .searchable(text: $searchText, prompt: "Cerca tessera")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Aggiungi tessera")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddCardView()
            }
        }
    }

    private var hero: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Tutte le tue tessere")
                    .font(.title2.bold())
                Text("\(store.cards.count) salvate sul tuo iPhone")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "wallet.pass.fill")
                .font(.system(size: 38))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var categoryScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                categoryButton(nil, title: "Tutte", icon: "square.grid.2x2.fill")
                ForEach(CardCategory.allCases) { category in
                    categoryButton(category, title: category.rawValue, icon: category.icon)
                }
            }
        }
    }

    private func categoryButton(_ category: CardCategory?, title: String, icon: String) -> some View {
        Button {
            selectedCategory = category
        } label: {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    (selectedCategory == category ? Color.blue : Color(.secondarySystemGroupedBackground)),
                    in: Capsule()
                )
                .foregroundStyle(selectedCategory == category ? .white : .primary)
        }
    }
}

struct CardTile: View {
    let card: LoyaltyCard

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: card.colorHex).gradient)
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: card.category.icon)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(card.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    if card.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                Text(card.subtitle.isEmpty ? card.category.rawValue : card.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(masked(card.number))
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func masked(_ value: String) -> String {
        guard value.count > 4 else { return value }
        return "•••• " + value.suffix(4)
    }
}
