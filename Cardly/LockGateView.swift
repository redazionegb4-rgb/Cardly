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
                    DynamicBackdrop()

                    GlassCard(radius: 36) {
                        VStack(spacing: 18) {
                            Image(systemName: "faceid")
                                .font(.system(size: 50))
                                .foregroundStyle(CardlyUI.accent)
                            Text("Cardly è protetta").font(.title2.bold())
                            Text("Usa Face ID per entrare nel tuo wallet.")
                                .font(.subheadline).foregroundStyle(.secondary)
                            Button("Sblocca") { authenticate() }
                                .buttonStyle(.borderedProminent)
                                .tint(CardlyUI.accent)
                        }
                    }
                    .padding(28)
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

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Sblocca Cardly") { success, _ in
            DispatchQueue.main.async {
                if success { unlocked = true }
            }
        }
    }
}
