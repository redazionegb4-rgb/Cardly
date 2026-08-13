import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("lockEnabled") private var lockEnabled = false

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackground()

                Form {
                    Section("Aspetto") {
                        Picker("Tema", selection: $appearance) {
                            Text("Automatico").tag("system")
                            Text("Chiaro").tag("light")
                            Text("Scuro").tag("dark")
                        }
                    }

                    Section("Privacy") {
                        Toggle(isOn: $lockEnabled) {
                            Label("Proteggi con Face ID", systemImage: "faceid")
                        }
                    }

                    Section("Dati") {
                        LabeledContent("Salvataggio", value: "Sul dispositivo")
                        LabeledContent("Backup iCloud", value: "Prossima build")
                    }

                    Section("Cardly") {
                        LabeledContent("Versione", value: "1.0")
                        LabeledContent("Build", value: "9")
                        Text("Cardly conserva carte fedeltà e tessere. Non gestisce carte bancarie.")
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
