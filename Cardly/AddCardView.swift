import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CardStore

    @State private var name = ""
    @State private var subtitle = ""
    @State private var number = ""
    @State private var category: CardCategory = .shopping
    @State private var codeKind: CodeKind = .code128
    @State private var colorHex = "1D4ED8"
    @State private var showingScanner = false

    private let colors = ["1D4ED8", "7C3AED", "DB2777", "DC2626", "EA580C", "059669", "0F766E", "111827"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Tessera") {
                    TextField("Nome negozio o tessera", text: $name)
                    TextField("Sottotitolo (opzionale)", text: $subtitle)

                    Picker("Categoria", selection: $category) {
                        ForEach(CardCategory.allCases) { item in
                            Label(item.rawValue, systemImage: item.icon).tag(item)
                        }
                    }
                }

                Section("Codice") {
                    TextField("Numero tessera / contenuto codice", text: $number)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    Picker("Tipo codice", selection: $codeKind) {
                        ForEach(CodeKind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }

                    Button {
                        showingScanner = true
                    } label: {
                        Label("Scansiona con fotocamera", systemImage: "barcode.viewfinder")
                    }
                }

                Section("Colore") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(colors, id: \.self) { value in
                            Button {
                                colorHex = value
                            } label: {
                                Circle()
                                    .fill(Color(hex: value).gradient)
                                    .frame(width: 44, height: 44)
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
                    .padding(.vertical, 6)
                }

                if !number.isEmpty {
                    Section("Anteprima") {
                        BarcodeImageView(value: number, kind: codeKind, height: 110)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Nuova tessera")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                  number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .fullScreenCover(isPresented: $showingScanner) {
                ScannerView(scannedValue: $number)
                    .ignoresSafeArea()
            }
        }
    }

    private func save() {
        store.add(
            LoyaltyCard(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                subtitle: subtitle.trimmingCharacters(in: .whitespacesAndNewlines),
                number: number.trimmingCharacters(in: .whitespacesAndNewlines),
                category: category,
                codeKind: codeKind,
                colorHex: colorHex
            )
        )
        dismiss()
    }
}
