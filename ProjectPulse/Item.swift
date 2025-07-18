//
//  Item.swift
//  ProjectPulse
//
//  Created by aj sai on 18/07/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
