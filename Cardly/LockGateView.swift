import SwiftUI
import LocalAuthentication

struct LockGateView<Content: View>: View {
    let isEnabled: Bool
    private let content: Content

    @State private var unlocked = false

    init(isEnabled: Bool, @ViewBuilder content: () -> Content) {
        self.isEnabled = isEnabled
        self.content = content()
    }

    var body: some View {
        Group {
            if !isEnabled || unlocked {
                content
            } else {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()

                    VStack(spacing: 18) {
                        Image(systemName: "faceid")
                            .font(.system(size: 52, weight: .medium))

                        Text("Cardly")
                            .font(.title2.bold())

                        Text("Sblocca l’app per accedere alle tue tessere.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button {
                            authenticate()
                        } label: {
                            Label("Sblocca con Face ID", systemImage: "faceid")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                    }
                    .padding(30)
                }
                .task {
                    authenticate()
                }
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        context.localizedCancelTitle = "Annulla"

        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            unlocked = true
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Sblocca Cardly"
        ) { success, _ in
            DispatchQueue.main.async {
                if success {
                    unlocked = true
                }
            }
        }
    }
}
