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
                        NavigationLink(destination: CalendarView(filter: "To Do")) {
                            TaskBoxView(
                                title: "To Do",
                                color: .blue,
                                type: .todo(total: 18, completedLastMonthPercent: 66.7)
                            )
                        }

                        NavigationLink(destination: CalendarView(filter: "Overdue")) {
                            TaskBoxView(
                                title: "Overdue",
                                color: .red,
                                type: .overdue(count: 4)
                            )
                        }

                        NavigationLink(destination: CalendarView(filter: "Completed")) {
                            TaskBoxView(
                                title: "Completed",
                                color: .green,
                                type: .completed(total: 30, completedThisMonth: 12)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct TaskBoxView: View {
    let title: String
    let color: Color
    let type: TaskBoxType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            contentView
            
            Spacer()
        }
        .padding()
        .frame(width: 250, height: 200)
        .background(color)
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    @ViewBuilder
    private var contentView: some View {
        switch type {
        case .todo(let total, let completedLastMonthPercent):
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Tasks: \(total)")
                Text("Completed Last Month: \(String(format: "%.0f", completedLastMonthPercent))%")
            }
            .foregroundColor(.white)
            .font(.subheadline)

        case .overdue(let count):
            VStack(alignment: .leading, spacing: 8) {
                Text("Overdue Tasks: \(count)")
            }
            .foregroundColor(.white)
            .font(.subheadline)

        case .completed(let total, let completedThisMonth):
            VStack(alignment: .leading, spacing: 8) {
                Text("Completed Tasks: \(total)")
                Text("This Month: \(completedThisMonth)")
            }
            .foregroundColor(.white)
            .font(.subheadline)
        }
    }
}

struct CalendarView: View {
    let filter: String

    var body: some View {
        VStack {
            Text("Calendar View")
                .font(.largeTitle)
                .padding(.bottom)

            Text("Filter: \(filter)")
                .font(.title2)
        }
        .navigationTitle("Calendar")
    }
}

#Preview {
    NavContentView()
}
