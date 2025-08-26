import XCTest
@testable import WeatherAPI

final class MockNetworkServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testCapturesGETRequest() async throws {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users")
        let response = TestResponse(message: "Success")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        let _: TestResponse = try await mockNetworkService.request(endpoint)
        
        // Then
        let capturedRequests = mockNetworkService.getCapturedRequests()
        XCTAssertEqual(capturedRequests.count, 1)
        XCTAssertEqual(capturedRequests.first?.method, .get)
        XCTAssertEqual(capturedRequests.first?.url, "https://api.test.com/users")
        XCTAssertNil(capturedRequests.first?.body)
    }
    
    func testCapturesPOSTRequest() async throws {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users")
        let requestBody = TestRequest(message: "Create user")
        let response = TestResponse(message: "Created")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        let _: TestResponse = try await mockNetworkService.request(endpoint, method: .post, body: requestBody)
        
        // Then
        let capturedRequests = mockNetworkService.getCapturedRequests()
        XCTAssertEqual(capturedRequests.count, 1)
        XCTAssertEqual(capturedRequests.first?.method, .post)
        XCTAssertEqual(capturedRequests.first?.url, "https://api.test.com/users")
        XCTAssertNotNil(capturedRequests.first?.body)
    }
    
    func testCapturesPUTRequest() async throws {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users/123")
        let requestBody = TestRequest(message: "Update user")
        let response = TestResponse(message: "Updated")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        let _: TestResponse = try await mockNetworkService.request(endpoint, method: .put, body: requestBody)
        
        // Then
        let capturedRequests = mockNetworkService.getCapturedRequests()
        XCTAssertEqual(capturedRequests.count, 1)
        XCTAssertEqual(capturedRequests.first?.method, .put)
        XCTAssertEqual(capturedRequests.first?.url, "https://api.test.com/users/123")
        XCTAssertNotNil(capturedRequests.first?.body)
    }
    
    func testCapturesDELETERequest() async throws {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users/123")
        let response = TestResponse(message: "Deleted")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        let _: TestResponse = try await mockNetworkService.request(endpoint, method: .delete, body: TestRequest(message: "delete"))
        
        // Then
        let capturedRequests = mockNetworkService.getCapturedRequests()
        XCTAssertEqual(capturedRequests.count, 1)
        XCTAssertEqual(capturedRequests.first?.method, .delete)
        XCTAssertEqual(capturedRequests.first?.url, "https://api.test.com/users/123")
        XCTAssertNotNil(capturedRequests.first?.body)
    }
    
    func testCapturesCustomHeaders() async throws {
        // Given
        let endpoint = TestEndpointWithHeaders(url: "https://api.test.com/users")
        let response = TestResponse(message: "Success")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        let _: TestResponse = try await mockNetworkService.request(endpoint)
        
        // Then
        let capturedRequests = mockNetworkService.getCapturedRequests()
        XCTAssertEqual(capturedRequests.count, 1)
        XCTAssertNotNil(capturedRequests.first?.headers)
        XCTAssertEqual(capturedRequests.first?.headers?["Authorization"], "Bearer token123")
        XCTAssertEqual(capturedRequests.first?.headers?["Custom-Header"], "custom-value")
    }
    
    func testVerifyRequestMethod() {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users")
        let response = TestResponse(message: "Success")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        let _ = mockNetworkService.verifyRequest(method: .get, url: "https://api.test.com/users")
        
        // Then
        XCTAssertFalse(mockNetworkService.verifyRequest(method: .get, url: "https://api.test.com/users"))
        
        // After making a request
        Task {
            let _: TestResponse = try await mockNetworkService.request(endpoint)
        }
        
        // Wait a bit for async operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.verifyRequest(method: .get, url: "https://api.test.com/users"))
        }
    }
    
    func testClearMockResponses() {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users")
        let response = TestResponse(message: "Success")
        mockNetworkService.setMockResponse(response, for: endpoint)
        
        // When
        mockNetworkService.clearMockResponses()
        
        // Then
        XCTAssertTrue(mockNetworkService.getCapturedRequests().isEmpty)
    }
    
    func testThrowsConfiguredError() async {
        // Given
        let endpoint = TestEndpoint(url: "https://api.test.com/users")
        mockNetworkService.setShouldThrowError(true, error: .unauthorized)
        
        // When & Then
        do {
            let _: TestResponse = try await mockNetworkService.request(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .unauthorized)
        }
    }
}

// MARK: - Test Helpers
private struct TestResponse: Codable, Equatable {
    let message: String
}

private struct TestRequest: Codable, Equatable {
    let message: String
}

private struct TestEndpoint: Endpoint {
    let url: String
    
    var url: URL {
        URL(string: url)!
    }
}

private struct TestEndpointWithHeaders: Endpoint {
    let url: String
    
    var url: URL {
        URL(string: url)!
    }
    
    var headers: [String: String]? {
        return ["Authorization": "Bearer token123", "Custom-Header": "custom-value"]
    }
}
