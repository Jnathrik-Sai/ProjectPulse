//
//  ApiModel.swift
//  ProjectManager
//
//  Created by aj sai on 17/07/25.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ApiError: Error {
    case invalidURL
    case noData
}
