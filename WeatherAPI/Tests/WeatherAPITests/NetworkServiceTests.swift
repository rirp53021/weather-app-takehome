import XCTest
@testable import WeatherAPI

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }
    
    override func tearDown() {
        networkService = nil
        mockSession = nil
        super.tearDown()
    }
    
    // MARK: - GET Request Tests
    
    func testSuccessfulGETRequest() async throws {
        // Given
        let testData = TestResponse(message: "Success")
        let jsonData = try JSONEncoder().encode(testData)
        
        mockSession.mockResponses = [
            "https://test.com": (jsonData, HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When
        let result: TestResponse = try await networkService.request(endpoint)
        
        // Then
        XCTAssertEqual(result.message, "Success")
    }
    
    // MARK: - POST Request Tests
    
    func testSuccessfulPOSTRequest() async throws {
        // Given
        let requestBody = TestRequest(message: "Hello")
        let responseData = TestResponse(message: "Posted")
        let jsonData = try JSONEncoder().encode(responseData)
        
        mockSession.mockResponses = [
            "https://test.com": (jsonData, HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 201, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When
        let result: TestResponse = try await networkService.request(endpoint, method: .post, body: requestBody)
        
        // Then
        XCTAssertEqual(result.message, "Posted")
    }
    
    // MARK: - PUT Request Tests
    
    func testSuccessfulPUTRequest() async throws {
        // Given
        let requestBody = TestRequest(message: "Updated")
        let responseData = TestResponse(message: "Updated")
        let jsonData = try JSONEncoder().encode(responseData)
        
        mockSession.mockResponses = [
            "https://test.com": (jsonData, HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When
        let result: TestResponse = try await networkService.request(endpoint, method: .put, body: requestBody)
        
        // Then
        XCTAssertEqual(result.message, "Updated")
    }
    
    // MARK: - DELETE Request Tests
    
    func testSuccessfulDELETERequest() async throws {
        // Given
        let responseData = TestResponse(message: "Deleted")
        let jsonData = try JSONEncoder().encode(responseData)
        
        mockSession.mockResponses = [
            "https://test.com": (jsonData, HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When
        let result: TestResponse = try await networkService.request(endpoint, method: .delete, body: TestRequest(message: "delete"))
        
        // Then
        XCTAssertEqual(result.message, "Deleted")
    }
    
    // MARK: - Error Handling Tests
    
    func testHTTP400BadRequest() async {
        // Given
        mockSession.mockResponses = [
            "https://test.com": (Data(), HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When & Then
        do {
            let _: TestResponse = try await networkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .badRequest)
        }
    }
    
    func testHTTP401Unauthorized() async {
        // Given
        mockSession.mockResponses = [
            "https://test.com": (Data(), HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When & Then
        do {
            let _: TestResponse = try await networkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .unauthorized)
        }
    }
    
    func testHTTP404NotFound() async {
        // Given
        mockSession.mockResponses = [
            "https://test.com": (Data(), HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When & Then
        do {
            let _: TestResponse = try await networkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .notFound)
        }
    }
    
    func testHTTP500ServerError() async {
        // Given
        mockSession.mockResponses = [
            "https://test.com": (Data(), HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When & Then
        do {
            let _: TestResponse = try await networkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .serverError(statusCode: 500))
        }
    }
    
    func testDecodingError() async {
        // Given
        let invalidJSON = "invalid json".data(using: .utf8)!
        
        mockSession.mockResponses = [
            "https://test.com": (invalidJSON, HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When & Then
        do {
            let _: TestResponse = try await networkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .decodingError(any()))
        }
    }
    
    func testInvalidResponse() async {
        // Given
        mockSession.mockResponses = [
            "https://test.com": (Data(), URLResponse())
        ]
        
        let endpoint = TestEndpoint(url: "https://test.com")
        
        // When & Then
        do {
            let _: TestResponse = try await networkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
    
    // MARK: - Custom Headers Test
    
    func testCustomHeaders() async throws {
        // Given
        let testData = TestResponse(message: "Success")
        let jsonData = try JSONEncoder().encode(testData)
        
        mockSession.mockResponses = [
            "https://test.com": (jsonData, HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        let endpoint = TestEndpointWithHeaders(url: "https://test.com")
        
        // When
        let result: TestResponse = try await networkService.request(endpoint)
        
        // Then
        XCTAssertEqual(result.message, "Success")
    }
}

// MARK: - Test Helpers
struct TestResponse: Codable, Equatable {
    let message: String
}

struct TestRequest: Codable, Equatable {
    let message: String
}

struct TestEndpoint: Endpoint {
    let url: String
    
    var url: URL {
        URL(string: url)!
    }
}

struct TestEndpointWithHeaders: Endpoint {
    let url: String
    
    var url: URL {
        URL(string: url)!
    }
    
    var headers: [String: String]? {
        return ["Authorization": "Bearer token123", "Custom-Header": "custom-value"]
    }
}

class MockURLSession: URLSession {
    var mockResponses: [String: (Data, URLResponse)] = [:]
    
    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let key = request.url?.absoluteString ?? ""
        guard let response = mockResponses[key] else {
            throw URLError(.badServerResponse)
        }
        return response
    }
    
    // Keep the old method for backward compatibility
    override func data(from url: URL) async throws -> (Data, URLResponse) {
        let key = url.absoluteString
        guard let response = mockResponses[key] else {
            throw URLError(.badServerResponse)
        }
        return response
    }
}

// MARK: - Test Utilities
private func any<T>() -> T {
    fatalError("This function should not be called in tests")
}
