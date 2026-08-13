import SwiftUI

struct OnboardingView: View {
    let complete: () -> Void
    @State private var page = 0

    var body: some View {
        ZStack {
            DynamicBackdrop()

            VStack(spacing: 28) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(.ultraThinMaterial)
                        .frame(width: 290, height: 190)
                        .rotationEffect(.degrees(page == 0 ? -7 : -3))
                        .offset(y: -16)

                    RoundedRectangle(cornerRadius: 34)
                        .fill(LinearGradient(colors: [.indigo, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 300, height: 200)
                        .rotationEffect(.degrees(page == 0 ? 6 : 3))
                        .overlay {
                            Image(systemName: page == 0 ? "wallet.pass.fill" : page == 1 ? "barcode.viewfinder" : "faceid")
                                .font(.system(size: 54, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: .indigo.opacity(0.3), radius: 28, y: 16)
                }

                VStack(spacing: 10) {
                    Text(title)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Capsule()
                            .fill(i == page ? CardlyUI.accent : Color.secondary.opacity(0.25))
                            .frame(width: i == page ? 30 : 8, height: 8)
                            .animation(.snappy, value: page)
                    }
                }

                Button {
                    if page < 2 {
                        withAnimation(.snappy) { page += 1 }
                    } else {
                        complete()
                    }
                } label: {
                    Text(page == 2 ? "Inizia" : "Continua")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(CardlyUI.accent)
                .padding(.horizontal, 28)

                Spacer()
            }
        }
    }

    private var title: String {
        ["Tutte le tue tessere.\nIn un solo gesto.",
         "Scansiona.\nSalva. Usa.",
         "Private.\nSolo tua."][page]
    }

    private var subtitle: String {
        ["Un wallet elegante per carte fedeltà, QR e barcode.",
         "Aggiungi una tessera in pochi secondi con la fotocamera.",
         "Proteggi Cardly con Face ID e tieni tutto sul tuo iPhone."][page]
    }
}
