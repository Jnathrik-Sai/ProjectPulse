import Foundation
import SwiftUI

enum BoardVisibility: String, CaseIterable, Identifiable {
    case `private` = "Private"
    case workspace = "Workspace"
    case publicBoard = "Public"

    var id: String { rawValue }
}

struct BoardRequest: Codable {
    let name: String
    let description: String
    let workspaceId: String
    let visibility: String
    let background: String
    let template: String = "default"
    let startDate: Date
    let dueDate: Date
    let invitedEmails: [String]?
}


struct BoardResponse: Codable {
    let id: String
    let name: String
    
}

struct Workspace: Identifiable, Codable, Hashable {
    let id: String
    let name: String
}
