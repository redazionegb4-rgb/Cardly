import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("lockEnabled") private var lockEnabled = false
    @AppStorage("didOnboard") private var didOnboard = true

    var body: some View {
        NavigationStack {
            ZStack {
                DynamicBackdrop()

                ScrollView {
                    VStack(spacing: 18) {
                        header

                        GlassCard {
                            VStack(spacing: 14) {
                                settingRow("Tema", "circle.lefthalf.filled") {
                                    Picker("", selection: $appearance) {
                                        Text("Auto").tag("system")
                                        Text("Chiaro").tag("light")
                                        Text("Scuro").tag("dark")
                                    }
                                    .labelsHidden()
                                }

                                Divider()

                                settingRow("Face ID", "faceid") {
                                    Toggle("", isOn: $lockEnabled).labelsHidden()
                                }
                            }
                        }

                        GlassCard {
                            VStack(spacing: 14) {
                                infoRow("Backup iCloud", "icloud.fill", "In arrivo")
                                Divider()
                                infoRow("Salvataggio", "iphone", "Sul dispositivo")
                                Divider()
                                infoRow("Versione", "number", "2.0 (10)")
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cardly Labs").font(.headline)
                                Text("Qui arriveranno widget, Apple Watch, smart sorting e riconoscimento automatico dei negozi.")
                                    .font(.subheadline).foregroundStyle(.secondary)

                                Button("Rivedi onboarding") {
                                    didOnboard = false
                                }
                                .buttonStyle(.bordered)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(18)
                    .padding(.bottom, 120)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Impostazioni").font(.system(size: 34, weight: .bold, design: .rounded))
                Text("Personalizza Cardly").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "slider.horizontal.3")
                .font(.title2)
                .frame(width: 46, height: 46)
                .background(.ultraThinMaterial, in: Circle())
        }
    }

    private func settingRow<Accessory: View>(_ title: String, _ icon: String, @ViewBuilder accessory: () -> Accessory) -> some View {
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
            Text(value).foregroundStyle(.secondary)
        }
    }
}
