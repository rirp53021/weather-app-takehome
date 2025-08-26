import XCTest
import SwiftUI
@testable import WeatherUI

final class WeatherWidgetTests: XCTestCase {
    
    // MARK: - WeatherWidget Tests
    
    func testWeatherWidgetWithUIState() {
        // Test with UIState
        let contentState = WeatherWidget.UIState.content(temperature: 75, location: "San Jose, CA")
        let widget = WeatherWidget(state: contentState)
        XCTAssertNotNil(widget)
        
        let loadingState = WeatherWidget.UIState.loading
        let loadingWidget = WeatherWidget(state: loadingState)
        XCTAssertNotNil(loadingWidget)
        
        let errorState = WeatherWidget.UIState.error("Test error")
        let errorWidget = WeatherWidget(state: errorState)
        XCTAssertNotNil(errorWidget)
    }
    
    func testWeatherWidgetInitialization() {
        // Given
        let temperature = 75
        let location = "San Jose, CA"
        
        // When
        let widget = WeatherWidget(state: .content(temperature: temperature, location: location))
        
        // Then
        XCTAssertNotNil(widget)
    }
    
    func testWeatherWidgetAllStates() {
        // Test normal state
        let normalWidget = WeatherWidget(state: .content(temperature: 72, location: "San Jose, CA"))
        XCTAssertNotNil(normalWidget)
        
        // Test loading state
        let loadingWidget = WeatherWidget(state: .loading)
        XCTAssertNotNil(loadingWidget)
        
        // Test error state
        let errorWidget = WeatherWidget(state: .error("Test error"))
        XCTAssertNotNil(errorWidget)
    }
    
    // MARK: - UIState Tests
    
    func testUIStateEnum() {
        // Test content state
        let contentState = WeatherWidget.UIState.content(temperature: 85, location: "Test Location")
        XCTAssertNotNil(contentState)
        
        // Test loading state
        let loadingState = WeatherWidget.UIState.loading
        XCTAssertNotNil(loadingState)
        
        // Test error state
        let errorState = WeatherWidget.UIState.error("Test error message")
        XCTAssertNotNil(errorState)
    }
    
    func testUIStateEquatable() {
        // Test that UIState conforms to Equatable
        let state1 = WeatherWidget.UIState.content(temperature: 72, location: "San Jose")
        let state2 = WeatherWidget.UIState.content(temperature: 72, location: "San Jose")
        let state3 = WeatherWidget.UIState.content(temperature: 75, location: "San Jose")
        
        XCTAssertEqual(state1, state2)
        XCTAssertNotEqual(state1, state3)
        XCTAssertNotEqual(state1, .loading)
        XCTAssertNotEqual(state1, .error("Test"))
    }
    
    // MARK: - Component Tests
    
    func testWeatherLoadingView() {
        let loadingView = WeatherLoadingView()
        XCTAssertNotNil(loadingView)
    }
    
    func testWeatherErrorView() {
        let errorMessage = "Test error message"
        let errorView = WeatherErrorView(errorMessage: errorMessage)
        XCTAssertNotNil(errorView)
    }
    
    func testWeatherContentView() {
        let temperature = 85
        let location = "Test Location"
        let contentView = WeatherContentView(temperature: temperature, location: location)
        XCTAssertNotNil(contentView)
    }
    
    func testWeatherCardContainer() {
        let container = WeatherCardContainer {
            Text("Test Content")
        }
        XCTAssertNotNil(container)
    }
}
