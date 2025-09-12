//
//  Extensions.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation
import UIKit

// MARK: - Card NSItemProvider
extension Card: NSItemProviderWriting {
    static let typeIdentifier = "com.ajsai.ProjectPulse.card"
    static var writableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }

    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let encoder = JSONEncoder()
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }
}

extension Card: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}

// MARK: - BoardList NSItemProvider
extension BoardList: NSItemProviderWriting {
    static let typeIdentifier = "com.ajsai.ProjectPulse.boardlist"
    static var writableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }

    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let encoder = JSONEncoder()
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }

    // Card management helpers (kept on model)
    func cardIndex(id: UUID) -> Int? {
        cards.items.firstIndex { $0.id == id }
    }
    
    func addNewCardWithContent(_ content: String) {
        cards.items.append(Card(boardListId: id, content: content))
    }
    
    func removeCard(_ card: Card) {
        guard let index = cardIndex(id: card.id) else { return }
        cards.items.remove(at: index)
    }
    
    func moveCards(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        cards.items.move(fromOffsets: offsets, toOffset: offset)
    }
}

extension BoardList: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}

// MARK: - UIColor helpers
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x0000FF)/255.0,
            alpha: 1.0
        )
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06X", rgb)
    }
}
