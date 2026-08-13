import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("lockEnabled") private var lockEnabled = false
    @AppStorage("didOnboard") private var didOnboard = true

    @AppStorage("labsSmartSort") private var labsSmartSort = false
    @AppStorage("labsNearby") private var labsNearby = false
    @AppStorage("labsExperimentalUI") private var labsExperimentalUI = false

    var body: some View {
        NavigationStack {
            ZStack {
                DynamicBackdrop()

                ScrollView {
                    VStack(spacing: 18) {
                        header
                        appearanceCard
                        dataCard
                        labsCard
                        aboutCard
                    }
                    .padding(18)
                    .padding(.bottom, 28)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Impostazioni")
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                Text("Personalizza Cardly")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "slider.horizontal.3")
                .font(.title2)
                .frame(width: 46, height: 46)
                .background(.ultraThinMaterial, in: Circle())
        }
    }

    private var appearanceCard: some View {
        GlassCard {
            VStack(spacing: 16) {
                settingRow("Tema", "circle.lefthalf.filled") {
                    Picker("", selection: $appearance) {
                        Text("Auto").tag("system")
                        Text("Chiaro").tag("light")
                        Text("Scuro").tag("dark")
                    }
                    .labelsHidden()
                }

                Divider()

                settingRow("Protezione Face ID", "faceid") {
                    Toggle("", isOn: $lockEnabled)
                        .labelsHidden()
                }
            }
        }
    }

    private var dataCard: some View {
        GlassCard {
            VStack(spacing: 15) {
                infoRow("Backup iCloud", "icloud.fill", "In arrivo")
                Divider()
                infoRow("Salvataggio", "iphone", "Sul dispositivo")
                Divider()
                infoRow("Versione", "number", "2.0 (11)")
            }
        }
    }

    private var labsCard: some View {
        GlassCard(radius: 30) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [.indigo, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)

                        Image(systemName: "flask.fill")
                            .foregroundStyle(.white)
                            .font(.title3)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Cardly Labs")
                            .font(.title3.bold())

                        Text("Funzioni sperimentali")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("BETA")
                        .font(.caption2.bold())
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(CardlyUI.accent.opacity(0.14), in: Capsule())
                        .foregroundStyle(CardlyUI.accent)
                }

                Divider()

                labToggle(
                    title: "Smart sorting",
                    subtitle: "Prepara l'ordinamento intelligente delle tessere.",
                    icon: "wand.and.stars",
                    value: $labsSmartSort
                )

                Divider()

                labToggle(
                    title: "Suggerimenti per posizione",
                    subtitle: "Predisposizione per mostrare la tessera giusta vicino al negozio.",
                    icon: "location.fill",
                    value: $labsNearby
                )

                Divider()

                labToggle(
                    title: "UI sperimentale",
                    subtitle: "Abilita le future variazioni grafiche di Cardly.",
                    icon: "sparkles.rectangle.stack.fill",
                    value: $labsExperimentalUI
                )

                Divider()

                HStack {
                    Label("Widget", systemImage: "square.grid.2x2.fill")
                    Spacer()
                    Text("Prossimamente").foregroundStyle(.secondary)
                }

                HStack {
                    Label("Apple Watch", systemImage: "applewatch")
                    Spacer()
                    Text("Prossimamente").foregroundStyle(.secondary)
                }
            }
        }
    }

    private var aboutCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Cardly")
                    .font(.headline)

                Text("Wallet per carte fedeltà, QR e barcode. Nessuna carta bancaria o dato di pagamento.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button {
                    didOnboard = false
                } label: {
                    Label("Rivedi onboarding", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func settingRow<Accessory: View>(
        _ title: String,
        _ icon: String,
        @ViewBuilder accessory: () -> Accessory
    ) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            accessory()
        }
    }

    private func infoRow(_ title: String, _ icon: String, _ value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }

    private func labToggle(
        title: String,
        subtitle: String,
        icon: String,
        value: Binding<Bool>
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(CardlyUI.accent)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: value)
                .labelsHidden()
        }
    }
}
