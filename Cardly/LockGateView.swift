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
                    AuroraBackground()

                    LiquidGlass(cornerRadius: 36) {
                        VStack(spacing: 18) {
                            ZStack {
                                Circle()
                                    .fill(LiquidDesign.accent.opacity(0.20))
                                    .frame(width: 86, height: 86)
                                Image(systemName: "faceid")
                                    .font(.system(size: 44, weight: .medium))
                                    .foregroundStyle(LiquidDesign.accent)
                            }

                            Text("Cardly è protetta")
                                .font(.title2.bold())

                            Text("Usa Face ID per accedere alle tue tessere.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button {
                                authenticate()
                            } label: {
                                Label("Sblocca", systemImage: "faceid")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(LiquidDesign.accent)
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
        context.localizedCancelTitle = "Annulla"
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
                if success { unlocked = true }
            }
        }
    }
}
