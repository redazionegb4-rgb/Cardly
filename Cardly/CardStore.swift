import Foundation

@MainActor
final class CardStore: ObservableObject {
    @Published var cards: [LoyaltyCard] = [] { didSet { save() } }

    private let key = "cardly.v2.cards"

    init() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([LoyaltyCard].self, from: data) else { return }
        cards = decoded
    }

    func add(_ card: LoyaltyCard) { cards.insert(card, at: 0) }

    func update(_ card: LoyaltyCard) {
        guard let i = cards.firstIndex(where: { $0.id == card.id }) else { return }
        cards[i] = card
    }

    func delete(_ card: LoyaltyCard) { cards.removeAll { $0.id == card.id } }

    func toggleFavorite(_ card: LoyaltyCard) {
        guard let i = cards.firstIndex(where: { $0.id == card.id }) else { return }
        cards[i].favorite.toggle()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
