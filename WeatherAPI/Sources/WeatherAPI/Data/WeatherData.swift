import Foundation

public struct WeatherData {
    public let temperature: Int
    public let location: String
    
    public init(temperature: Int, location: String) {
        self.temperature = temperature
        self.location = location
    }
}
