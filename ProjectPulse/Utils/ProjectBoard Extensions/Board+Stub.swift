//
//  Board+Stub.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation

extension Board{
    static var stub: Board{
        let board = Board(name: "Project Board")
        let backlogBoardList = BoardList(boardId: board.id, name: "Backlog")
        let backlogCards = [
            "CS",
            "JS",
            "PS",
        ].map{Card(boardListId: backlogBoardList.id, content: $0)}
        backlogBoardList.cards = backlogCards
        
        let todoBoardList = BoardList(boardId: board.id, name: "To Do")
        let todoCards = [
            "Error Handling",
            "Text Search"
        ].map {Card(boardListId: todoBoardList.id, content: $0)}
        todoBoardList.cards = todoCards
        let inProgressBoardList = BoardList(boardId: board.id, name: "In Progress")
        let inProgressCards: [Card] = ["File Storage Service"].map {
            Card(boardListId: inProgressBoardList.id, content: $0)}
        inProgressBoardList.cards = inProgressCards
        let doneBoardList = BoardList(boardId: board.id, name: "Done")
        board.lists = [
            backlogBoardList,
            todoBoardList,
            inProgressBoardList,
            doneBoardList
        ]
        return board
    }
}
