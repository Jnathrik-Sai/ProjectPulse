//
//  TabContentView.swift
//  ProjectManager
//
//  Created by aj sai on 13/07/25.
//

import SwiftUI

struct TabBarView3: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        TabsLayoutView(selectedTab: $selectedTab)
            .padding()
            .background(
                Capsule()
                    .fill(.white)
            )
            .frame(height: 70)
            .shadow(radius: 30)
    }
}

fileprivate struct TabsLayoutView: View {
    @Binding var selectedTab: Tab
    @Namespace var namespace
    var status: Bool {
            selectedTab == .home || selectedTab == .projects
        }
    var body: some View {
        HStack(spacing : !status ? 0 : 12){
            HStack {
                ForEach(Tab.allCases) { tab in
                    TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                }
            }
        }
    }
    
    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        var namespace: Namespace.ID
        @State private var selectedOffset: CGFloat = 0
        @State private var rotationAngle: CGFloat = 0
        
        var body: some View {
            Button {
                withAnimation(.easeInOut) {
                    HapticManager.shared.vibrateForSelection()
                    selectedTab = tab
                }
                
                selectedOffset = -60
                if tab < selectedTab {
                    rotationAngle += 360
                } else {
                    rotationAngle -= 360
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    selectedOffset = 0
                    if tab < selectedTab {
                        rotationAngle += 720
                    } else {
                        rotationAngle -= 720
                    }
                }
            } label: {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(tab.color.opacity(0.2))
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                    }
                    HStack(spacing: 10) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                            .rotationEffect(.degrees(rotationAngle))
                            .scaleEffect(isSelected ? 1 : 0.9)
                            .animation(.easeInOut, value: rotationAngle)
                            .opacity(isSelected ? 1 : 0.7)
                            .padding(.leading, isSelected ? 20 : 0)
                            .padding(.horizontal, selectedTab != tab ? 10 : 0)
                            .offset(y: selectedOffset)
                            .animation(.default, value: selectedOffset)
                        
                        if isSelected {
                            Text(tab.title)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(tab.color)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .buttonStyle(.plain)
        }
        
        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}

#Preview(body: {
    TabBarContentView()
})
