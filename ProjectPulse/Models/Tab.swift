//
//  Tab.swift
//  ProjectManager
//
//  Created by aj sai on 16/07/25.
//

import Foundation
import SwiftUICore

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case home, projects, activity, profile
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .projects:
            return "folder.fill"
        case .activity:
            return "clock.fill"
        case .profile:
            return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .projects:
            return "Projects"
        case .activity:
            return "Activity"
        case .profile:
            return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .indigo
        case .projects:
            return .pink
        case .activity:
            return .orange
        case .profile:
            return .teal
        }
    }
}
