import SwiftUI
import LocalAuthentication

struct LockGateView<Content: View>: View {
    let isEnabled: Bool
    @ViewBuilder let content: Content
    @State private var unlocked = false

    var body: some View {
        Group {
            if !isEnabled || unlocked {
                content
            } else {
                ZStack {
                    CardlyBackground()
                    VStack(spacing: 18) {
                        Image(systemName: "faceid")
                            .font(.system(size: 54))
                            .foregroundStyle(CardlyTheme.blue)
                        Text("Cardly è protetta")
                            .font(.title2.bold())
                        Button("Sblocca con Face ID") {
                            authenticate()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(CardlyTheme.blue)
                    }
                }
                .task { authenticate() }
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            unlocked = true
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Sblocca Cardly"
        ) { success, _ in
            DispatchQueue.main.async {
                unlocked = success
            }
        }
    }
}
