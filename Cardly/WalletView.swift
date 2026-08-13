import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var store: CardStore
    @State private var searchText = ""
    @State private var selectedCategory: CardCategory?
    @State private var showAdd = false

    private var filtered: [LoyaltyCard] {
        store.cards.filter { card in
            let matchesSearch = searchText.isEmpty ||
                card.title.localizedCaseInsensitiveContains(searchText) ||
                card.subtitle.localizedCaseInsensitiveContains(searchText) ||
                card.code.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || card.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        header
                        smartPanel
                        categoryStrip

                        if filtered.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(filtered) { card in
                                    NavigationLink {
                                        CardDetailView(cardID: card.id)
                                    } label: {
                                        PrismCardView(card: card)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Cerca tessera, negozio o codice")
            .sheet(isPresented: $showAdd) {
                AddEditCardView()
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("CARDLY")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .tracking(2.2)
                    .foregroundStyle(.secondary)

                Text("Il tuo wallet")
                    .font(.system(size: 36, weight: .bold, design: .rounded))

                Text(store.cards.isEmpty ? "Pronto per la tua prima tessera" : "\(store.cards.count) tessere sempre con te")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                showAdd = true
            } label: {
                GlowIcon(symbol: "plus", color: LiquidDesign.accent)
            }
            .accessibilityLabel("Aggiungi tessera")
        }
        .padding(.top, 12)
    }

    private var smartPanel: some View {
        LiquidGlass(cornerRadius: 30) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.indigo, Color.cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 58, height: 58)

                    Image(systemName: "wave.3.right")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Pronta alla cassa")
                        .font(.headline)
                    Text("Apri una tessera e Cardly porta la luminosità al massimo.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
        }
    }

    private var categoryStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                chip(nil, title: "Tutte", symbol: "square.grid.2x2.fill")
                ForEach(CardCategory.allCases) { item in
                    chip(item, title: item.rawValue, symbol: item.symbol)
                }
            }
        }
    }

    private func chip(_ category: CardCategory?, title: String, symbol: String) -> some View {
        Button {
            withAnimation(.snappy) { selectedCategory = category }
        } label: {
            HStack(spacing: 7) {
                Image(systemName: symbol)
                Text(title)
            }
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .stroke(selectedCategory == category ? LiquidDesign.accent.opacity(0.9) : .white.opacity(0.12), lineWidth: 1)
            }
            .foregroundStyle(selectedCategory == category ? LiquidDesign.accent : .primary)
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        LiquidGlass(cornerRadius: 34) {
            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.indigo.opacity(0.16))
                        .frame(width: 122, height: 86)
                        .rotationEffect(.degrees(-7))
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.cyan.opacity(0.16))
                        .frame(width: 122, height: 86)
                        .rotationEffect(.degrees(7))
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 38, weight: .medium))
                        .foregroundStyle(LiquidDesign.accent)
                }

                Text("Crea il tuo wallet")
                    .font(.title3.bold())

                Text("Scansiona QR e barcode delle carte fedeltà oppure inserisci il codice manualmente.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button {
                    showAdd = true
                } label: {
                    Label("Aggiungi la prima tessera", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(LiquidDesign.accent)
            }
        }
        .padding(.top, 12)
    }
}

struct PrismCardView: View {
    let card: LoyaltyCard

    private var palette: [Color] {
        LiquidDesign.cardPalettes[max(0, min(card.styleIndex, LiquidDesign.cardPalettes.count - 1))]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: palette, startPoint: .topLeading, endPoint: .bottomTrailing)

            Circle()
                .fill(.white.opacity(0.14))
                .frame(width: 220, height: 220)
                .blur(radius: 4)
                .offset(x: 140, y: -100)

            Circle()
                .fill(.black.opacity(0.10))
                .frame(width: 180, height: 180)
                .blur(radius: 8)
                .offset(x: -150, y: 110)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.white.opacity(0.18))
                            .frame(width: 48, height: 48)
                        Image(systemName: card.category.symbol)
                            .font(.title3.weight(.semibold))
                    }

                    Spacer()

                    if card.favorite {
                        Image(systemName: "star.fill")
                            .font(.headline)
                    }
                }

                Spacer()

                Text(card.title)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .lineLimit(1)

                Text(card.subtitle.isEmpty ? card.category.rawValue : card.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))
                    .lineLimit(1)

                HStack {
                    Text(mask(card.code))
                        .font(.caption.monospaced().weight(.semibold))
                    Spacer()
                    Image(systemName: card.codeType == .qr ? "qrcode" : "barcode")
                        .font(.title2)
                }
                .padding(.top, 16)
            }
            .padding(20)
            .foregroundStyle(.white)
        }
        .frame(height: 205)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.22), lineWidth: 0.9)
        }
        .shadow(color: palette[0].opacity(0.28), radius: 24, y: 10)
    }

    private func mask(_ value: String) -> String {
        guard value.count > 4 else { return value }
        return "••••  " + value.suffix(4)
    }
}
