//
//  ApiModel.swift
//  ProjectManager
//
//  Created by aj sai on 17/07/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response."
        case .decodingFailed(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .serverError(let code, _):
            return "Server error: HTTP \(code)"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
