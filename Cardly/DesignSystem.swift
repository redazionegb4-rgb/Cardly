import SwiftUI

enum CardlyTheme {
    static let blue = Color(hex: "0F5BFF")
    static let cyan = Color(hex: "35C5FF")
    static let ink = Color(hex: "07111F")

    static let cardColors = [
        "0F5BFF", "00A6A6", "FF5C35", "7A5AF8",
        "D63B7A", "151A24", "2970FF", "12B76A"
    ]
}

struct CardlyBackground: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            Circle()
                .fill(CardlyTheme.blue.opacity(scheme == .dark ? 0.18 : 0.12))
                .frame(width: 340, height: 340)
                .blur(radius: 55)
                .offset(x: 150, y: -330)

            Circle()
                .fill(CardlyTheme.cyan.opacity(scheme == .dark ? 0.10 : 0.08))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -150, y: 360)
        }
        .ignoresSafeArea()
    }
}

struct GlassPanel<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(18)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 0.7)
            )
    }
}
