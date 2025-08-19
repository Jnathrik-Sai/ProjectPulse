//
//  MenuBar.swift
//  ProjectManager
//
//  Created by aj sai on 18/07/25.
//

import SwiftUI

struct MenuBar: View {
    @Binding var isMenuExpanded: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 14) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())

                    Text("Username")
                        .font(.title2.bold())

                    Text("@Username")
                        .font(.callout)
                        .foregroundColor(.gray)

                    HStack(spacing: 12) {
                        Button {} label: {
                            Label {
                                Text("Total Projects")
                            } icon: {
                                Text("5")
                                    .fontWeight(.bold)
                            }
                        }

                        Button {} label: {
                            Label {
                                Text("Favorites")
                            } icon: {
                                Text("4")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .padding(.top, 80)
                .padding(.horizontal, 20)

                Divider()
                    .padding(.top, 15)
                    .padding(.horizontal)

                // Scrollable Menu Items
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 30) {
                        TabButton(title: "DashBoard", icon: "list.dash.header.rectangle")
                        TabButton(title: "Tasks", icon: "chart.bar.horizontal.page")
                        TabButton(title: "Projects", icon: "folder")
                        TabButton(title: "View Connections", icon: "person.3.fill")
                        TabButton(title: "Bookmarks", icon: "bookmark")

                        Divider()

                        VStack(alignment: .leading, spacing: 15) {
                            Button("Settings And Privacy") {}
                            Button("About") {}
                        }
                        .foregroundStyle(.black)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }

                Spacer()

                // Bottom "Sign Out" Button - Centered
                HStack {
                    Spacer()
                    Button {
                        // Handle sign out
                    } label: {
                        Text("Sign Out")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    func TabButton(title: String, icon: String) -> some View {
        Button {
        } label: {
            HStack(spacing: 17) {
                Image(systemName: icon)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)

                Text(title)
                    .font(.system(size: 20, weight: .medium))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
#Preview {
    NavContentView()
}
