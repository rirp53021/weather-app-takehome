//
//  WeatherEndpoints.swift
//  WeatherAPI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import Foundation

// MARK: - Weather API Endpoints
internal enum WeatherEndpoints {
    case points(latitude: Double, longitude: Double)
    case forecast(url: String)
}

extension WeatherEndpoints: Endpoint {
    var url: URL {
        switch self {
        case .points(let latitude, let longitude):
            let urlString = "https://api.weather.gov/points/\(latitude),\(longitude)"
            return URL(string: urlString)!
            
        case .forecast(let urlString):
            return URL(string: urlString)!
        }
    }
}
