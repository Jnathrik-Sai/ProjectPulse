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
    @State private var bottomGradientOpacity: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            mainContent(geometry: geometry)
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private func mainContent(geometry: GeometryProxy) -> some View {
        ZStack {
            scrollViewContent(geometry: geometry)
        }
        .background(
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    Color.teal.opacity(0.8),
                    Color.teal.opacity(0.7),
                    Color.teal.opacity(0.6),
                    .white,.white,.white,
                    .white,.white,.white
                ]
            )
            .ignoresSafeArea()
        )
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

    @ViewBuilder
    private func scrollViewContent(geometry: GeometryProxy) -> some View {
        NonBouncingScrollView(bottomGradientOpacity: $bottomGradientOpacity) {
            VStack {
                HomeBody()
                    .frame(maxWidth: .infinity)
                    .offset(y: isExpanded ? -offsetY : 0)
                    .onGeometryChange(for: CGFloat.self) { $0.frame(in: .scrollView(axis: .vertical)).minY } action: { newValue in
                        offsetY = newValue
                    }

                Spacer(minLength: 0)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(bottomGradientOpacity))
                    .edgesIgnoringSafeArea(.horizontal)
            }
            .frame(minHeight: geometry.size.height)
            .frame(maxWidth: .infinity)
        }
        .coordinateSpace(name: "scrollView")
        .frame(width: geometry.size.width, height: geometry.size.height)
        .disabled(showMenu)
        .allowsHitTesting(!showMenu)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20.0) {
            Button {
                print("Menu tapped. showMenu before:", showMenu)
                showMenu.toggle()
                print("showMenu after:", showMenu)
            } label: {
                Image(systemName: "list.bullet")
                    .font(.title3)
                    .padding(8)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.title3)
                    .padding(8)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background {
            Color.clear
                .ignoresSafeArea()
        }
    }

    var progress: CGFloat {
        max(min(offsetY / 100, 1), 0)
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
