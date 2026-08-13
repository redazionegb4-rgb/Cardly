import SwiftUI

@main
struct CardlyApp: App {
    @StateObject private var store = CardStore()
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("lockEnabled") private var lockEnabled = false

    private var scheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            LockGateView(isEnabled: lockEnabled) {
                RootView()
                    .environmentObject(store)
            }
            .preferredColorScheme(scheme)
        }
    }
}
