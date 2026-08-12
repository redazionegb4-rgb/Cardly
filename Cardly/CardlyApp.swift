import SwiftUI

@main
struct CardlyApp: App {
    @StateObject private var store = CardStore()
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("appLock") private var appLock = false

    var preferredScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            LockGateView(isEnabled: appLock) {
                RootView()
                    .environmentObject(store)
            }
            .preferredColorScheme(preferredScheme)
        }
    }
}
