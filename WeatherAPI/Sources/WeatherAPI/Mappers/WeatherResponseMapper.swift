import Foundation

// MARK: - Weather Response Mapper (Internal)
internal struct WeatherResponseMapper: ResponseMapper {
    
    internal init() {}
    
    internal func map(_ response: (PointsResponse, ForecastResponse)) throws -> WeatherData {
        let (_, forecast) = response
        
        guard let firstPeriod = forecast.properties.periods.first else {
            throw WeatherError.noForecastData
        }
        
        return WeatherData(
            temperature: firstPeriod.temperature,
            location: "San Jose, CA"
        )
    }
}
