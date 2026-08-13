import SwiftUI

struct AddEditCardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CardStore

    let editingCard: LoyaltyCard?

    @State private var title: String
    @State private var subtitle: String
    @State private var code: String
    @State private var category: CardCategory
    @State private var codeType: CodeType
    @State private var styleIndex: Int
    @State private var notes: String
    @State private var showScanner = false

    init(card: LoyaltyCard? = nil) {
        editingCard = card
        _title = State(initialValue: card?.title ?? "")
        _subtitle = State(initialValue: card?.subtitle ?? "")
        _code = State(initialValue: card?.code ?? "")
        _category = State(initialValue: card?.category ?? .shopping)
        _codeType = State(initialValue: card?.codeType ?? .barcode)
        _styleIndex = State(initialValue: card?.styleIndex ?? 0)
        _notes = State(initialValue: card?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        PrismCardView(card: previewCard)

                        LiquidGlass {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionHeader("Identità", "sparkles")
                                TextField("Nome tessera o negozio", text: $title)
                                    .textFieldStyle(.roundedBorder)
                                TextField("Sottotitolo", text: $subtitle)
                                    .textFieldStyle(.roundedBorder)

                                Picker("Categoria", selection: $category) {
                                    ForEach(CardCategory.allCases) { item in
                                        Label(item.rawValue, systemImage: item.symbol).tag(item)
                                    }
                                }
                            }
                        }

                        LiquidGlass {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionHeader("Codice", "barcode.viewfinder")
                                TextField("Numero tessera / contenuto", text: $code)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .textFieldStyle(.roundedBorder)

                                Picker("Formato", selection: $codeType) {
                                    ForEach(CodeType.allCases) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }

                                Button {
                                    showScanner = true
                                } label: {
                                    Label("Scansiona con fotocamera", systemImage: "camera.viewfinder")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .tint(LiquidDesign.accent)
                            }
                        }

                        LiquidGlass {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionHeader("Stile tessera", "paintpalette.fill")

                                HStack(spacing: 12) {
                                    ForEach(0..<LiquidDesign.cardPalettes.count, id: \.self) { index in
                                        Button {
                                            withAnimation(.snappy) { styleIndex = index }
                                        } label: {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: LiquidDesign.cardPalettes[index],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 46, height: 46)
                                                .overlay {
                                                    if index == styleIndex {
                                                        Image(systemName: "checkmark")
                                                            .font(.caption.bold())
                                                            .foregroundStyle(.white)
                                                    }
                                                }
                                                .overlay {
                                                    Circle().stroke(.white.opacity(0.22), lineWidth: 1)
                                                }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        LiquidGlass {
                            VStack(alignment: .leading, spacing: 12) {
                                sectionHeader("Note", "note.text")
                                TextField("Note facoltative", text: $notes, axis: .vertical)
                                    .lineLimit(3...6)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle(editingCard == nil ? "Nuova tessera" : "Modifica tessera")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") { save() }
                        .fontWeight(.semibold)
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                  code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .fullScreenCover(isPresented: $showScanner) {
                ScannerView(scannedValue: $code)
                    .ignoresSafeArea()
            }
        }
    }

    private var previewCard: LoyaltyCard {
        LoyaltyCard(
            title: title.isEmpty ? "La tua tessera" : title,
            subtitle: subtitle,
            code: code.isEmpty ? "000000000000" : code,
            category: category,
            codeType: codeType,
            styleIndex: styleIndex
        )
    }

    private func sectionHeader(_ title: String, _ symbol: String) -> some View {
        Label(title, systemImage: symbol)
            .font(.headline)
    }

    private func save() {
        if var card = editingCard {
            card.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            card.subtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
            card.code = code.trimmingCharacters(in: .whitespacesAndNewlines)
            card.category = category
            card.codeType = codeType
            card.styleIndex = styleIndex
            card.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            store.update(card)
        } else {
            store.add(LoyaltyCard(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                subtitle: subtitle.trimmingCharacters(in: .whitespacesAndNewlines),
                code: code.trimmingCharacters(in: .whitespacesAndNewlines),
                category: category,
                codeType: codeType,
                styleIndex: styleIndex,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            ))
        }
        dismiss()
    }
}
