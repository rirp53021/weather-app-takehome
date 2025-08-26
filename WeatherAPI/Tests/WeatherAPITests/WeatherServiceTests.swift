import XCTest
@testable import WeatherAPI

final class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    var mockNetworkService: MockNetworkService!
    var mockMapper: MockWeatherResponseMapper!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockMapper = MockWeatherResponseMapper()
        weatherService = WeatherService(
            networkService: mockNetworkService,
            mapper: mockMapper
        )
    }
    
    override func tearDown() {
        weatherService = nil
        mockNetworkService = nil
        mockMapper = nil
        super.tearDown()
    }
    
    func testFetchWeatherDataSuccess() async throws {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(
                periods: [Period(temperature: 72)]
            )
        )
        
        let expectedWeatherData = WeatherData(temperature: 72, location: "San Jose, CA")
        
        mockNetworkService.setMockResponse(pointsResponse, for: WeatherEndpoints.points(latitude: 37.2883, longitude: -121.8434))
        mockNetworkService.setMockResponse(forecastResponse, for: WeatherEndpoints.forecast(url: "https://api.weather.gov/gridpoints/MTR/84,105/forecast"))
        mockMapper.mockResult = expectedWeatherData
        
        // When
        let result = try await weatherService.fetchWeatherData()
        
        // Then
        XCTAssertEqual(result.temperature, 72)
        XCTAssertEqual(result.location, "San Jose, CA")
        XCTAssertTrue(mockMapper.mapWasCalled)
    }
    
    func testFetchWeatherDataNetworkError() async {
        // Given
        mockNetworkService.setShouldThrowError(true, error: .httpError(statusCode: 500))
        
        // When & Then
        do {
            _ = try await weatherService.fetchWeatherData()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .httpError(statusCode: 500))
        }
    }
    
    func testFetchWeatherDataMapperError() async throws {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(
                periods: [Period(temperature: 72)]
            )
        )
        
        mockNetworkService.setMockResponse(pointsResponse, for: WeatherEndpoints.points(latitude: 37.2883, longitude: -121.8434))
        mockNetworkService.setMockResponse(forecastResponse, for: WeatherEndpoints.forecast(url: "https://api.weather.gov/gridpoints/MTR/84,105/forecast"))
        mockMapper.shouldThrowError = true
        mockMapper.errorToThrow = WeatherError.noForecastData
        
        // When & Then
        do {
            _ = try await weatherService.fetchWeatherData()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? WeatherError, .noForecastData)
        }
    }
    
    func testFetchWeatherDataWithCustomCoordinates() async throws {
        // Given
        let customLatitude = 40.7128
        let customLongitude = -74.0060
        let customWeatherService = WeatherService(
            networkService: mockNetworkService,
            mapper: mockMapper,
            latitude: customLatitude,
            longitude: customLongitude
        )
        
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/OKX/32,35/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(
                periods: [Period(temperature: 68)]
            )
        )
        
        let expectedWeatherData = WeatherData(temperature: 68, location: "San Jose, CA")
        
        mockNetworkService.setMockResponse(pointsResponse, for: WeatherEndpoints.points(latitude: customLatitude, longitude: customLongitude))
        mockNetworkService.setMockResponse(forecastResponse, for: WeatherEndpoints.forecast(url: "https://api.weather.gov/gridpoints/OKX/32,35/forecast"))
        mockMapper.mockResult = expectedWeatherData
        
        // When
        let result = try await customWeatherService.fetchWeatherData()
        
        // Then
        XCTAssertEqual(result.temperature, 68)
        XCTAssertEqual(result.location, "San Jose, CA")
        XCTAssertTrue(mockMapper.mapWasCalled)
    }
}

// MARK: - Mock Mapper
private class MockWeatherResponseMapper: WeatherResponseMapper {
    var mockResult: WeatherData?
    var shouldThrowError = false
    var errorToThrow: Error = WeatherError.noForecastData
    var mapWasCalled = false
    
    func map(_ response: (PointsResponse, ForecastResponse)) throws -> WeatherData {
        mapWasCalled = true
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockResult ?? WeatherData(temperature: 0, location: "Mock Location")
    }
}
