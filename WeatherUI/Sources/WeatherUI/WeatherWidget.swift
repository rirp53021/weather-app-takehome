//
//  WeatherWidget.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

public struct WeatherWidget: View {
    
    // MARK: - UI State Enum
    public enum UIState: Equatable {
        case loading
        case error(String)
        case content(temperature: Int, location: String)
    }
    
    // MARK: - Properties
    private let state: UIState
    
    // Environment values for responsive design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // MARK: - Initializer
    public init(state: UIState) {
        self.state = state
    }
    
    // MARK: - Body
    public var body: some View {
        WeatherCardContainer {
            switch state {
            case .loading:
                WeatherLoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .error(let message):
                WeatherErrorView(errorMessage: message)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .content(let temperature, let location):
                WeatherContentView(
                    temperature: temperature,
                    location: location
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(
            maxWidth: adaptiveMaxWidth,
            maxHeight: adaptiveMaxHeight
        )
        .animation(.easeInOut(duration: 0.3), value: horizontalSizeClass)
        .animation(.easeInOut(duration: 0.3), value: verticalSizeClass)
    }
    
    // MARK: - Adaptive Sizing
    
    private var adaptiveMaxWidth: CGFloat? {
        if isTablet {
            return 600 // Constrain width on tablets for better readability
        } else if isLandscapePhone {
            return 500 // Constrain width on landscape phones
        } else {
            return nil // Full width on portrait phones
        }
    }
    
    private var adaptiveMaxHeight: CGFloat? {
        if isTablet {
            return 400 // Constrain height on tablets
        } else if isLandscapePhone {
            return 200 // Constrain height on landscape phones
        } else {
            return nil // Full height on portrait phones
        }
    }
    
    // MARK: - Layout Computations
    
    private var isCompactLayout: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
    
    private var isLandscapePhone: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .compact
    }
    
    private var isTablet: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
}

// MARK: - Previews

#Preview("Normal State - Phone Portrait") {
    WeatherWidget(state: .content(temperature: 72, location: "San Jose, CA"))
        .padding()
        .background(previewBackgroundColor)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("Normal State - Phone Landscape") {
    WeatherWidget(state: .content(temperature: 72, location: "San Jose, CA"))
        .padding()
        .background(previewBackgroundColor)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
}

#Preview("Normal State - Tablet") {
    WeatherWidget(state: .content(temperature: 72, location: "San Jose, CA"))
        .padding()
        .background(previewBackgroundColor)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("Loading State") {
    WeatherWidget(state: .loading)
        .padding()
        .background(previewBackgroundColor)
}

#Preview("Error State") {
    WeatherWidget(state: .error("Unable to fetch weather data"))
        .padding()
        .background(previewBackgroundColor)
}

// Cross-platform preview background
private var previewBackgroundColor: Color { Color.appSurfaceGrouped }
