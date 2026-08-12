import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("appLock") private var appLock = false

    var body: some View {
        NavigationStack {
            ZStack {
                CardlyBackground()

                Form {
                    Section("Aspetto") {
                        Picker("Tema", selection: $appearance) {
                            Text("Automatico").tag("system")
                            Text("Chiaro").tag("light")
                            Text("Scuro").tag("dark")
                        }
                    }

                    Section("Privacy") {
                        Toggle(isOn: $appLock) {
                            Label("Proteggi con Face ID", systemImage: "faceid")
                        }
                    }

                    Section("Dati") {
                        LabeledContent("Salvataggio", value: "Locale sul dispositivo")
                        LabeledContent("Backup iCloud", value: "Prossima build")
                    }

                    Section("Informazioni") {
                        LabeledContent("Versione", value: "1.0")
                        LabeledContent("Build", value: "4")
                        Text("Cardly conserva carte fedeltà e tessere. Non gestisce carte di pagamento.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Impostazioni")
        }
    }
}
