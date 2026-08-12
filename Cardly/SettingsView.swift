import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("faceIDEnabled") private var faceIDEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Aspetto") {
                    Picker("Tema", selection: $appearance) {
                        Text("Automatico").tag("system")
                        Text("Chiaro").tag("light")
                        Text("Scuro").tag("dark")
                    }
                }

                Section("Privacy") {
                    Toggle(isOn: $faceIDEnabled) {
                        Label("Protezione Face ID", systemImage: "faceid")
                    }
                    Text("La protezione completa all'avvio verrà collegata nella prossima build.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Dati") {
                    LabeledContent("Salvataggio", value: "Sul dispositivo")
                    LabeledContent("iCloud", value: "In preparazione")
                }

                Section("Cardly") {
                    LabeledContent("Versione", value: "1.0 (Build 1)")
                    Text("Le tessere restano sul dispositivo. Cardly non gestisce carte di pagamento o dati bancari.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Impostazioni")
        }
    }
}
