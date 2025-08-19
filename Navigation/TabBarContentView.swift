//
//  ContentView.swift
//  ProjectManager
//
//  Created by aj sai on 16/07/25.
//

import SwiftUI

let backgroundColor = Color.init(white: 0.92)

struct TabBarContentView: View {
    @State private var showCreateBoardSheet = false
    @State private var selectedTab: Tab = .home
    @State private var isTabBarHidden: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(isTabBarHidden: $isTabBarHidden)
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
                CreateBoardView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContentView()
    }
}
