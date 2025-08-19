//
//  BoardView.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//


import SwiftUI

let boardListBackgroundColor = Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.94, alpha: 1))
let trelloBlueBackgroundColor = Color(uiColor: UIColor(red: 0.2, green: 0.47, blue: 0.73, alpha: 1))

struct BoardView: View {
    
    @StateObject private var board: Board = BoardDiskRepository().loadFromDisk() ?? Board.stub
    @State private var dragging: BoardList?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    Text(board.name)
                        .font(.title)
                        .bold()
                    Spacer()
                    Menu {
                        Button("High Priority") {
                            // Handle High Priority filter
                        }
                        Button("Low Priority") {
                            // Handle Low Priority filter
                        }
                        Button("Overdue") {
                            // Handle Overdue filter
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                    Button(action: {
                        // Handle notifications
                    }) {
                        Image(systemName: "bell")
                            .font(.title2)
                    }
                    Button(action: {
                        // Handle project details
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)

                ScrollView(.horizontal,showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 24) {
                        ForEach(board.lists) { boardList in
                            BoardListView(board: board, boardList: boardList)
                                .onDrag({
                                    self.dragging = boardList
                                    return NSItemProvider(object: boardList)
                                })
                                .onDrop(of: [Card.typeIdentifier, BoardList.typeIdentifier], delegate: BoardDropDelegate(board: board, boardList: boardList, lists: $board.lists, current: $dragging))
                        }
                        
                        Button("+ Add list") {
                            handleOnAddList()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(boardListBackgroundColor.opacity(0.8))
                        .frame(width: 300)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                    }
                    .padding()
                    .animation(.default, value: board.lists)
                }
                .background(Image("image").resizable().scaledToFill())
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationViewStyle(.stack)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            BoardDiskRepository().saveToDisk(board: board)
        }
    }
    
    private func handleOnAddList() {
        presentAlertTextField(title: "Add list") { text in
            guard let text = text, !text.isEmpty else {
                return
            }
            board.addNewBoardListWithName(text)
        }
    }
    
    private func handleRenameBoard() {
        presentAlertTextField(title: "Rename Board", defaultTextFieldText: board.name) { text in
            guard let text = text, !text.isEmpty else {
                return
            }
            board.name = text
        }
    }
    
}


#Preview {
    BoardView()
}
