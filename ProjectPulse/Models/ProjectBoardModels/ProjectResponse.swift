//
//  ProjectResponse.swift
//  ProjectPulse
//
//  Created by aj sai on 19/08/25.
//

import Foundation

struct ProjectResponse: Codable, Hashable{
    let id: String
    let name: String
    let description: String?
    let workspaceId: String
    let visibility: String
    let background: String
    let template: String
    let invitedEmails: [String]?
    let startDate: Date
    let dueDate: Date
    let createdAt: Date
    let updatedAt: Date
}
