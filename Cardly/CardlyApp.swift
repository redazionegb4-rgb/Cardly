import SwiftUI

@main
struct CardlyApp: App {
    @StateObject private var store = CardStore()
    @AppStorage("appearance") private var appearance = "system"

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(
                    appearance == "dark" ? .dark :
                    appearance == "light" ? .light : nil
                )
        }
    }
}
