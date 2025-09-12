import SwiftUI
import BottomSheet

// MARK: - BoardListView
struct BoardListView: View {

    @ObservedObject var board: Board
    @ObservedObject var boardList: BoardList
    var viewModel: BoardViewModel
    var onRequestAddCard: (BoardList) -> Void

    var body: some View {
        VStack {
            headerView

            List {
                ForEach(boardList.cards.items) { card in
                    CardView(board: board, boardList: boardList, card: card)
                        .id(card.id)
                        .padding(.vertical, 4)
                        .onDrag {
                            NSItemProvider(object: card)
                        }
                        .onDrop(
                            of: [Card.typeIdentifier],
                            delegate: CardDropDelegate(card: card, board: board, boardList: boardList)
                        )
                }
                .onMove { indices, newOffset in
                    boardList.moveCards(fromOffsets: indices, toOffset: newOffset)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

                Section {
                    Button("+ Add card") { onRequestAddCard(boardList) }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onDrop(
                            of: [Card.typeIdentifier],
                            delegate: CardDropDelegate(card: nil, board: board, boardList: boardList)
                        )
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.vertical)
        .background(boardListBackgroundColor)
        .frame(width: 300)
        .cornerRadius(8)
        .foregroundColor(.black)
    }

    // MARK: Header
    private var headerView: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Text(boardList.name)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(boardList.titleBackgroundColor ?? .systemGreen).opacity(0.3))
                    )

                Text("\(boardList.cards.items.count)")
                    .font(.subheadline)
                    .frame(width: 24, height: 24)
                    .background(Circle().stroke(Color.blue, lineWidth: 1))

                Spacer()

                Button("+") { onRequestAddCard(boardList) }
                    .font(.title3)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                    .foregroundColor(Color.gray.opacity(0.9))
                    .buttonStyle(PlainButtonStyle())

                Menu {
                    Button("Rename") { handleRename() }
                    Button("Delete", role: .destructive) { /* TODO */ }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                        .foregroundColor(Color.gray.opacity(0.7))
                }
            }
            .padding(.horizontal)

            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 290, height: 1)
                .padding(.top, 4)
        }
    }

    // MARK: Rename
    private func handleRename() {
        presentAlertTextField(title: "Rename list", defaultTextFieldText: boardList.name) { text in
            guard let text = text, !text.isEmpty else { return }
            DispatchQueue.main.async { boardList.name = text }
        }
    }
}
