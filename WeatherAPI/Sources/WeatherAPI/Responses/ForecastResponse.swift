import Foundation

// MARK: - Forecast Response
internal struct ForecastResponse: Codable {
    let properties: ForecastProperties
}

// Note: ForecastProperties and Period are now defined in separate files:
// - ForecastProperties.swift
// - Period.swift
