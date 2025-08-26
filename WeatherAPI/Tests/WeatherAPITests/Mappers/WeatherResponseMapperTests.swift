import XCTest
@testable import WeatherAPI

final class WeatherResponseMapperTests: XCTestCase {
    var mapper: WeatherResponseMapper!
    
    override func setUp() {
        super.setUp()
        mapper = WeatherResponseMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func testSuccessfulMapping() throws {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(
                periods: [Period(temperature: 72)]
            )
        )
        
        let response = (pointsResponse, forecastResponse)
        
        // When
        let result = try mapper.map(response)
        
        // Then
        XCTAssertEqual(result.temperature, 72)
        XCTAssertEqual(result.location, "San Jose, CA")
    }
    
    func testMappingWithMultiplePeriods() throws {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(
                periods: [
                    Period(temperature: 72),
                    Period(temperature: 75),
                    Period(temperature: 68)
                ]
            )
        )
        
        let response = (pointsResponse, forecastResponse)
        
        // When
        let result = try mapper.map(response)
        
        // Then
        XCTAssertEqual(result.temperature, 72) // Should use first period
        XCTAssertEqual(result.location, "San Jose, CA")
    }
    
    func testMappingWithNoPeriods() {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(periods: [])
        )
        
        let response = (pointsResponse, forecastResponse)
        
        // When & Then
        do {
            let _ = try mapper.map(response)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? WeatherError, .noForecastData)
        }
    }
    
    func testMappingWithEmptyPeriodsArray() {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(periods: [])
        )
        
        let response = (pointsResponse, forecastResponse)
        
        // When & Then
        do {
            let _ = try mapper.map(response)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? WeatherError, .noForecastData)
        }
    }
    
    func testMappingWithDifferentTemperatures() throws {
        // Given
        let pointsResponse = PointsResponse(
            properties: PointsProperties(forecast: "https://api.weather.gov/gridpoints/MTR/84,105/forecast")
        )
        
        let forecastResponse = ForecastResponse(
            properties: ForecastProperties(
                periods: [Period(temperature: 95)]
            )
        )
        
        let response = (pointsResponse, forecastResponse)
        
        // When
        let result = try mapper.map(response)
        
        // Then
        XCTAssertEqual(result.temperature, 95)
        XCTAssertEqual(result.location, "San Jose, CA")
    }
}
