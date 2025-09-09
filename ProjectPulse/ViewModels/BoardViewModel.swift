//
//  BoardViewModel.swift
//  ProjectPulse
//
//  Created by aj sai on 13/08/25.
//

//
//  BoardViewModel.swift
//  ProjectPulse
//

import Foundation
import Combine
import SocketIO
import UIKit

@MainActor
class BoardViewModel: ObservableObject {

    @Published var board: Board?
    @Published var isConnected: Bool = false

    private var manager: SocketManager!
    private var socket: SocketIOClient!

    init(serverURL: URL) {
        manager = SocketManager(socketURL: serverURL, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }

    // MARK: - Socket Connection

    func connect() {
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            self?.isConnected = true
            print("Socket.IO connected")
        }

        socket.on(clientEvent: .disconnect) { [weak self] _, _ in
            self?.isConnected = false
            print("Socket.IO disconnected")
        }

        socket.on("board:update") { [weak self] data, _ in
            guard let self = self else { return }
            guard let dict = data.first as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                  let incomingBoard = try? JSONDecoder().decode(Board.self, from: jsonData) else { return }

            if let existingBoard = self.board {
                existingBoard.merge(with: incomingBoard)
                self.board = existingBoard
            } else {
                self.board = incomingBoard
            }
            print("📥 Board updated from socket. Lists count: \(self.board?.lists.count ?? 0)")
        }

        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
        self.isConnected = false
    }

    func sendUpdate(for board: Board) {
        guard let data = try? JSONEncoder().encode(board),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }

        print("📤 Sending board update: \(jsonObject)")
        socket.emit("updateBoard", jsonObject)
    }

    // MARK: - List & Card Management

    func addList(named name: String) {
        guard let board = board else { return }
        let newList = BoardList(boardId: board.id, name: name)
        board.lists.append(newList)
        board.lists = board.lists  // force UI refresh
        sendUpdate(for: board)
        print("Added new list: \(name)")
    }

    func removeList(_ list: BoardList) {
        guard let board = board else { return }
        board.lists.removeAll { $0.id == list.id }
        board.lists = board.lists
        sendUpdate(for: board)
        print("Removed list: \(list.name)")
    }

    func addCard(to list: BoardList,
                 content: String,
                 priority: String = "",
                 taskType: String = "",
                 taskName: String = "",
                 priorityColor: CodableColor? = nil,
                 taskTypeColor: CodableColor? = nil) {
        let newCard = Card(
            boardListId: list.id,
            content: content,
            priority: priority,
            taskType: taskType,
            taskName: taskName,
            priorityColor: priorityColor ?? CodableColor(.systemRed),
            taskTypeColor: taskTypeColor ?? CodableColor(.systemBlue)
        )
        list.cards.items.append(newCard)
        list.cards.items = list.cards.items  // force UI refresh
        if let board = self.board { sendUpdate(for: board) }
        print("Added new card: \(content) to list: \(list.name)")
    }

    func moveCard(_ card: Card, to list: BoardList, at index: Int) {
        if let currentList = board?.lists.first(where: { $0.id == card.boardListId }) {
            currentList.cards.items.removeAll { $0.id == card.id }
            currentList.cards.items = currentList.cards.items
        }
        list.cards.items.insert(card, at: index)
        list.cards.items = list.cards.items
        card.boardListId = list.id
        if let board = self.board { sendUpdate(for: board) }
        print("Moved card: \(card.content) to list: \(list.name) at index: \(index)")
    }

    func updateCard(_ card: Card,
                    content: String? = nil,
                    priority: String? = nil,
                    taskType: String? = nil,
                    taskName: String? = nil,
                    priorityColor: CodableColor? = nil,
                    taskTypeColor: CodableColor? = nil) {
        if let content = content { card.content = content }
        if let priority = priority { card.priority = priority }
        if let taskType = taskType { card.taskType = taskType }
        if let taskName = taskName { card.taskName = taskName }
        if let priorityColor = priorityColor { card.priorityColor = priorityColor }
        if let taskTypeColor = taskTypeColor { card.taskTypeColor = taskTypeColor }

        if let board = self.board { sendUpdate(for: board) }
        print("Updated card: \(card.content)")
    }
}

// MARK: - Merge Extensions

extension Board {
    func merge(with other: Board) {
        guard self.id == other.id else { return }
        for otherList in other.lists {
            if let existingList = self.lists.first(where: { $0.id == otherList.id }) {
                existingList.merge(with: otherList)
            } else {
                self.lists.append(otherList)
            }
        }
        self.name = other.name
        self.lists = self.lists
    }
}

extension BoardList {
    func merge(with other: BoardList) {
        for otherCard in other.cards.items {
            if let existingCard = self.cards.items.first(where: { $0.id == otherCard.id }) {
                existingCard.merge(with: otherCard)
            } else {
                self.cards.items.append(otherCard)
            }
        }
        self.name = other.name
        self.titleBackgroundColor = other.titleBackgroundColor
        self.cards.items = self.cards.items
    }
}

extension Card {
    func merge(with other: Card) {
        guard self.id == other.id else { return }
        self.content = other.content
        self.priority = other.priority
        self.taskType = other.taskType
        self.taskName = other.taskName
        self.priorityColor = other.priorityColor
        self.taskTypeColor = other.taskTypeColor
    }
}
