//
//  Card.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation

class Card: NSObject, ObservableObject, Identifiable, Codable {

    private(set) var id = UUID()
    var boardListId: UUID

    @Published var content: String
    @Published var priority: String
    @Published var taskType: String
    @Published var taskName: String
    @Published var clipLinks: [String] = []

    enum CodingKeys: String, CodingKey {
        case id, boardListId, content, priority, taskType, taskName, clipLinks
    }

    init(boardListId: UUID, content: String, priority: String = "", taskType: String = "", taskName: String = "", clipLinks: [String] = []) {
        self.boardListId = boardListId
        self.content = content
        self.priority = priority
        self.taskType = taskType
        self.taskName = taskName
        self.clipLinks = clipLinks
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardListId = try container.decode(UUID.self, forKey: .boardListId)
        self.content = try container.decode(String.self, forKey: .content)
        self.priority = try container.decode(String.self, forKey: .priority)
        self.taskType = try container.decode(String.self, forKey: .taskType)
        self.taskName = try container.decode(String.self, forKey: .taskName)
        self.clipLinks = try container.decodeIfPresent([String].self, forKey: .clipLinks) ?? []
        super.init()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(boardListId, forKey: .boardListId)
        try container.encode(content, forKey: .content)
        try container.encode(priority, forKey: .priority)
        try container.encode(taskType, forKey: .taskType)
        try container.encode(taskName, forKey: .taskName)
        try container.encode(clipLinks, forKey: .clipLinks)
    }
}
