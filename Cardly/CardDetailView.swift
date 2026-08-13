import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject private var store: CardStore
    @Environment(\.dismiss) private var dismiss
    let cardID: UUID

    @State private var showEdit = false
    @State private var originalBrightness: CGFloat?

    private var card: LoyaltyCard? {
        store.cards.first(where: { $0.id == cardID })
    }

    var body: some View {
        ZStack {
            AuroraBackground()

            if let card {
                ScrollView {
                    VStack(spacing: 18) {
                        PrismCardView(card: card)

                        LiquidGlass(cornerRadius: 32) {
                            VStack(spacing: 18) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Mostra alla cassa")
                                            .font(.title3.bold())
                                        Text(card.codeType.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "sun.max.fill")
                                        .font(.title3)
                                        .foregroundStyle(.yellow)
                                }

                                BarcodeImageView(value: card.code, type: card.codeType)
                                    .padding(14)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))

                                Text(card.code)
                                    .font(.body.monospaced())
                                    .textSelection(.enabled)
                            }
                        }

                        if !card.notes.isEmpty {
                            LiquidGlass {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Note", systemImage: "note.text")
                                        .font(.headline)
                                    Text(card.notes)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }

                        HStack(spacing: 12) {
                            Button {
                                store.toggleFavorite(card)
                            } label: {
                                Label(card.favorite ? "Preferita" : "Preferiti",
                                      systemImage: card.favorite ? "star.fill" : "star")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(LiquidDesign.accent)

                            Button {
                                showEdit = true
                            } label: {
                                Label("Modifica", systemImage: "pencil")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        }

                        Button(role: .destructive) {
                            store.delete(card)
                            dismiss()
                        } label: {
                            Label("Elimina tessera", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(16)
                }
                .sheet(isPresented: $showEdit) {
                    AddEditCardView(card: card)
                }
                .onAppear { maximizeBrightness() }
                .onDisappear { restoreBrightness() }
            } else {
                ContentUnavailableView("Tessera non trovata", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle(card?.title ?? "Tessera")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func maximizeBrightness() {
        guard originalBrightness == nil else { return }
        originalBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1
    }

    private func restoreBrightness() {
        guard let originalBrightness else { return }
        UIScreen.main.brightness = originalBrightness
        self.originalBrightness = nil
    }
}
