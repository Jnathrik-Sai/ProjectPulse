//
//  BoardViewModel.swift
//  ProjectPulse
//
//  Created by aj sai on 13/08/25.
//

import Foundation
import Combine
import SocketIO

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

    func connect() {
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            self?.isConnected = true
            print("Socket.IO connected")
            print("Socket status: \(self?.socket.status.rawValue ?? -1)")
        }
        socket.on(clientEvent: .disconnect) { [weak self] _, _ in
            self?.isConnected = false
            print("Socket.IO disconnected")
            print("isConnected state: \(String(describing: self?.isConnected))")
        }

        socket.on("boardUpdate") { [weak self] data, _ in
            if let dict = data.first as? [String: Any] {
                print("Received boardUpdate: \(dict)")
                if let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   let updatedBoard = try? JSONDecoder().decode(Board.self, from: jsonData) {
                    self?.board = updatedBoard
                }
            }
        }

        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
        isConnected = false
    }

    func sendUpdate(for board: Board) {
        if let data = try? JSONEncoder().encode(board),
           let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            print("Sending board update: \(jsonObject)")
            socket.emit("updateBoard", jsonObject)
        }
    }

    // MARK: - Local Change Handlers
    func addList(named name: String) {
        print("Adding list with name: \(name)")
        board?.addNewBoardListWithName(name)
        if let board = board {
            sendUpdate(for: board)
        }
    }

    func removeList(_ boardList: BoardList) {
        print("Removing list: \(boardList)")
        board?.removeBoardList(boardList)
        if let board = board {
            sendUpdate(for: board)
        }
    }

    func moveCard(_ card: Card, to boardList: BoardList, at index: Int) {
        print("Moving card: \(card) to list: \(boardList) at index: \(index)")
        board?.move(card: card, to: boardList, at: index)
        if let board = board {
            sendUpdate(for: board)
        }
    }

    func updateCard(_ card: Card, content: String? = nil, priority: String? = nil) {
        print("Updating card: \(card) with content: \(String(describing: content)), priority: \(String(describing: priority))")
        if let content = content { card.content = content }
        if let priority = priority { card.priority = priority }
        if let board = board {
            sendUpdate(for: board)
        }
    }
}
