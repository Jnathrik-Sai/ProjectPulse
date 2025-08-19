//
//  HomeBody.swift
//  ProjectManager
//
//  Created by aj sai on 14/07/25.
//


import SwiftUI
import BottomSheet


struct HomeBody: View {
    
    var body: some View {
        ZStack {

            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Task for today:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 50)
                        .padding(.bottom, 5)

                    Label {
                        Text("5 available")
                    } icon: {
                        Image(systemName: "star.fill")
                            .font(.system(.footnote))
                            .foregroundColor(.yellow)
                    }

                    HStack {
                        Text("Last connections")
                            .font(.headline)
                        Spacer()
                        HStack {
                            Text("See all")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 30)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 15) {
                            Section {
                                ForEach(0..<5) { _ in
                                    Circle()
                                        .frame(width: 15, height: 15)
                                }
                            } footer: {
                                Text("+5")
                                    .padding()
                                    .background(Color("gray"))
                                    .clipShape(Circle())
                            }
                        }
                        .frame(height: 55)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                
                // MARK: - Bottom Section
                VStack(spacing: 0) {
                    HStack {
                        Text("Active projects")
                            .font(.system(size: 23))
                        Spacer()
                        HStack {
                            Text("See all")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)

                    ForEach(0..<5) { _ in
                        ActiveProjectCard(projectId: "12345")
                    }
                    yourTasksView()
                        .padding(.bottom, 150)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top)
                .background(.ultraThinMaterial)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}


#Preview {
    TabBarContentView()
}
