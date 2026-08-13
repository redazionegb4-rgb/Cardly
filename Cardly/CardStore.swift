import Foundation

@MainActor
final class CardStore: ObservableObject {
    @Published var cards: [LoyaltyCard] = [] { didSet { save() } }
    private let key = "cardly.liquidprism.cards"

    init() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([LoyaltyCard].self, from: data) else { return }
        cards = saved
    }

    func add(_ card: LoyaltyCard) { cards.insert(card, at: 0) }

    func update(_ card: LoyaltyCard) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        cards[index] = card
    }

    func delete(_ card: LoyaltyCard) {
        cards.removeAll { $0.id == card.id }
    }

    func toggleFavorite(_ card: LoyaltyCard) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        cards[index].favorite.toggle()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
