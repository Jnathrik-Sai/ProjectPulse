//
//  Board.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation
import SwiftData

class Board : ObservableObject, Identifiable, Codable {
    
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

    // Convenience initializer to create a Board from a ProjectResponse
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
    
    func move(card: Card, to boardList: BoardList, at index: Int) {
        guard
            let sourceBoardListIndex = boardListIndex(id: card.boardListId),
            let destinationBoardListIndex = boardListIndex(id: boardList.id),
            sourceBoardListIndex != destinationBoardListIndex,
            let sourceCardIndex = cardIndex(id: card.id, boardIndex: sourceBoardListIndex)
        else {
            return
        }
        
        boardList.cards.insert(card, at: index)
        card.boardListId = boardList.id
        lists[sourceBoardListIndex].cards.remove(at: sourceCardIndex)
    }
    
    func addNewBoardListWithName(_ name: String) {
        lists.append(BoardList(boardId: id, name: name))
    }
    
    func removeBoardList(_ boardList: BoardList) {
        guard let index = boardListIndex(id: boardList.id) else { return }
        lists.remove(at: index)
    }
    
    private func cardIndex(id: UUID, boardIndex: Int) -> Int? {
        lists[boardIndex].cardIndex(id: id)
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        lists.firstIndex { $0.id == id }
    }
    func findBoardList(by id: UUID) -> BoardList? {
        lists.first(where: { $0.id == id })
    }
}
