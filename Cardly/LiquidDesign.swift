import SwiftUI

enum LiquidDesign {
    static let accent = Color(red: 0.31, green: 0.42, blue: 1.00)

    static let cardPalettes: [[Color]] = [
        [Color(red: 0.22, green: 0.20, blue: 0.72), Color(red: 0.38, green: 0.72, blue: 1.00), Color(red: 0.55, green: 0.35, blue: 0.95)],
        [Color(red: 0.04, green: 0.45, blue: 0.55), Color(red: 0.15, green: 0.82, blue: 0.72), Color(red: 0.05, green: 0.30, blue: 0.48)],
        [Color(red: 0.92, green: 0.25, blue: 0.46), Color(red: 1.00, green: 0.48, blue: 0.28), Color(red: 0.66, green: 0.20, blue: 0.62)],
        [Color(red: 0.07, green: 0.09, blue: 0.16), Color(red: 0.25, green: 0.27, blue: 0.38), Color(red: 0.06, green: 0.35, blue: 0.56)],
        [Color(red: 0.50, green: 0.20, blue: 0.84), Color(red: 0.92, green: 0.32, blue: 0.76), Color(red: 0.35, green: 0.22, blue: 0.78)],
        [Color(red: 0.06, green: 0.50, blue: 0.30), Color(red: 0.54, green: 0.84, blue: 0.30), Color(red: 0.02, green: 0.32, blue: 0.30)]
    ]
}

struct AuroraBackground: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Color(scheme == .dark ? .black : .systemGroupedBackground)

            Circle()
                .fill(Color.indigo.opacity(scheme == .dark ? 0.32 : 0.19))
                .frame(width: 420, height: 420)
                .blur(radius: 90)
                .offset(x: 180, y: -300)

            Circle()
                .fill(Color.cyan.opacity(scheme == .dark ? 0.22 : 0.16))
                .frame(width: 360, height: 360)
                .blur(radius: 90)
                .offset(x: -170, y: -40)

            Circle()
                .fill(Color.pink.opacity(scheme == .dark ? 0.18 : 0.11))
                .frame(width: 340, height: 340)
                .blur(radius: 100)
                .offset(x: 170, y: 360)
        }
        .ignoresSafeArea()
    }
}

struct LiquidGlass<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content

    init(cornerRadius: CGFloat = 28, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.45), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
            }
            .shadow(color: .black.opacity(0.10), radius: 22, y: 10)
    }
}

struct GlowIcon: View {
    let symbol: String
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.24))
                .frame(width: 48, height: 48)
                .blur(radius: 1)
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(color.gradient, in: Circle())
        }
    }
}
