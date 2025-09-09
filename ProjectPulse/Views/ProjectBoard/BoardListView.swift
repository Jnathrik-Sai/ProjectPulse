import SwiftUI
import SwiftUIIntrospect
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
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(boardList.cards.items) { card in
                        CardView(board: board, boardList: boardList, card: card)
                            .id(card.id)
                            .padding(.horizontal, 8)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.white).shadow(radius: 1))
                    }
                    
                    Button("+ Add card") { onRequestAddCard(boardList) }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.2)))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical)
        .background(boardListBackgroundColor)
        .frame(width: 300)
        .cornerRadius(8)
        .foregroundColor(.black)
    }

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

    private func handleRename() {
        presentAlertTextField(title: "Rename list", defaultTextFieldText: boardList.name) { text in
            guard let text = text, !text.isEmpty else { return }
            DispatchQueue.main.async { boardList.name = text }
        }
    }
}
