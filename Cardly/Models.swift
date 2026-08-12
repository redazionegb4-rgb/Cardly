import Foundation
import SwiftUI

enum CardCategory: String, CaseIterable, Codable, Identifiable {
    case supermercati = "Supermercati"
    case shopping = "Shopping"
    case ristoranti = "Ristoranti"
    case salute = "Salute"
    case sport = "Sport"
    case viaggi = "Viaggi"
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
        case .altro: return "square.grid.2x2.fill"
        }
    }
}

enum CodeKind: String, CaseIterable, Codable, Identifiable {
    case qr = "QR Code"
    case code128 = "Code 128"
    case ean13 = "EAN-13"

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
    var createdAt: Date = Date()
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r, g, b: UInt64
        if cleaned.count == 6 {
            r = (value >> 16) & 0xFF
            g = (value >> 8) & 0xFF
            b = value & 0xFF
        } else {
            r = 29; g = 78; b = 216
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: 1)
    }
}
