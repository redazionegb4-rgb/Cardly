import SwiftUI

struct AddEditCardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CardStore

    let editingCard: LoyaltyCard?
    @State private var step = 0

    @State private var title: String
    @State private var subtitle: String
    @State private var code: String
    @State private var category: CardCategory
    @State private var codeType: CodeType
    @State private var styleIndex: Int
    @State private var notes: String
    @State private var scanner = false

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
                DynamicBackdrop()

                VStack(spacing: 16) {
                    progress

                    if step == 0 { scanStep }
                    else if step == 1 { identityStep }
                    else { styleStep }

                    Spacer()

HStack(spacing: 14) {
    if step > 0 {
        Button {
            withAnimation(.snappy) {
                step -= 1
            }
        } label: {
            Text("Indietro")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .buttonStyle(.bordered)
        .tint(.primary)
    } else {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 52)
    }

    Button {
        if step < 2 {
            withAnimation(.snappy) {
                step += 1
            }
        } else {
            save()
        }
    } label: {
        Text(step == 2 ? "Salva tessera" : "Continua")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
    }
    .buttonStyle(.borderedProminent)
    .tint(CardlyUI.accent)
    .disabled(step == 0 && code.isEmpty || step == 1 && title.isEmpty)
}
.frame(maxWidth: .infinity)
                }
                .padding(18)
                .padding(.bottom, 24)
            }
            .navigationTitle(editingCard == nil ? "Nuova tessera" : "Modifica tessera")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Chiudi") { dismiss() }
                }
            }
            .fullScreenCover(isPresented: $scanner) {
                ScannerView(scannedValue: $code).ignoresSafeArea()
            }
        }
    }

    private var progress: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { i in
                Capsule()
                    .fill(i <= step ? CardlyUI.accent : Color.secondary.opacity(0.2))
                    .frame(height: 6)
            }
        }
    }

    private var scanStep: some View {
        GlassCard(radius: 34) {
            VStack(spacing: 20) {
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 48))
                    .foregroundStyle(CardlyUI.accent)
                Text("Scansiona la tessera").font(.title2.bold())
                Text("Inquadra il barcode o QR. Puoi anche inserire il codice manualmente.")
                    .font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)

                Button {
                    scanner = true
                } label: {
                    Label("Apri scanner", systemImage: "camera.viewfinder")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(CardlyUI.accent)

                TextField("Codice manuale", text: $code)
                    .textFieldStyle(.roundedBorder)

                Picker("Formato", selection: $codeType) {
                    ForEach(CodeType.allCases) { Text($0.rawValue).tag($0) }
                }
            }
        }
    }

    private var identityStep: some View {
        GlassCard(radius: 34) {
            VStack(spacing: 16) {
                HeroCardView(card: preview)
                TextField("Nome negozio o tessera", text: $title).textFieldStyle(.roundedBorder)
                TextField("Sottotitolo", text: $subtitle).textFieldStyle(.roundedBorder)
                Picker("Categoria", selection: $category) {
                    ForEach(CardCategory.allCases) { item in
                        Label(item.rawValue, systemImage: item.symbol).tag(item)
                    }
                }
            }
        }
    }

    private var styleStep: some View {
        GlassCard(radius: 34) {
            VStack(spacing: 16) {
                HeroCardView(card: preview)
                Text("Scegli lo stile").font(.headline)
                HStack(spacing: 12) {
                    ForEach(0..<CardlyUI.palettes.count, id: \.self) { i in
                        Button {
                            styleIndex = i
                        } label: {
                            Circle()
                                .fill(LinearGradient(colors: CardlyUI.palettes[i], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 46, height: 46)
                                .overlay {
                                    if styleIndex == i { Image(systemName: "checkmark").foregroundStyle(.white).font(.caption.bold()) }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                TextField("Note facoltative", text: $notes, axis: .vertical)
                    .lineLimit(3...5)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var preview: LoyaltyCard {
        LoyaltyCard(
            title: title.isEmpty ? "La tua tessera" : title,
            subtitle: subtitle,
            code: code.isEmpty ? "000000000000" : code,
            category: category,
            codeType: codeType,
            styleIndex: styleIndex
        )
    }

    private func save() {
        if var c = editingCard {
            c.title = title; c.subtitle = subtitle; c.code = code; c.category = category
            c.codeType = codeType; c.styleIndex = styleIndex; c.notes = notes
            store.update(c)
        } else {
            store.add(LoyaltyCard(title: title, subtitle: subtitle, code: code,
                                  category: category, codeType: codeType,
                                  styleIndex: styleIndex, notes: notes))
        }
        dismiss()
    }
}
