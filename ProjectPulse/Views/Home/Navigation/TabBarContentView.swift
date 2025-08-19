//
//  ContentView.swift
//  ProjectManager
//
//  Created by aj sai on 16/07/25.
//

import SwiftUI

let backgroundColor = Color(white: 0.92)

struct TabBarContentView: View {
    @State private var showCreateBoardSheet = false
    @State private var selectedTab: Tab = .home
    @State private var isTabBarHidden: Bool = false
    
    @State private var showMenu: Bool = false
    
    @State private var boardTitle: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var priority: Double = 3
    @State private var boardType: String = "Personal"
    @State private var invitedEmails: String = ""
    
    @StateObject private var viewModel = BoardFormViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(showMenu: $showMenu, isTabBarHidden: $isTabBarHidden)
                    case .projects:
                        Text("2nd Tab")
                    case .activity:
                        Text("3rd Tab")
                    case .profile:
                        Text("4th Tab")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor.ignoresSafeArea())
                
                if !isTabBarHidden {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showCreateBoardSheet = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Circle().fill(Color.blue))

                                Text("Create Project")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(Color.white)
                            )
                            .shadow(radius: 8)
                        }
                        .padding(.trailing, 20)
                        .offset(y: selectedTab == .home ? -80 : -50)
                        .scaleEffect(selectedTab == .home ? 1 : 0.1)
                        .animation(.easeInOut(duration: 0.40), value: selectedTab)
                    }
                    TabBarView3(selectedTab: $selectedTab)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.horizontal)
                        .animation(.easeInOut(duration: 0.3), value: isTabBarHidden)
                }
            }
            .sheet(isPresented: $showCreateBoardSheet) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Text("Create Kanban Board")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: {
                            showCreateBoardSheet = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)

                    TextField("Board Title", text: $boardTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)

                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)

                    VStack(alignment: .leading) {
                        Text("Priority")
                        VStack {
                            Slider(value: $priority, in: 1...5, step: 1)
                            HStack {
                                ForEach(1..<6) { _ in
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 1, height: 10)
                                    Spacer()
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Board Type")
                        Picker("Board Type", selection: $boardType) {
                            Text("Personal").tag("Personal")
                            Text("Public").tag("Public")
                            Text("Group").tag("Group")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    if boardType != "Personal" {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Invite Members (emails)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextField("Enter comma-separated emails", text: $invitedEmails)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: boardType)
                    }

                    Spacer()

                    Button(action: {
                        let newBoard = BoardRequest(
                            name: boardTitle,
                            description: "",
                            workspaceId: "defaultWorkspace", // replace with actual workspace selection if available
                            visibility: boardType.lowercased(), // map "Personal", "Public", "Group" appropriately
                            background: "default",
                            startDate: startDate,
                            dueDate: endDate,
                            invitedEmails: boardType != "Personal" ? invitedEmails
                                .split(separator: ",")
                                .map { $0.trimmingCharacters(in: .whitespaces) } : nil
                        )
                        viewModel.submitBoard(newBoard)
                    }) {
                        Text("Create")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .edgesIgnoringSafeArea(.bottom)
                )
                .interactiveDismissDisabled()
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onChange(of: viewModel.shouldNavigateToKanban) { newValue, _ in
                    if newValue {
                        showCreateBoardSheet = false
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToKanban) {
                if let project = viewModel.currentProject {
                    BoardView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContentView()
    }
}
