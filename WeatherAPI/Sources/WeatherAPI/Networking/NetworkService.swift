//
//  NetworkService.swift
//  WeatherAPI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import Foundation

// MARK: - Network Service Protocol
internal protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request<T: Decodable, U: Encodable>(_ endpoint: Endpoint, method: HTTPMethod, body: U) async throws -> T
}

// MARK: - Network Service Implementation
internal class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    internal init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Method for GET requests (no body)
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        return try await performRequestWithoutBody(endpoint, method: .get)
    }
    
    // Method for requests with body (POST, PUT, DELETE)
    func request<T: Decodable, U: Encodable>(_ endpoint: Endpoint, method: HTTPMethod, body: U) async throws -> T {
        return try await performRequestWithBody(endpoint, method: method, body: body)
    }
    
    // MARK: - Private Helper Methods
    
    private func performRequestWithoutBody<T: Decodable>(_ endpoint: Endpoint, method: HTTPMethod) async throws -> T {
        let request = createRequest(for: endpoint, method: method)
        let (data, response) = try await session.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    private func performRequestWithBody<T: Decodable, U: Encodable>(_ endpoint: Endpoint, method: HTTPMethod, body: U) async throws -> T {
        var request = createRequest(for: endpoint, method: method)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.encodingError(error)
        }
        
        let (data, response) = try await session.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    private func createRequest(for endpoint: Endpoint, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue
        
        // Set default headers
        setDefaultHeaders(&request)
        
        // Add custom headers from endpoint
        if let customHeaders = endpoint.headers {
            for (key, value) in customHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    private func setDefaultHeaders(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateHTTPStatus(httpResponse.statusCode)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func validateHTTPStatus(_ statusCode: Int) throws {
        switch statusCode {
        case 200...299:
            return // Success
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(statusCode: statusCode)
        default:
            throw NetworkError.httpError(statusCode: statusCode)
        }
    }
}
