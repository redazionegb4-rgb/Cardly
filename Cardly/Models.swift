import Foundation
import SwiftUI

enum CardCategory: String, CaseIterable, Codable, Identifiable {
    case supermercati = "Supermercati"
    case shopping = "Shopping"
    case ristoranti = "Ristoranti"
    case salute = "Salute"
    case sport = "Sport"
    case viaggi = "Viaggi"
    case servizi = "Servizi"
    case altro = "Altro"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .supermercati: return "cart.fill"
        case .shopping: return "bag.fill"
        case .ristoranti: return "fork.knife"
        case .salute: return "cross.case.fill"
        case .sport: return "figure.run"
        case .viaggi: return "airplane"
        case .servizi: return "sparkles"
        case .altro: return "square.grid.2x2.fill"
        }
    }
}

enum CodeKind: String, CaseIterable, Codable, Identifiable {
    case qr = "QR Code"
    case code128 = "Code 128"

    var id: String { rawValue }
}

struct LoyaltyCard: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var subtitle: String
    var number: String
    var category: CardCategory
    var codeKind: CodeKind
    var colorHex: String
    var isFavorite: Bool = false
    var notes: String = ""
    var createdAt: Date = Date()
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

extension LoyaltyCard {
    static let preview = LoyaltyCard(
        name: "Cardly Club",
        subtitle: "Carta fedeltà",
        number: "123456789012",
        category: .shopping,
        codeKind: .code128,
        colorHex: "0F5BFF",
        isFavorite: true
    )
}
