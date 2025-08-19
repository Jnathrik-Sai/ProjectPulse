//
//  HomeView.swift
//  ProjectPulse
//
//  Created by aj sai on 19/07/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var showMenu: Bool
    @State private var offsetY: CGFloat = 0
    @FocusState private var isExpanded: Bool
    @Binding var isTabBarHidden: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical) {
                    VStack {
                        HomeBody()
                            .frame(maxWidth: .infinity)
                            .offset(y: isExpanded ? -offsetY : 0)
                            .onGeometryChange(for: CGFloat.self) {
                                $0.frame(in: .scrollView(axis: .vertical)).minY
                            } action: { newValue in
                                offsetY = newValue
                            }

                        Spacer(minLength: 0)
                    }
                    .frame(minHeight: geometry.size.height)
                    .frame(maxWidth: .infinity)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .disabled(showMenu)
                .allowsHitTesting(!showMenu)
            }
            .background(.teal)
            .overlay {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .background(.background.opacity(0.25))
                    .ignoresSafeArea()
                    .overlay {
                        ExpandedSearchContent(isExpanded: isExpanded)
                            .offset(y: isExpanded ? 0 : 70)
                            .opacity(isExpanded ? 1 : 0)
                            .allowsHitTesting(isExpanded)
                    }
                    .opacity(isExpanded ? 1 : progress)
            }
            .safeAreaInset(edge: .top) {
                HeaderView()
            }
            .scrollTargetBehavior(OnScrollEnd { dy in
                guard !showMenu else { return }
                if offsetY > 100 || (-dy > 1.5 && offsetY > 0) {
                    isExpanded = true
                }
            })
            .onChange(of: isExpanded) { _, newValue in
                isTabBarHidden = newValue
            }
            .onChange(of: showMenu) { _, newValue in
                if newValue {
                    isExpanded = false
                }
            }
            .animation(.easeInOut(duration: 0.1), value: isExpanded)
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20.0) {
            if !isExpanded {
                Button {
                    showMenu.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title3)
                }
                .transition(.blurReplace)
            }

            TextField("Search for projects...", text: .constant(""))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    ZStack {
                        Rectangle().fill(.gray.opacity(0.2))
                        Rectangle().fill(.ultraThinMaterial)
                    }
                    .clipShape(.rect(cornerRadius: 15))
                }
                .focused($isExpanded)

            Button {
                // Bell button action
            } label: {
                Image(systemName: "bell")
                    .font(.title3)
            }
            .opacity(isExpanded ? 0 : 1)
            .overlay(alignment: .trailing) {
                Button("Cancel") {
                    isExpanded = false
                }
                .fixedSize()
                .opacity(isExpanded ? 1 : 0)
            }
            .padding(.leading, isExpanded ? 20 : 0)
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(!isExpanded ? 1 : 0) // ✅ Fixed here
        }
    }

    var progress: CGFloat {
        max(min(offsetY / 100, 1), 0)
    }
}

struct ExpandedSearchContent: View {
    var isExpanded: Bool

    var body: some View {
        if isExpanded {
            Text("Hello, world!")
        }
    }
}

struct OnScrollEnd: ScrollTargetBehavior {
    var onEnd: (CGFloat) -> ()
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let dy = context.velocity.dy
        DispatchQueue.main.async {
            onEnd(dy)
        }
    }
}

#Preview {
    HomeView(
        showMenu: .constant(false),
        isTabBarHidden: .constant(false)
    )
}
