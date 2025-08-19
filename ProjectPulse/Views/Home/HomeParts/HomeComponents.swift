//
//  HomeComponents.swift
//  ProjectManager
//
//  Created by aj sai on 14/07/25.
//

import SwiftUI

struct HomeComponents: View {
    var body: some View {
        VStack(spacing: 5.0){
            HStack{
                Text("Active Projects")
                    .font(.headline)
                Spacer()
                
            }
        }
        .padding(.top, 25.0)
    }
}

#Preview {
    ProjectsView()
}
