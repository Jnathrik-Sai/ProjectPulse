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
        VStack(alignment: .leading, spacing: 0, content: {
            VStack(alignment: .leading, spacing: 14){
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                Text("Username")
                    .font(.title2.bold())
                Text("@Username")
                    .font(.callout)
                HStack(spacing: 12) {
                    Button{
                        
                    } label: {
                        Label{
                            Text("Total Projects")
                        } icon: {
                            Text("5")
                                .fontWeight(.bold)
                        }
                    }
                    Button{
                        
                    } label: {
                        Label{
                            Text("Favorites")
                        } icon: {
                            Text("4")
                                .fontWeight(.bold)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            .padding(.horizontal)
            .padding(.leading)
            Divider()
                .padding(.top, 15)
                .frame(maxWidth: .infinity)
                .frame(width: 270)
                .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    VStack(alignment : .leading, spacing: 30) {
                        TabButton(title: "DashBoard", icon: "list.dash.header.rectangle")
                        TabButton(title: "Tasks", icon: "chart.bar.horizontal.page")
                        TabButton(title: "Projects", icon: "folder")
                        TabButton(title: "View Connections", icon: "person.3.fill")
                        TabButton(title: "Bookmarks", icon: "bookmark")
                    }
                    .padding()
                    .padding(.leading)
                    .padding(.top, 20)
                    Divider()
                    VStack(alignment: .leading, spacing: 15){
                        Button("Settings And Privacy"){
                            
                        }
                        Button("About"){
                            
                        }
                    }
                    .padding()
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black)
                }
            }
            VStack(spacing: 0) {
                Button{
                    
                } label: {
                    Text("Sign Out")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.red)
                }
            }
            .padding()
        })
        .padding(.vertical)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background{
            Color.primary.opacity(0.2)
                .ignoresSafeArea(.container, edges: .vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func TabButton(title : String, icon : String) -> some View {
        Button{
            
        } label: {
            HStack(spacing: 17){
                Image(systemName :icon)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                Text(title)
                    .font(.system(size: 23, weight: .medium))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView()
}
