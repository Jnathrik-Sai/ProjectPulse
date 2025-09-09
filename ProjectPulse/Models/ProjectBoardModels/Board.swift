//
//  Board.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation
import SwiftData

class Board: ObservableObject, Identifiable, Codable {
    
    private(set) var id = UUID()
    @Published var name: String
    @Published var lists: [BoardList]
    
    enum CodingKeys: String, CodingKey {
        case id, name, lists
    }
    
    init(name: String, lists: [BoardList] = []) {
        self.name = name
        self.lists = lists
    }

    convenience init(project: ProjectResponse) {
        self.init(name: project.name, lists: [])
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.lists = try container.decode([BoardList].self, forKey: .lists)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(lists, forKey: .lists)
    }
    
    // MARK: - Card Movement
    func move(card: Card, to destinationList: BoardList, at index: Int) {
        guard
            let sourceBoardListIndex = boardListIndex(id: card.boardListId),
            let destinationBoardListIndex = boardListIndex(id: destinationList.id),
            sourceBoardListIndex != destinationBoardListIndex,
            let sourceCardIndex = cardIndex(id: card.id, boardIndex: sourceBoardListIndex)
        else { return }
        
        // Insert into destination list
        destinationList.cards.items.insert(card, at: index)
        card.boardListId = destinationList.id
        
        // Remove from source list
        lists[sourceBoardListIndex].cards.items.remove(at: sourceCardIndex)
    }
    
    // MARK: - List Management
    func addNewBoardListWithName(_ name: String) {
        lists.append(BoardList(boardId: id, name: name))
    }
    
    func removeBoardList(_ boardList: BoardList) {
        guard let index = boardListIndex(id: boardList.id) else { return }
        lists.remove(at: index)
    }
    
    // MARK: - Helpers
    private func cardIndex(id: UUID, boardIndex: Int) -> Int? {
        lists[boardIndex].cards.items.firstIndex { $0.id == id }
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        lists.firstIndex { $0.id == id }
    }
    
    func findBoardList(by id: UUID) -> BoardList? {
        lists.first(where: { $0.id == id })
    }
}
