//
//  WeatherService.swift
//  WeatherAPI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import Foundation

public class WeatherService {
    private let networkService: NetworkServiceProtocol
    private let mapper: WeatherResponseMapper
    private let latitude: Double
    private let longitude: Double
    
    // Internal initializer for testing and package use
    internal init(
        networkService: NetworkServiceProtocol,
        mapper: WeatherResponseMapper,
        latitude: Double,
        longitude: Double
    ) {
        self.networkService = networkService
        self.mapper = mapper
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Public initializer for consumers
    public init(
        latitude: Double,
        longitude: Double
    ) {
        self.networkService = NetworkService()
        self.mapper = WeatherResponseMapper()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func fetchWeatherData() async throws -> WeatherData {
        // Fetch points data to get forecast URL
        let pointsData: PointsResponse = try await networkService.request(
            WeatherEndpoints.points(latitude: latitude, longitude: longitude)
        )
        
        // Fetch forecast data using the URL from points response
        let forecast: ForecastResponse = try await networkService.request(
            WeatherEndpoints.forecast(url: pointsData.properties.forecast)
        )
        
        // Use mapper to transform responses to domain model
        return try mapper.map((pointsData, forecast))
    }
}

public enum WeatherError: Error, LocalizedError {
    case noForecastData
    
    public var errorDescription: String? {
        switch self {
        case .noForecastData:
            return "No forecast data available"
        }
    }
}
