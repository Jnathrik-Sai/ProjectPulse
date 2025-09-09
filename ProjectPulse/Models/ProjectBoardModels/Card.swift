//
//  Card.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

struct CodableColor: Codable, Equatable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

#if canImport(UIKit)
    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    init(_ color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
    }
#endif
#if canImport(SwiftUI)
    var color: Color {
        Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
    init(_ color: Color) {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        self.init(uiColor)
        #else
        self.red = 0
        self.green = 0
        self.blue = 0
        self.alpha = 1
        #endif
    }
#endif
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    static var redColor: CodableColor {
        CodableColor(red: 1, green: 0, blue: 0, alpha: 1)
    }
    static var blueColor: CodableColor {
        CodableColor(red: 0, green: 0, blue: 1, alpha: 1)
    }
}

class Card: NSObject, ObservableObject, Identifiable, Codable {

    private(set) var id = UUID()
    var boardListId: UUID

    @Published var content: String
    @Published var priority: String
    @Published var taskType: String
    @Published var taskName: String
    @Published var clipLinks: [String] = []
    @Published var priorityColor: CodableColor? = CodableColor.redColor
    @Published var taskTypeColor: CodableColor? = CodableColor.blueColor

    enum CodingKeys: String, CodingKey {
        case id, boardListId, content, priority, taskType, taskName, clipLinks, priorityColor, taskTypeColor
    }

    init(
        boardListId: UUID,
        content: String,
        priority: String = "",
        taskType: String = "",
        taskName: String = "",
        clipLinks: [String] = [],
        priorityColor: CodableColor? = CodableColor.redColor,
        taskTypeColor: CodableColor? = CodableColor.blueColor
    ) {
        self.boardListId = boardListId
        self.content = content
        self.priority = priority
        self.taskType = taskType
        self.taskName = taskName
        self.clipLinks = clipLinks
        self.priorityColor = priorityColor
        self.taskTypeColor = taskTypeColor
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
        self.priorityColor = try container.decodeIfPresent(CodableColor.self, forKey: .priorityColor) ?? CodableColor.redColor
        self.taskTypeColor = try container.decodeIfPresent(CodableColor.self, forKey: .taskTypeColor) ?? CodableColor.blueColor
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
        try container.encode(priorityColor, forKey: .priorityColor)
        try container.encode(taskTypeColor, forKey: .taskTypeColor)
    }
}
