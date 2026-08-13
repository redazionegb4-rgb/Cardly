import SwiftUI
import Foundation

enum CardCategory: String, Codable, CaseIterable, Identifiable {
    case shopping = "Shopping"
    case supermercati = "Supermercati"
    case ristoranti = "Ristoranti"
    case salute = "Salute"
    case sport = "Sport"
    case viaggi = "Viaggi"
    case servizi = "Servizi"
    case altro = "Altro"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .shopping: return "bag.fill"
        case .supermercati: return "cart.fill"
        case .ristoranti: return "fork.knife"
        case .salute: return "cross.case.fill"
        case .sport: return "figure.run"
        case .viaggi: return "airplane"
        case .servizi: return "sparkles"
        case .altro: return "square.grid.2x2.fill"
        }
    }
}

enum CodeType: String, Codable, CaseIterable, Identifiable {
    case barcode = "Barcode"
    case qr = "QR Code"
    var id: String { rawValue }
}

struct LoyaltyCard: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var subtitle: String
    var code: String
    var category: CardCategory
    var codeType: CodeType
    var styleIndex: Int
    var favorite: Bool = false
    var notes: String = ""
    var createdAt = Date()
}
