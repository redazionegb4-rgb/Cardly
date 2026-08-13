import SwiftUI

enum CardlyTheme {
    static let accent = Color(red: 0.02, green: 0.42, blue: 0.98)
    static let cardColors: [String] = [
        "111827", "0F5BFF", "0F766E", "7C3AED",
        "B42318", "A16207", "334155", "BE185D"
    ]
    static let gradients: [[Color]] = [
        [.black, Color(red: 0.10, green: 0.11, blue: 0.14)],
        [Color(red: 0.02, green: 0.36, blue: 0.95), Color(red: 0.02, green: 0.18, blue: 0.52)],
        [Color(red: 0.07, green: 0.50, blue: 0.38), Color(red: 0.03, green: 0.25, blue: 0.20)],
        [Color(red: 0.43, green: 0.27, blue: 0.91), Color(red: 0.22, green: 0.13, blue: 0.52)],
        [Color(red: 0.82, green: 0.24, blue: 0.20), Color(red: 0.48, green: 0.10, blue: 0.09)],
        [Color(red: 0.73, green: 0.52, blue: 0.16), Color(red: 0.44, green: 0.30, blue: 0.07)]
    ]
}

struct CardlyBackground: View {
    var body: some View { Color(.systemBackground).ignoresSafeArea() }
}

struct GlassPanel<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content.padding(18)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
