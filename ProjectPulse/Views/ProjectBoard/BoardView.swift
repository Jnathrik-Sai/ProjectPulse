//
//  BoardView.swift
//  Trello
//
//  Created by aj sai on 24/07/25.
//


import SwiftUI
import BottomSheet

let boardListBackgroundColor = Color(.white)
let trelloBlueBackgroundColor = Color(uiColor: UIColor(red: 0.2, green: 0.47, blue: 0.73, alpha: 1))

struct BoardView: View {
    
    @StateObject private var viewModel = BoardViewModel(serverURL: ApiUrl.shared.baseURL)
    var project: ProjectResponse?
    @State private var dragging: BoardList?
    
    @State private var showingAddListSheet = false
    @State private var selectedDetent: BottomSheet.PresentationDetent = .medium
    @State private var newListName = ""
    @State private var newListColor = Color.green.opacity(0.2)
    
    @State private var showingAddCardSheet = false
    @State private var selectedListForCard: BoardList?
    @State private var newCardTitle = ""
    @State private var newCardPriority = ""
    @State private var newCardType = ""
    @State private var newCardPriorityColor = Color.red
    @State private var newCardTypeColor = Color.blue
    
    var body: some View {
        if let board = viewModel.board ?? (project != nil ? Board(project: project!) : nil) {
            NavigationView {
                VStack(spacing: 0) {
                    // Header
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

                    // Board lists
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 24) {
                            ForEach(board.lists) { boardList in
                                BoardListView(
                                    board: board,
                                    boardList: boardList,
                                    viewModel: viewModel,
                                    onRequestAddCard: { list in
                                        selectedListForCard = list
                                        newCardTitle = ""
                                        newCardPriority = ""
                                        newCardType = ""
                                        newCardPriorityColor = .red
                                        newCardTypeColor = .blue
                                        showingAddCardSheet = true
                                    }
                                )
                            }
                            
                            // Add list button
                            Button(action: {
                                newListName = ""
                                newListColor = Color.green.opacity(0.2)
                                showingAddListSheet = true
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
                .onAppear {
                    viewModel.connect()
                    if viewModel.board == nil, let project = project {
                        viewModel.board = Board(project: project)
                    }
                }
            }
            .navigationViewStyle(.stack)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                BoardDiskRepository().saveToDisk(board: board)
            }
            
            // MARK: Add List Sheet
            .sheetPlus(
                isPresented: $showingAddListSheet,
                header: {
                    HStack {
                        Text("Add List")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                },
                main: {
                    VStack(spacing: 20) {
                        TextField("List Name", text: $newListName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Title Background Color")
                            Spacer()
                            ColorPicker("", selection: $newListColor, supportsOpacity: false)
                                .labelsHidden()
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Button("Cancel") {
                                resetAddListForm()
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button("Add") {
                                let finalName = newListName.isEmpty ? "List Name" : newListName
                                if let board = viewModel.board {
                                    // Correct method: addList(named:)
                                    viewModel.addList(named: finalName)
                                    
                                    // Immediately set the list's title background color
                                    if let lastList = viewModel.board?.lists.last {
                                        lastList.titleBackgroundColor = UIColor(newListColor)
                                    }
                                }
                                resetAddListForm()
                            }
                            .foregroundColor(.blue)
                            .disabled(newListName.isEmpty)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .presentationDetentsPlus([.medium, .large], selection: $selectedDetent)
                    .presentationDragIndicatorPlus(.visible)
                }
            )
            
            // MARK: Add Card Sheet
            .sheetPlus(
                isPresented: $showingAddCardSheet,
                header: {
                    HStack {
                        Text("Add Card")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                },
                main: {
                    VStack(spacing: 20) {
                        TextField("Task Title", text: $newCardTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        TextField("Priority", text: $newCardPriority)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Priority Color")
                            Spacer()
                            ColorPicker("", selection: $newCardPriorityColor, supportsOpacity: false)
                                .labelsHidden()
                        }
                        .padding(.horizontal)
                        
                        TextField("Task Type", text: $newCardType)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Task Type Color")
                            Spacer()
                            ColorPicker("", selection: $newCardTypeColor, supportsOpacity: false)
                                .labelsHidden()
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Button("Cancel") {
                                showingAddCardSheet = false
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button("Add") {
                                if let board = viewModel.board, let list = selectedListForCard {
                                    let newCard = Card(
                                        boardListId: list.id,
                                        content: newCardTitle,
                                        priority: newCardPriority,
                                        taskType: newCardType,
                                        taskName: newCardTitle,
                                        priorityColor: CodableColor(UIColor(newCardPriorityColor)),
                                        taskTypeColor: CodableColor(UIColor(newCardTypeColor))
                                    )
                                    list.cards.items.append(newCard)
                                    viewModel.sendUpdate(for: board)
                                }
                                showingAddCardSheet = false
                            }
                            .foregroundColor(.blue)
                            .disabled(newCardTitle.isEmpty)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .presentationDetentsPlus([.medium, .large], selection: $selectedDetent)
                    .presentationDragIndicatorPlus(.visible)
                }
            )
        }
    }
    
    private func resetAddListForm() {
        newListName = ""
        newListColor = Color.green.opacity(0.2)
        showingAddListSheet = false
    }
}

#Preview {
    BoardView()
}
