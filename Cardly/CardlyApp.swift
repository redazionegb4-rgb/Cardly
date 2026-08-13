import SwiftUI

@main
struct CardlyApp: App {
    @StateObject private var store = CardStore()
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("lockEnabled") private var lockEnabled = false
    @AppStorage("didOnboard") private var didOnboard = false

    private var scheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if didOnboard {
                    LockGateView(isEnabled: lockEnabled) {
                        MainShell()
                            .environmentObject(store)
                    }
                } else {
                    OnboardingView {
                        didOnboard = true
                    }
                }
            }
            .preferredColorScheme(scheme)
        }
    }
}
