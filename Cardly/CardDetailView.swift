import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject private var store: CardStore
    @Environment(\.dismiss) private var dismiss
    let cardID: UUID

    @State private var showEdit = false
    @State private var oldBrightness: CGFloat?

    private var card: LoyaltyCard? {
        store.cards.first(where: { $0.id == cardID })
    }

    var body: some View {
        ZStack {
            CardlyBackground()

            if let card {
                ScrollView {
                    VStack(spacing: 18) {
                        WalletCardView(card: card)

                        GlassPanel {
                            VStack(spacing: 18) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Mostra alla cassa")
                                            .font(.title3.bold())
                                        Text(card.codeKind.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "sun.max.fill")
                                        .foregroundStyle(.yellow)
                                }

                                BarcodeImageView(value: card.number, kind: card.codeKind, height: 190)
                                    .padding(12)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))

                                Text(card.number)
                                    .font(.body.monospaced())
                                    .textSelection(.enabled)
                            }
                        }

                        if !card.notes.isEmpty {
                            GlassPanel {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Note", systemImage: "note.text")
                                        .font(.headline)
                                    Text(card.notes)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        HStack(spacing: 12) {
                            Button {
                                store.toggleFavorite(card)
                            } label: {
                                Label(card.isFavorite ? "Preferita" : "Preferiti",
                                      systemImage: card.isFavorite ? "star.fill" : "star")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(CardlyTheme.blue)

                            Button {
                                showEdit = true
                            } label: {
                                Label("Modifica", systemImage: "pencil")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
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
                    .padding()
                }
                .sheet(isPresented: $showEdit) {
                    AddEditCardView(card: card)
                }
                .onAppear { setBrightness() }
                .onDisappear { restoreBrightness() }
            } else {
                ContentUnavailableView("Tessera non trovata", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle(card?.name ?? "Tessera")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func setBrightness() {
        guard oldBrightness == nil else { return }
        oldBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1
    }

    private func restoreBrightness() {
        guard let oldBrightness else { return }
        UIScreen.main.brightness = oldBrightness
        self.oldBrightness = nil
    }
}
