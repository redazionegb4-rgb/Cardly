import SwiftUI

struct AddEditCardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CardStore

    private let editingCard: LoyaltyCard?

    @State private var name: String
    @State private var subtitle: String
    @State private var number: String
    @State private var category: CardCategory
    @State private var codeKind: CodeKind
    @State private var colorHex: String
    @State private var notes: String
    @State private var showScanner = false

    init(card: LoyaltyCard? = nil) {
        editingCard = card
        _name = State(initialValue: card?.name ?? "")
        _subtitle = State(initialValue: card?.subtitle ?? "")
        _number = State(initialValue: card?.number ?? "")
        _category = State(initialValue: card?.category ?? .shopping)
        _codeKind = State(initialValue: card?.codeKind ?? .code128)
        _colorHex = State(initialValue: card?.colorHex ?? CardlyTheme.cardColors[0])
        _notes = State(initialValue: card?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CardlyBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        preview
                        detailsSection
                        codeSection
                        appearanceSection
                        notesSection
                    }
                    .padding()
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
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty ||
                                  number.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .fullScreenCover(isPresented: $showScanner) {
                ScannerView(scannedValue: $number)
                    .ignoresSafeArea()
            }
        }
    }

    private var preview: some View {
        WalletCardView(card: LoyaltyCard(
            name: name.isEmpty ? "Nome tessera" : name,
            subtitle: subtitle.isEmpty ? category.rawValue : subtitle,
            number: number.isEmpty ? "000000000000" : number,
            category: category,
            codeKind: codeKind,
            colorHex: colorHex
        ))
    }

    private var detailsSection: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Dettagli", icon: "text.alignleft")
                TextField("Nome negozio o tessera", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("Sottotitolo (opzionale)", text: $subtitle)
                    .textFieldStyle(.roundedBorder)

                Picker("Categoria", selection: $category) {
                    ForEach(CardCategory.allCases) { item in
                        Label(item.rawValue, systemImage: item.icon).tag(item)
                    }
                }
            }
        }
    }

    private var codeSection: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Codice", icon: "barcode.viewfinder")

                TextField("Numero tessera / contenuto", text: $number)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                Picker("Formato", selection: $codeKind) {
                    ForEach(CodeKind.allCases) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }

                Button {
                    showScanner = true
                } label: {
                    Label("Scansiona con fotocamera", systemImage: "camera.viewfinder")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(CardlyTheme.blue)
            }
        }
    }

    private var appearanceSection: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Colore", icon: "paintpalette.fill")
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 14) {
                    ForEach(CardlyTheme.cardColors, id: \.self) { value in
                        Button {
                            withAnimation(.snappy) { colorHex = value }
                        } label: {
                            Circle()
                                .fill(Color(hex: value).gradient)
                                .frame(width: 48, height: 48)
                                .overlay {
                                    if colorHex == value {
                                        Image(systemName: "checkmark")
                                            .font(.headline.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var notesSection: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Note", icon: "note.text")
                TextField("Note facoltative", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private func sectionTitle(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.headline)
    }

    private func save() {
        if var card = editingCard {
            card.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            card.subtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
            card.number = number.trimmingCharacters(in: .whitespacesAndNewlines)
            card.category = category
            card.codeKind = codeKind
            card.colorHex = colorHex
            card.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            store.update(card)
        } else {
            store.add(LoyaltyCard(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                subtitle: subtitle.trimmingCharacters(in: .whitespacesAndNewlines),
                number: number.trimmingCharacters(in: .whitespacesAndNewlines),
                category: category,
                codeKind: codeKind,
                colorHex: colorHex,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            ))
        }
        dismiss()
    }
}
