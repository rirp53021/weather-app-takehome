//
//  WeatherViewModel.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import Foundation
import WeatherAPI

@MainActor
public class WeatherViewModel: ObservableObject {
    @Published public var uiState: WeatherWidget.UIState = .loading
    
    private var weatherService: WeatherService?
    
    // Hardcoded coordinates for San Jose, CA as specified in test.txt
    private let defaultLatitude: Double = 37.2883
    private let defaultLongitude: Double = -121.8434
    
    public init() {
        // Create weather service with hardcoded coordinates
        self.weatherService = WeatherService(
            latitude: defaultLatitude,
            longitude: defaultLongitude
        )
        
        // Fetch weather data immediately
        Task {
            await fetchWeather()
        }
    }
    
    public func fetchWeather() async {
        guard let weatherService = weatherService else {
            uiState = .error("Weather service not available.")
            return
        }
        
        uiState = .loading
        
        do {
            let weatherData = try await weatherService.fetchWeatherData()
            uiState = .content(
                temperature: weatherData.temperature,
                location: weatherData.location
            )
        } catch {
            uiState = .error(error.localizedDescription)
        }
    }
    
    public func retry() async {
        await fetchWeather()
    }
}
