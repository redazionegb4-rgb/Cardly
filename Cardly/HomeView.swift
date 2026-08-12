import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: CardStore
    @State private var searchText = ""
    @State private var showAdd = false
    @State private var selectedCategory: CardCategory?

    private var filtered: [LoyaltyCard] {
        store.cards.filter { card in
            let searchOK = searchText.isEmpty ||
                card.name.localizedCaseInsensitiveContains(searchText) ||
                card.subtitle.localizedCaseInsensitiveContains(searchText) ||
                card.number.localizedCaseInsensitiveContains(searchText)
            let categoryOK = selectedCategory == nil || card.category == selectedCategory
            return searchOK && categoryOK
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CardlyBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        header
                        categories

                        if filtered.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 15) {
                                ForEach(filtered) { card in
                                    NavigationLink {
                                        CardDetailView(cardID: card.id)
                                    } label: {
                                        WalletCardView(card: card)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "Cerca una tessera")
            .sheet(isPresented: $showAdd) {
                AddEditCardView()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cardly")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text(store.cards.isEmpty ? "Il tuo wallet, finalmente ordinato." : "\(store.cards.count) tessere nel tuo wallet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(CardlyTheme.blue.gradient, in: Circle())
                        .shadow(color: CardlyTheme.blue.opacity(0.25), radius: 12, y: 5)
                }
            }
            .padding(.top, 14)

            GlassPanel {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(CardlyTheme.blue.opacity(0.12))
                            .frame(width: 58, height: 58)
                        Image(systemName: "wave.3.right.circle.fill")
                            .font(.system(size: 29))
                            .foregroundStyle(CardlyTheme.blue)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pronta alla cassa")
                            .font(.headline)
                        Text("Apri una tessera e mostra il codice a schermo.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
        }
    }

    private var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                categoryChip(nil, title: "Tutte", icon: "square.grid.2x2.fill")
                ForEach(CardCategory.allCases) { category in
                    categoryChip(category, title: category.rawValue, icon: category.icon)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private func categoryChip(_ category: CardCategory?, title: String, icon: String) -> some View {
        Button {
            withAnimation(.snappy) {
                selectedCategory = category
            }
        } label: {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(
                    selectedCategory == category ? CardlyTheme.blue : Color(.secondarySystemGroupedBackground),
                    in: Capsule()
                )
                .foregroundStyle(selectedCategory == category ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 30)

            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(CardlyTheme.blue.opacity(0.10))
                    .frame(width: 118, height: 90)
                    .rotationEffect(.degrees(-8))
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(CardlyTheme.cyan.opacity(0.18))
                    .frame(width: 118, height: 90)
                    .rotationEffect(.degrees(8))
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(CardlyTheme.blue)
            }

            Text(store.cards.isEmpty ? "Aggiungi la prima tessera" : "Nessuna tessera trovata")
                .font(.title3.bold())

            Text(store.cards.isEmpty ?
                 "Scansiona il codice della tua carta fedeltà oppure inseriscilo manualmente." :
                 "Prova a cambiare ricerca o categoria.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 30)

            if store.cards.isEmpty {
                Button {
                    showAdd = true
                } label: {
                    Label("Aggiungi tessera", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: 220)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(CardlyTheme.blue)
            }

            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WalletCardView: View {
    let card: LoyaltyCard

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color(hex: card.colorHex),
                    Color(hex: card.colorHex).opacity(0.78)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(.white.opacity(0.10))
                .frame(width: 180, height: 180)
                .offset(x: 230, y: -70)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white.opacity(0.18))
                            .frame(width: 48, height: 48)
                        Image(systemName: card.category.icon)
                            .font(.title3.bold())
                    }

                    Spacer()

                    if card.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.headline)
                    }
                }

                Spacer()

                Text(card.name)
                    .font(.title3.bold())
                    .lineLimit(1)

                Text(card.subtitle.isEmpty ? card.category.rawValue : card.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))
                    .lineLimit(1)

                HStack {
                    Text(mask(card.number))
                        .font(.caption.monospaced().weight(.semibold))
                    Spacer()
                    Image(systemName: "barcode")
                        .font(.title2)
                }
                .padding(.top, 14)
            }
            .padding(20)
            .foregroundStyle(.white)
        }
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color(hex: card.colorHex).opacity(0.16), radius: 18, y: 8)
    }

    private func mask(_ value: String) -> String {
        guard value.count > 4 else { return value }
        return "••••  " + value.suffix(4)
    }
}
