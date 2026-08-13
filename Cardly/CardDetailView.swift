import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject private var store: CardStore
    @Environment(\.dismiss) private var dismiss
    let cardID: UUID
    @State private var showEdit = false
    @State private var oldBrightness: CGFloat?

    private var card: LoyaltyCard? { store.cards.first(where: { $0.id == cardID }) }

    var body: some View {
        ZStack {
            DynamicBackdrop()

            if let card {
                ScrollView {
                    VStack(spacing: 18) {
                        HeroCardView(card: card)
                            .padding(.top, 8)

                        GlassCard(radius: 34) {
                            VStack(spacing: 18) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Mostra alla cassa").font(.title3.bold())
                                        Text("Luminosità al massimo").font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "sun.max.fill").foregroundStyle(.yellow)
                                }

                                BarcodeImageView(value: card.code, type: card.codeType)
                                    .padding(14)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 24))

                                Text(card.code).font(.body.monospaced()).textSelection(.enabled)
                            }
                        }

                        HStack(spacing: 12) {
                            action(card.favorite ? "Preferita" : "Preferiti", card.favorite ? "star.fill" : "star") {
                                store.toggleFavorite(card)
                            }
                            action("Modifica", "pencil") { showEdit = true }
                        }

                        if !card.notes.isEmpty {
                            GlassCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Note", systemImage: "note.text").font(.headline)
                                    Text(card.notes).foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
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
                    .padding(18)
                    .padding(.bottom, 100)
                }
                .sheet(isPresented: $showEdit) { AddEditCardView(card: card) }
                .onAppear { oldBrightness = UIScreen.main.brightness; UIScreen.main.brightness = 1 }
                .onDisappear { if let oldBrightness { UIScreen.main.brightness = oldBrightness } }
            }
        }
        .navigationTitle(card?.title ?? "Tessera")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func action(_ title: String, _ icon: String, perform: @escaping () -> Void) -> some View {
        Button(action: perform) {
            Label(title, systemImage: icon).frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(CardlyUI.accent)
        .controlSize(.large)
    }
}
