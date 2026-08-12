import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject private var store: CardStore
    @Environment(\.dismiss) private var dismiss
    let cardID: UUID

    @State private var originalBrightness: CGFloat?

    private var card: LoyaltyCard? {
        store.cards.first(where: { $0.id == cardID })
    }

    var body: some View {
        Group {
            if let card {
                ScrollView {
                    VStack(spacing: 22) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: card.category.icon)
                                    .font(.title.bold())
                                Spacer()
                                Image(systemName: card.isFavorite ? "star.fill" : "star")
                                    .font(.title3)
                            }
                            Spacer(minLength: 26)
                            Text(card.name)
                                .font(.largeTitle.bold())
                            Text(card.subtitle.isEmpty ? card.category.rawValue : card.subtitle)
                                .foregroundStyle(.white.opacity(0.82))
                            Text(card.number)
                                .font(.subheadline.monospaced())
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .foregroundStyle(.white)
                        .padding(24)
                        .frame(maxWidth: .infinity, minHeight: 220, alignment: .leading)
                        .background(Color(hex: card.colorHex).gradient, in: RoundedRectangle(cornerRadius: 28, style: .continuous))

                        VStack(spacing: 14) {
                            Text("Mostra alla cassa")
                                .font(.headline)
                            BarcodeImageView(value: card.number, kind: card.codeKind, height: 190)
                                .padding(.horizontal, 10)
                            Text(card.number)
                                .font(.body.monospaced())
                                .textSelection(.enabled)
                        }
                        .padding(20)
                        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                        Button {
                            store.toggleFavorite(card)
                        } label: {
                            Label(card.isFavorite ? "Rimuovi dai preferiti" : "Aggiungi ai preferiti",
                                  systemImage: card.isFavorite ? "star.slash" : "star")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)

                        Button(role: .destructive) {
                            store.delete(card)
                            dismiss()
                        } label: {
                            Label("Elimina tessera", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle(card.name)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear { boostBrightness() }
                .onDisappear { restoreBrightness() }
            } else {
                ContentUnavailableView("Tessera non trovata", systemImage: "exclamationmark.triangle")
            }
        }
    }

    private func boostBrightness() {
        guard originalBrightness == nil else { return }
        originalBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1
    }

    private func restoreBrightness() {
        if let originalBrightness {
            UIScreen.main.brightness = originalBrightness
            self.originalBrightness = nil
        }
    }
}
