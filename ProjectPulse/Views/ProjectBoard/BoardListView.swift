//
//  BoardListView.swift
//  Trello
//
//  Created by aj sai on 25/07/25.
//

import SwiftUI
import SwiftUIIntrospect

struct BoardListView: View {
    @ObservedObject var board: Board
    @ObservedObject var boardList: BoardList
    
    @State private var listHeight: CGFloat = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView
            
            listView
                .listStyle(.plain)
                .frame(maxHeight: listHeight > 0 ? listHeight : .infinity)
            
            Button("+ Add Card") {
                handleAddCard()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical)
        .background(boardListBackgroundColor)
        .frame(width: 300)
        .cornerRadius(8)
        .foregroundColor(.black)
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            Text(boardList.name)
                .font(.headline)
                .lineLimit(2)
            
            Spacer()
            Menu {
                Button("Rename") {
                    // TODO: Add rename logic
                }
                Button("Delete", role: .destructive) {
                    // TODO: Add delete logic
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
        }
        .padding(.horizontal)
    }
    
    private var listView: some View {
        List {
            ForEach(boardList.cards) { card in
                CardView(boardList: boardList, card: card)
                    .onDrag {
                        NSItemProvider(object: card)
                    }
            }
            .onInsert(of: [Card.typeIdentifier], perform: handleOnInsertCard)
            .onMove(perform: boardList.moveCards(fromOffsets:toOffset:))
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .listRowBackground(Color.clear)
        }
        .introspect(.list, on: .iOS(.v14, .v15)) { (tableView: UITableView) in
            DispatchQueue.main.async {
                    self.listHeight = tableView.contentSize.height
            }
        }
        .introspect(.list, on: .iOS(.v16, .v17, .v18)) { (collectionView: UICollectionView) in
            DispatchQueue.main.async {
                    self.listHeight = collectionView.contentSize.height
            }
        }
    }
    private func handleOnInsertCard(index: Int, itemProvider: [NSItemProvider]) {
        for itemProvider in itemProvider {
            itemProvider.loadObject(ofClass: Card.self) { item, _ in
                guard let card = item as? Card else { return }
                DispatchQueue.main.async {
                    board.move(card: card, to: boardList, at: index)
                }
            }
        }
        
    }
    private func handleAddCard() {
        presentAlertTextField(title: "Add a card to \(boardList.name)") { text in
            guard let text = text, !text.isEmpty else { return }
            boardList.addNewCardWithContent(text)
        }
    }
}

// MARK: - Preview

#Preview {
    let board = Board.stub
    BoardListView(board: board, boardList: board.lists[0])
        .frame(width: 300)
}
