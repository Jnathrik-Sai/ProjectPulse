//
//  BoardList.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation
import UIKit

class BoardList: NSObject, ObservableObject, Identifiable, Codable {
    
    private(set) var id = UUID()
    var boardId: UUID
    
    @Published var name: String = ""
    @Published var titleBackgroundColor: UIColor? = .green
    @Published var cards: CardList = CardList()   // wrapper

    enum CodingKeys: String, CodingKey {
        case id, boardId, name, cards, titleBackgroundColorHex
    }

    init(boardId: UUID, name: String, cards: [Card] = []) {
        self.boardId = boardId
        self.name = name
        self.cards = CardList(cards)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardId = try container.decode(UUID.self, forKey: .boardId)
        self.name = try container.decode(String.self, forKey: .name)
        let decodedCards = try container.decode([Card].self, forKey: .cards)
        self.cards = CardList(decodedCards)

        if let hex = try container.decodeIfPresent(String.self, forKey: .titleBackgroundColorHex) {
            self.titleBackgroundColor = UIColor(hex: hex)
        } else {
            self.titleBackgroundColor = .green
        }

        super.init()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(boardId, forKey: .boardId)
        try container.encode(name, forKey: .name)
        try container.encode(cards.items, forKey: .cards)
        try container.encode(titleBackgroundColor?.toHexString(), forKey: .titleBackgroundColorHex)
    }
}
