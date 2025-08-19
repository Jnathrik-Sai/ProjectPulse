//
//  ContentView.swift
//  ProjectPulse
//
//  Created by aj sai on 18/07/25.
//

import SwiftUI
import SwiftData

struct NavContentView: View {
    @State private var isMenuExp: Bool = false
    @State private var selectedTab: Tab = .home
    @State private var isTabBarHidden: Bool = false
    @State private var showCreateBoardSheet = false
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        let sideBarWidth = getRect().width - 90

        NavigationView {
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
        }
        .sheet(isPresented: $showCreateBoardSheet) {
            Text("Board") // Replace with your actual sheet content
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
    }
}

#Preview {
    NavContentView()
}
