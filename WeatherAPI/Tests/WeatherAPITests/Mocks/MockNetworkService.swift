import Foundation
@testable import WeatherAPI

class MockNetworkService: NetworkServiceProtocol {
    var mockResponses: [String: Any] = [:]
    var shouldThrowError = false
    var errorToThrow: NetworkError = .invalidResponse
    var capturedRequests: [MockRequest] = []
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        return try await performRequestWithoutBody(endpoint, method: .GET)
    }
    
    func request<T: Decodable, U: Encodable>(_ endpoint: Endpoint, method: HTTPMethod, body: U) async throws -> T {
        return try await performRequestWithBody(endpoint, method: method, body: body)
    }
    
    // Private method for requests without body
    private func performRequestWithoutBody<T: Decodable>(_ endpoint: Endpoint, method: HTTPMethod) async throws -> T {
        // Capture the request for testing
        let mockRequest = MockRequest(
            url: endpoint.url.absoluteString,
            method: method,
            headers: endpoint.headers,
            body: nil
        )
        capturedRequests.append(mockRequest)
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        let key = endpoint.url.absoluteString
        
        guard let mockResponse = mockResponses[key] as? T else {
            throw NetworkError.invalidResponse
        }
        
        return mockResponse
    }
    
    // Private method for requests with body
    private func performRequestWithBody<T: Decodable, U: Encodable>(_ endpoint: Endpoint, method: HTTPMethod, body: U) async throws -> T {
        // Capture the request for testing
        let mockRequest = MockRequest(
            url: endpoint.url.absoluteString,
            method: method,
            headers: endpoint.headers,
            body: body
        )
        capturedRequests.append(mockRequest)
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        let key = endpoint.url.absoluteString
        
        guard let mockResponse = mockResponses[key] as? T else {
            throw NetworkError.invalidResponse
        }
        
        return mockResponse
    }
    
    // Helper methods for setting up mock responses
    func setMockResponse<T: Decodable>(_ response: T, for endpoint: Endpoint) {
        mockResponses[endpoint.url.absoluteString] = response
    }
    
    func setShouldThrowError(_ shouldThrow: Bool, error: NetworkError = .invalidResponse) {
        shouldThrowError = shouldThrow
        errorToThrow = error
    }
    
    func clearMockResponses() {
        mockResponses.removeAll()
        shouldThrowError = false
        capturedRequests.removeAll()
    }
    
    // Helper to get captured requests
    func getCapturedRequests() -> [MockRequest] {
        return capturedRequests
    }
    
    // Helper to verify specific requests were made
    func verifyRequest(method: HTTPMethod, url: String) -> Bool {
        return capturedRequests.contains { request in
            request.method == method && request.url == url
        }
    }
}

// MARK: - Mock Request Structure
struct MockRequest {
    let url: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Any?
}
