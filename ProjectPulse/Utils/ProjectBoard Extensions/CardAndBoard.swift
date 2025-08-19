//
//  Extensions.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//

import Foundation

extension Card: NSItemProviderWriting{
    static let typeIdentifier = "com.ajsai.ProjectPulse.card"
    
    static var writableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, (any Error)?) -> Void) -> Progress? {
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }
}

extension Card : NSItemProviderReading{
    static var readableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}

extension BoardList: NSItemProviderWriting{
    static let typeIdentifier = "com.ajsai.ProjectPulse.broadlist"
    
    static var writableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, (any Error)?) -> Void) -> Progress? {
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            completionHandler(try encoder.encode(self), nil)
        } catch{
            completionHandler(nil,error)
        }
        return nil
    }
    func cardIndex(id: UUID) -> Int? {
        cards.firstIndex { $0.id == id }
    }
    
    func addNewCardWithContent(_ content: String) {
        cards = cards + [Card(boardListId: id, content: content)]
    }
    func removeCard(_ card: Card) {
        guard let cardIndex = cardIndex(id: card.id) else { return }
        cards.remove(at: cardIndex)
    }
    
    func moveCards(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        cards.move(fromOffsets: offsets, toOffset: offset)
    }
}
extension BoardList : NSItemProviderReading{
    static var readableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}


