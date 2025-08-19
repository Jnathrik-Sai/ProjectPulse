//
//  BoardForm.swift
//  ProjectPulse
//
//  Created by aj sai on 04/08/25.
//

import Foundation

struct BoardFormData: Codable {
    var title: String
    var description: String?
    var startDate: Date?
    var endDate: Date?
    var boardType: String
    var ownerId: UUID?
    var invitedEmails: [String]?
}
