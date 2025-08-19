//
//  yourTasksView.swift
//  ProjectManager
//
//  Created by aj sai on 15/07/25.
//

import SwiftUI

struct yourTasksView: View {
    var body: some View {
        VStack(spacing: 5) {
            VStack(spacing: 0) {
                HStack {
                    Text("Your Tasks :")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        TaskBoxView(title: "To Do", color: .blue)
                        TaskBoxView(title: "Overdue", color: .red)
                        TaskBoxView(title: "Completed", color: .green)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top)
        }
    }
}

struct TaskBoxView: View {
    let title: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: 250, height: 200)
        .background(color)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    TabBarContentView()
}

