//
//  Board+Stub.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation

extension Board {
    static var stub: Board {
        let board = Board(name: "Project Board")
        
        let backlogBoardList = BoardList(boardId: board.id, name: "Backlog")
        let backlogCards = [
            Card(boardListId: backlogBoardList.id, content: "Design Login Screen", priority: "Medium", taskType: "Design", taskName: "Login UI"),
            Card(boardListId: backlogBoardList.id, content: "Research API options", priority: "Low", taskType: "Research", taskName: "API Study"),
            Card(boardListId: backlogBoardList.id, content: "Setup CI/CD pipeline", priority: "High", taskType: "DevOps", taskName: "Automation"),
        ]
        backlogBoardList.cards = backlogCards
        
        let todoBoardList = BoardList(boardId: board.id, name: "To Do")
        let todoCards = [
            Card(boardListId: todoBoardList.id, content: "Fix crash on startup", priority: "High", taskType: "Bug", taskName: "Crash Fix"),
            Card(boardListId: todoBoardList.id, content: "Implement search feature", priority: "Medium", taskType: "Feature", taskName: "Search"),
        ]
        todoBoardList.cards = todoCards
        
        let inProgressBoardList = BoardList(boardId: board.id, name: "In Progress")
        let inProgressCards = [
            Card(boardListId: inProgressBoardList.id, content: "Create file storage service", priority: "High", taskType: "Backend", taskName: "File Storage"),
            Card(boardListId: inProgressBoardList.id, content: "Write unit tests", priority: "Medium", taskType: "Testing", taskName: "Unit Tests"),
        ]
        inProgressBoardList.cards = inProgressCards
        
        let doneBoardList = BoardList(boardId: board.id, name: "Done")
        let doneCards = [
            Card(boardListId: doneBoardList.id, content: "Setup project repo", priority: "High", taskType: "Setup", taskName: "Repo Setup"),
            Card(boardListId: doneBoardList.id, content: "Initial wireframes", priority: "Medium", taskType: "Design", taskName: "Wireframes"),
        ]
        doneBoardList.cards = doneCards
        
        board.lists = [
            backlogBoardList,
            todoBoardList,
            inProgressBoardList,
            doneBoardList
        ]
        return board
    }
}
