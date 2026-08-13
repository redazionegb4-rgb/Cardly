import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: CardStore
    @State private var searchText = ""
    @State private var showingAdd = false
    @State private var selectedCategory: CardCategory?

    private var filtered: [LoyaltyCard] {
        store.cards.filter { card in
            let s = searchText.isEmpty || card.name.localizedCaseInsensitiveContains(searchText) || card.subtitle.localizedCaseInsensitiveContains(searchText) || card.number.localizedCaseInsensitiveContains(searchText)
            let c = selectedCategory == nil || card.category == selectedCategory
            return s && c
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CardlyBackground()
                ScrollView {
                    VStack(spacing: 18) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Cardly").font(.system(size: 36, weight: .bold, design: .rounded))
                                Text(store.cards.isEmpty ? "Le tue tessere. Solo quelle che servono." : "\(store.cards.count) tessere")
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button { showingAdd = true } label: {
                                Image(systemName: "plus").font(.headline.bold()).foregroundStyle(.white)
                                    .frame(width: 44, height: 44).background(.black, in: Circle())
                            }
                        }
                        .padding(.top, 8)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                chip(nil, "Tutte", "square.grid.2x2")
                                ForEach(CardCategory.allCases) { item in chip(item, item.rawValue, item.icon) }
                            }
                        }

                        if filtered.isEmpty {
                            VStack(spacing: 16) {
                                Spacer(minLength: 45)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22).fill(Color(.secondarySystemBackground)).frame(width: 130, height: 88).rotationEffect(.degrees(-7))
                                    RoundedRectangle(cornerRadius: 22).stroke(.primary.opacity(0.15)).frame(width: 130, height: 88).rotationEffect(.degrees(7))
                                    Image(systemName: "wallet.pass").font(.system(size: 38, weight: .medium))
                                }
                                Text("Il tuo wallet è vuoto").font(.title3.bold())
                                Text("Scansiona il codice della tua tessera oppure inseriscilo manualmente.")
                                    .font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center).padding(.horizontal, 34)
                                Button { showingAdd = true } label: { Label("Aggiungi tessera", systemImage: "plus").frame(maxWidth: 210) }
                                    .buttonStyle(.borderedProminent).tint(.black)
                            }.frame(maxWidth: .infinity)
                        } else {
                            LazyVStack(spacing: -72) {
                                ForEach(Array(filtered.enumerated()), id: \.element.id) { index, card in
                                    NavigationLink { CardDetailView(cardID: card.id) } label: { WalletCardView(card: card) }
                                        .buttonStyle(.plain).zIndex(Double(filtered.count-index))
                                }
                            }
                            .padding(.bottom, CGFloat(max(filtered.count-1,0))*72 + 30)
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Cerca tessera")
            .sheet(isPresented: $showingAdd) { AddEditCardView() }
        }
    }

    private func chip(_ category: CardCategory?, _ title: String, _ icon: String) -> some View {
        Button { withAnimation(.easeInOut(duration: 0.16)) { selectedCategory = category } } label: {
            Label(title, systemImage: icon).font(.caption.weight(.semibold))
                .padding(.horizontal, 13).padding(.vertical, 9)
                .background(selectedCategory == category ? Color.black : Color(.secondarySystemBackground), in: Capsule())
                .foregroundStyle(selectedCategory == category ? .white : .primary)
        }.buttonStyle(.plain)
    }
}

struct WalletCardView: View {
    let card: LoyaltyCard
    private var colors: [Color] { CardlyTheme.gradients[abs(card.colorHex.hashValue) % CardlyTheme.gradients.count] }
    var body: some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: card.category.icon).font(.title3.weight(.semibold))
                    Spacer(); if card.isFavorite { Image(systemName: "star.fill") }
                }
                Spacer()
                Text(card.name).font(.system(size: 25, weight: .semibold, design: .rounded)).lineLimit(1)
                Text(card.subtitle.isEmpty ? card.category.rawValue : card.subtitle).font(.subheadline).foregroundStyle(.white.opacity(0.72)).lineLimit(1)
                Spacer()
                HStack { Text(mask(card.number)).font(.caption.monospaced().weight(.medium)); Spacer(); Image(systemName: "barcode").font(.title3) }
            }.padding(22).foregroundStyle(.white)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.13), radius: 18, y: 8)
    }
    private func mask(_ value: String) -> String { value.count > 4 ? "••••  \(value.suffix(4))" : value }
}
