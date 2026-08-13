import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var store: CardStore
    @Binding var showAdd: Bool
    @State private var search = ""
    @State private var selectedCategory: CardCategory?

    private var cards: [LoyaltyCard] {
        store.cards.filter { card in
            let s = search.isEmpty ||
                card.title.localizedCaseInsensitiveContains(search) ||
                card.subtitle.localizedCaseInsensitiveContains(search) ||
                card.code.localizedCaseInsensitiveContains(search)

            let c = selectedCategory == nil || card.category == selectedCategory
            return s && c
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DynamicBackdrop()

                ScrollView {
                    VStack(spacing: 18) {
                        header
                        searchBar
                        quickActions
                        categories

                        if cards.isEmpty {
                            emptyState
                        } else {
                            cardStack
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                    .padding(.bottom, 140)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Cardly")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .lineLimit(1)

                Text(store.cards.isEmpty ? "Il tuo wallet prende forma qui." : "\(store.cards.count) tessere nel wallet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 46, height: 46)

                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(CardlyUI.accent)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Cerca tessera, negozio o codice", text: $search)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !search.isEmpty {
                Button {
                    search = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 0.8)
        }
    }

    private var quickActions: some View {
        HStack(spacing: 10) {
            quick("Scansiona", "barcode.viewfinder") {
                showAdd = true
            }

            quick("Preferiti", "star.fill") {
                // La sezione preferiti resta raggiungibile dalla barra inferiore.
            }

            quick("Ordina", "arrow.up.arrow.down") {
                // Predisposto per ordinamento intelligente.
            }
        }
    }

    private func quick(_ title: String, _ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 19, weight: .semibold))

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 74)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 0.8)
            }
        }
        .buttonStyle(.plain)
    }

    private var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                categoryChip(nil, "Tutte", "square.grid.2x2.fill")

                ForEach(CardCategory.allCases) { item in
                    categoryChip(item, item.rawValue, item.symbol)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private func categoryChip(_ value: CardCategory?, _ title: String, _ icon: String) -> some View {
        Button {
            withAnimation(.snappy) {
                selectedCategory = value
            }
        } label: {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(selectedCategory == value ? CardlyUI.accent.opacity(0.18) : .clear)
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(selectedCategory == value ? CardlyUI.accent : .primary)
                .overlay {
                    Capsule()
                        .stroke(
                            selectedCategory == value
                            ? CardlyUI.accent.opacity(0.55)
                            : .white.opacity(0.10),
                            lineWidth: 0.8
                        )
                }
        }
        .buttonStyle(.plain)
    }

    private var cardStack: some View {
        VStack(spacing: -118) {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                NavigationLink {
                    CardDetailView(cardID: card.id)
                } label: {
                    HeroCardView(card: card)
                        .scaleEffect(1 - CGFloat(index) * 0.015)
                        .offset(y: CGFloat(index) * 4)
                }
                .buttonStyle(.plain)
                .zIndex(Double(cards.count - index))
            }
        }
        .padding(.bottom, CGFloat(max(cards.count - 1, 0)) * 118 + 20)
    }

    private var emptyState: some View {
        GlassCard(radius: 34) {
            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(.ultraThinMaterial)
                        .frame(width: 140, height: 92)
                        .rotationEffect(.degrees(-8))

                    RoundedRectangle(cornerRadius: 26)
                        .fill(CardlyUI.accent.opacity(0.18))
                        .frame(width: 140, height: 92)
                        .rotationEffect(.degrees(8))

                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(CardlyUI.accent)
                }

                Text("Il tuo wallet è vuoto")
                    .font(.title3.bold())

                Text("Scansiona la prima tessera e Cardly farà il resto.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button {
                    showAdd = true
                } label: {
                    Label("Aggiungi tessera", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(CardlyUI.accent)
                .controlSize(.large)
            }
        }
        .padding(.top, 4)
    }
}

struct HeroCardView: View {
    let card: LoyaltyCard

    private var palette: [Color] {
        CardlyUI.palettes[max(0, min(card.styleIndex, CardlyUI.palettes.count - 1))]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: palette, startPoint: .topLeading, endPoint: .bottomTrailing)

            Circle()
                .fill(.white.opacity(0.16))
                .frame(width: 240, height: 240)
                .blur(radius: 4)
                .offset(x: 150, y: -120)

            Circle()
                .fill(.black.opacity(0.12))
                .frame(width: 180, height: 180)
                .blur(radius: 8)
                .offset(x: -150, y: 110)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: card.category.symbol)
                        .font(.title3.bold())
                        .frame(width: 48, height: 48)
                        .background(.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 16))

                    Spacer()

                    if card.favorite {
                        Image(systemName: "star.fill")
                    }
                }

                Spacer()

                Text(card.title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .lineLimit(1)

                Text(card.subtitle.isEmpty ? card.category.rawValue : card.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))

                HStack {
                    Text(mask(card.code))
                        .font(.caption.monospaced().weight(.semibold))

                    Spacer()

                    Image(systemName: card.codeType == .qr ? "qrcode" : "barcode")
                        .font(.title2)
                }
                .padding(.top, 15)
            }
            .padding(21)
            .foregroundStyle(.white)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(.white.opacity(0.24), lineWidth: 1)
        }
        .shadow(color: palette[0].opacity(0.30), radius: 26, y: 12)
    }

    private func mask(_ value: String) -> String {
        guard value.count > 4 else { return value }
        return "••••  " + value.suffix(4)
    }
}
