//
//  TaskModel.swift
//  ProjectPulse
//
//  Created by aj sai on 20/07/25.
//

import Foundation

enum TaskBoxType {
    case todo(total: Int, completedLastMonthPercent: Double)
    case overdue(count: Int)
    case completed(total: Int, completedThisMonth: Int)
}
