//
//  ContentView.swift
//  ProjectPulse
//
//  Created by aj sai on 18/07/25.
//

import SwiftUI
import SwiftData

struct NavContentView: View {
    enum Destination: Hashable {
        case board(ProjectResponse?)
    }

    @State private var path = NavigationPath()
    @State private var isMenuExp: Bool = false
    @State private var selectedTab: Tab = .home
    @State private var isTabBarHidden: Bool = false
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @State private var showCreateBoardSheet = false
    @State private var boardTitle: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var priority: Double = 3
    @State private var boardType: String = "Personal"
    @State private var invitedEmails: String = ""
    @StateObject private var viewModel = BoardFormViewModel()

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        let sideBarWidth = getRect().width - 90

        NavigationStack(path: $path) {
            HStack(spacing: 0) {
                MenuBar(isMenuExpanded: $isMenuExp)

                ZStack(alignment: .bottom) {
                    Group {
                        switch selectedTab {
                        case .home:
                            HomeView(showMenu: $isMenuExp, isTabBarHidden: $isTabBarHidden)
                        case .projects:
                            Text("Projects")
                        case .activity:
                            Text("Activity")
                        case .profile:
                            Text("Profile")
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
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(Color.blue))

                                    Text("Create Board")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color.white))
                                .shadow(radius: 8)
                            }
                            .padding(.trailing, 20)
                            .offset(y: selectedTab == .home ? -80 : -50)
                            .scaleEffect(selectedTab == .home ? 1 : 0.1)
                            .animation(.easeInOut(duration: 0.4), value: selectedTab)
                        }

                        TabBarView3(selectedTab: $selectedTab)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                            .animation(.easeInOut(duration: 0.3), value: isTabBarHidden)
                    }
                }
                .frame(width: getRect().width)
            }
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .board(let project):
                    BoardView(project: project)
                        .onAppear {
                            print("DEBUG: Navigated to BoardView with project: \(String(describing: project))")
                        }
                }
            }
        }
        .sheet(isPresented: $showCreateBoardSheet) {
            NavigationStack {
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
                        Slider(value: $priority, in: 1...5, step: 1)
                        HStack {
                            ForEach(1...5, id: \.self) { number in
                                Text("\(number)")
                                    .font(.caption)
                                    .foregroundColor(number == Int(priority.rounded()) ? .blue : .gray)
                                if number != 5 {
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 4)
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
                        TextField("Invited Emails (comma separated)", text: $invitedEmails)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    Spacer()

                    Button(action: {
                        let board = BoardRequest(
                            name: boardTitle,
                            description: "",
                            workspaceId: "defaultWorkspace", // replace with actual workspace selection if available
                            visibility: boardType.lowercased(),
                            background: "default",
                            startDate: startDate,
                            dueDate: endDate,
                            invitedEmails: boardType != "Personal" ? invitedEmails
                                .split(separator: ",")
                                .map { String($0).trimmingCharacters(in: .whitespaces) } : nil
                        )
                        viewModel.submitBoard(board)
                    }) {
                        Text("Create")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .edgesIgnoringSafeArea(.bottom)
                )
                .interactiveDismissDisabled()
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: offset == 0)
        .navigationBarHidden(true)
        .onChange(of: isMenuExp) { _, newValue in
            if newValue && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            } else if !newValue && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: viewModel.shouldNavigateToKanban) { _, newValue in
            if newValue {
                showCreateBoardSheet = false
                if let project = viewModel.currentProject {
                    path.append(Destination.board(project))
                    print("DEBUG: Appended board destination to path")
                }
            }
        }
    }
    var isFormValid: Bool {
        !boardTitle.isEmpty
    }
}

#Preview {
    NavContentView()
}
