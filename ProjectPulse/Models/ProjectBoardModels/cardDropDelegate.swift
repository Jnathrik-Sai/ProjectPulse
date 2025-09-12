//
//  cardDropDelegate.swift
//  ProjectPulse
//
//  Created by aj sai on 09/09/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct CardDropDelegate: DropDelegate {
    let card: Card?
    let board: Board
    let boardList: BoardList

    func performDrop(info: DropInfo) -> Bool {
        let providers = info.itemProviders(for: [Card.typeIdentifier])
        for provider in providers {
            provider.loadObject(ofClass: Card.self) { item, _ in
                guard let draggedCard = item as? Card else { return }
                
                if let sourceList = board.findBoardList(by: draggedCard.boardListId),
                   let index = sourceList.cards.items.firstIndex(where: { $0.id == draggedCard.id }) {
                    sourceList.cards.items.remove(at: index)
                }

                draggedCard.boardListId = boardList.id
                if let targetCard = card,
                   let targetIndex = boardList.cards.items.firstIndex(where: { $0.id == targetCard.id }) {
                    boardList.cards.items.insert(draggedCard, at: targetIndex)
                } else {
                    boardList.cards.items.append(draggedCard)
                }
            }
        }
        return true
    }
}
