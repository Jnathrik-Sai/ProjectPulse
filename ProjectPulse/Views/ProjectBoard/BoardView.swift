//
//  BoardView.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//


import SwiftUI

let boardListBackgroundColor = Color(.white)
let trelloBlueBackgroundColor = Color(uiColor: UIColor(red: 0.2, green: 0.47, blue: 0.73, alpha: 1))

struct BoardView: View {
    
    @StateObject private var viewModel = BoardViewModel(serverURL: ApiUrl.shared.baseURL)
    var project: ProjectResponse?
    
    var body: some View {
        let board = project != nil ? Board(project: project!) : viewModel.board
        if let board = board {
            NavigationView {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                        }
                        Text(project?.name ?? board.name)
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.green.opacity(0.2))
                            )
                        Spacer()
                        Menu {
                            Button("High Priority") {}
                            Button("Low Priority") {}
                            Button("Overdue") {}
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                        }
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.title2)
                        }
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.title2)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 24) {
                            ForEach(board.lists) { boardList in
                                BoardListView(board: board, boardList: boardList)
                            }
                            
                            Button(action: {
                                handleOnAddList()
                            }) {
                                Text("+ Add list")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                            .foregroundColor(.gray)
                                    )
                            }
                            .frame(width: 300)
                        }
                        .padding()
                    }
                    .background(Image("image").resizable().scaledToFill())
                    .edgesIgnoringSafeArea(.bottom)
                }
                .onAppear { viewModel.connect() }
            }
            .navigationViewStyle(.stack)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                BoardDiskRepository().saveToDisk(board: board)
            }
        }
    }
    
    private func handleOnAddList() {
        presentAlertTextField(title: "Add list") { text in
            guard let text = text, !text.isEmpty else {
                return
            }
            viewModel.addList(named: text)
        }
    }
}

#Preview {
    BoardView()
}
