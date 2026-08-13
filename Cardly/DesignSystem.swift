import SwiftUI

enum CardlyUI {
    static let accent = Color(red: 0.33, green: 0.39, blue: 1.0)

    static let palettes: [[Color]] = [
        [.indigo, .cyan, .purple],
        [Color(red: 0.03, green: 0.45, blue: 0.50), .mint, .teal],
        [.pink, .orange, .purple],
        [Color(red: 0.06, green: 0.07, blue: 0.11), .gray, .blue],
        [.purple, .pink, .indigo],
        [.green, .yellow, .teal]
    ]
}

struct DynamicBackdrop: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                Color(scheme == .dark ? .black : .systemBackground)

                blob(.indigo, size: 420, x: sin(t/5)*80 + 140, y: cos(t/6)*70 - 310, opacity: 0.22)
                blob(.cyan, size: 360, x: cos(t/7)*90 - 150, y: sin(t/5)*110 - 20, opacity: 0.16)
                blob(.pink, size: 340, x: sin(t/8)*100 + 160, y: cos(t/7)*100 + 350, opacity: 0.13)
            }
            .ignoresSafeArea()
        }
    }

    private func blob(_ color: Color, size: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) -> some View {
        Circle()
            .fill(color.opacity(opacity))
            .frame(width: size, height: size)
            .blur(radius: 95)
            .offset(x: x, y: y)
    }
}

struct GlassCard<Content: View>: View {
    let radius: CGFloat
    let content: Content

    init(radius: CGFloat = 28, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [.white.opacity(0.45), .white.opacity(0.03)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 0.9
                    )
            }
            .shadow(color: .black.opacity(0.12), radius: 24, y: 10)
    }
}
