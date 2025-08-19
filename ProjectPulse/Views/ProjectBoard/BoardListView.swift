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
    // Track the currently dragging card and the source list id
    @State private var draggingCard: Card? = nil
    @State private var draggingFromListId: UUID? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView

            listView

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
        VStack(spacing: 4) {
            HStack(alignment: .center, spacing: 12) {
                Text(boardList.name)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green.opacity(0.2))
                    )

                Text("\(boardList.cards.count)")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .background(Circle().stroke(Color.blue, lineWidth: 1))

                Spacer()
                Button(action: {
                    handleAddCard()
                }) {
                    Text("+")
                        .font(.title3)
                        .foregroundColor(Color.gray.opacity(0.9))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
                .buttonStyle(PlainButtonStyle())
                Menu {
                    Button("Rename") {
                        // TODO: Add rename logic
                    }
                    Button("Delete", role: .destructive) {
                        // TODO: Add delete logic
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.headline)
                        .foregroundColor(Color.gray.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
            }
            .padding(.horizontal)

            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 290, height: 1)
                .edgesIgnoringSafeArea(.horizontal)
                .padding(.top, 4)
        }
    }

    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(boardList.cards) { card in
                    CardView(board: board, boardList: boardList, card: card)
                        .onDrag {
                            draggingCard = card
                            draggingFromListId = boardList.id
                            return NSItemProvider(object: card)
                        }
                        .onDrop(of: [Card.typeIdentifier], delegate: CardDropDelegate(
                            targetCard: card,
                            board: board,
                            targetList: boardList,
                            draggingCard: $draggingCard,
                            draggingFromListId: $draggingFromListId
                        ))
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 12)
            .padding(.horizontal, 8)
            .onDrop(of: [Card.typeIdentifier], isTargeted: nil) { providers -> Bool in
                guard let dragging = draggingCard else {
                    if let provider = providers.first {
                        provider.loadObject(ofClass: Card.self) { (obj, error) in
                            guard let dropped = obj as? Card else { return }
                            DispatchQueue.main.async {
                                if let sourceId = draggingFromListId,
                                   let sourceList = board.lists.first(where: { $0.id == sourceId }),
                                   let fromIndex = sourceList.cardIndex(id: dropped.id) {
                                    let movedCard = sourceList.cards.remove(at: fromIndex)
                                    boardList.cards.append(movedCard)
                                } else {
                                    boardList.cards.append(dropped)
                                }
                            }
                        }
                        return true
                    }
                    return false
                }

                if let sourceId = draggingFromListId,
                   let sourceList = board.lists.first(where: { $0.id == sourceId }),
                   let fromIndex = sourceList.cardIndex(id: dragging.id) {

                    let moved = sourceList.cards.remove(at: fromIndex)

                    // if dropping into the same list, appending will effectively move it to the end
                    boardList.cards.append(moved)
                }

                // clear local drag tracking
                draggingCard = nil
                draggingFromListId = nil
                return true
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { listHeight = geo.size.height }
                        .onChange(of: geo.size.height, initial: true) { _, newHeight in
                            withAnimation(.easeInOut) { listHeight = newHeight }
                        }
                }
            )
        }
        .frame(maxHeight: listHeight > 0 ? listHeight : .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.95))
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 8)
    }
    private func HandleONInsert(index:Int, itemProviders: [NSItemProvider]) {
        for itemProvider in itemProviders{
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

// MARK: - Drop Delegate

private struct CardDropDelegate: DropDelegate {
    let targetCard: Card?
    let board: Board
    let targetList: BoardList

    @Binding var draggingCard: Card?
    @Binding var draggingFromListId: UUID?

    func dropEntered(info: DropInfo) {
        guard let dragging = draggingCard else { return }

        guard let sourceId = draggingFromListId,
              let sourceList = board.lists.first(where: { $0.id == sourceId }),
              let fromIndex = sourceList.cardIndex(id: dragging.id) else { return }

        let toIndex: Int
        if let target = targetCard, let idx = targetList.cardIndex(id: target.id) {
            toIndex = idx
        } else {
            toIndex = targetList.cards.count
        }
        if sourceList.id == targetList.id {
            if fromIndex != toIndex {                var dest = toIndex
                if fromIndex < toIndex { dest += 1 }
                withAnimation {
                    targetList.cards.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: dest)
                }
            }
        } else {
            if sourceList.cardIndex(id: dragging.id) != nil {
                withAnimation {
                    let moved = sourceList.cards.remove(at: fromIndex)
                    let insertIndex = min(max(0, toIndex), targetList.cards.count)
                    targetList.cards.insert(moved, at: insertIndex)
                    draggingFromListId = targetList.id
                }
            }
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        if draggingCard == nil {
            let providers = info.itemProviders(for: [Card.typeIdentifier])
            guard let provider = providers.first else { return false }
            var handled = false
            provider.loadObject(ofClass: Card.self) { (obj, error) in
                guard let dropped = obj as? Card else { return }
                DispatchQueue.main.async {
                    if let source = board.lists.first(where: { $0.cardIndex(id: dropped.id) != nil }),
                       let fromIndex = source.cardIndex(id: dropped.id) {
                        let moved = source.cards.remove(at: fromIndex)
                        targetList.cards.append(moved)
                    } else {
                        targetList.cards.append(dropped)
                    }
                    handled = true
                }
            }
            draggingCard = nil
            draggingFromListId = nil
            return handled
        }

        draggingCard = nil
        draggingFromListId = nil
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

// MARK: - Preview

#Preview {
    let board = Board.stub
    BoardListView(board: board, boardList: board.lists[0])
        .frame(width: 300)
}
