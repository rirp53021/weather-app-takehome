//
//  NetworkModels.swift
//  WeatherAPI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import Foundation

// MARK: - HTTP Method Enum
internal enum HTTPMethod: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Endpoint Protocol
internal protocol Endpoint {
    var url: URL { get }
    var headers: [String: String]? { get }
}

// MARK: - Default Endpoint Implementation
internal extension Endpoint {
    var headers: [String: String]? {
        return nil
    }
}

// MARK: - Network Errors
internal enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .badRequest:
            return "Bad request (400)"
        case .unauthorized:
            return "Unauthorized (401)"
        case .forbidden:
            return "Forbidden (403)"
        case .notFound:
            return "Not found (404)"
        case .serverError(let statusCode):
            return "Server error: \(statusCode)"
        }
    }
}
