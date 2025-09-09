//
//  Extensions.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation

// MARK: - Card NSItemProvider
extension Card: NSItemProviderWriting {
    static let typeIdentifier = "com.ajsai.ProjectPulse.card"
    
    static var writableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    
    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
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
            encoder.outputFormatting = [.prettyPrinted]
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }

    // MARK: - Card Management
    func cardIndex(id: UUID) -> Int? {
        cards.items.firstIndex { $0.id == id }
    }
    
    func addNewCardWithContent(_ content: String) {
        cards.items.append(Card(boardListId: id, content: content))
        cards.items = cards.items // force UI refresh
    }
    
    func removeCard(_ card: Card) {
        guard let index = cardIndex(id: card.id) else { return }
        cards.items.remove(at: index)
        cards.items = cards.items // force UI refresh
    }
    
    func moveCards(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        cards.items.move(fromOffsets: offsets, toOffset: offset)
        cards.items = cards.items // force UI refresh
    }
}

extension BoardList: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
