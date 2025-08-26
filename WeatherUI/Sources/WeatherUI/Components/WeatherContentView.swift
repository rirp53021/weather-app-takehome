//
//  WeatherContentView.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

struct WeatherContentView: View {
    let temperature: Int
    let location: String
    
    // Environment values for responsive design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        Group {
            if isCompactLayout {
                // Compact layout for phones in portrait
                compactLayout
            } else if isLandscapePhone {
                // Landscape layout for phones
                landscapePhoneLayout
            } else {
                // Regular layout for tablets and larger screens
                regularLayout
            }
        }
        .animation(.easeInOut(duration: 0.3), value: horizontalSizeClass)
        .animation(.easeInOut(duration: 0.3), value: verticalSizeClass)
    }
    
    // MARK: - Layout Computations
    
    private var isCompactLayout: Bool {
        // Portrait phone: horizontal compact, vertical regular
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
    
    private var isLandscapePhone: Bool {
        // Landscape phone: horizontal compact, vertical compact (both compact)
        horizontalSizeClass == .compact && verticalSizeClass == .compact
    }
    
    private var isTablet: Bool {
        // Tablet: horizontal regular, vertical regular (both regular)
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    // Additional orientation detection
    private var isPortrait: Bool {
        // Portrait: vertical size class is regular (taller than wide)
        verticalSizeClass == .regular
    }
    
    private var isLandscape: Bool {
        // Landscape: vertical size class is compact (wider than tall)
        verticalSizeClass == .compact
    }
    
    private var selectedLayoutName: String {
        if isCompactLayout {
            return "Compact (Phone Portrait)"
        } else if isLandscapePhone {
            return "Landscape (Phone Landscape)"
        } else if isTablet {
            return "Regular (Tablet)"
        } else {
            return "Unknown Layout"
        }
    }
    
    // MARK: - Layout Variants
    
    // Compact layout for phones in portrait
    private var compactLayout: some View {
        VStack(spacing: 16) {
            // Location at top
            Text(location)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.center)
            
            // Temperature in center
            HStack(alignment: .top, spacing: 4) {
                Text("\(temperature)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appTextPrimary)
                
                Text("°F")
                    .font(.title)
                    .foregroundColor(Color.appTextSecondary)
                    .padding(.top, 12)
            }
            
            // Weather icon or additional info
            Image(systemName: weatherIconName)
                .font(.system(size: 32))
                .foregroundColor(Color.appPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20) // Added padding for better spacing
        .background(Color.appSurface)
    }
    
    // Landscape layout for phones
    private var landscapePhoneLayout: some View {
        HStack(spacing: 20) {
            // Left side - Location and icon
            VStack(alignment: .leading, spacing: 12) {
                Text(location)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.appTextPrimary)
                
                Image(systemName: weatherIconName)
                    .font(.system(size: 28))
                    .foregroundColor(Color.appPrimary)
            }
            
            Spacer()
            
            // Right side - Temperature
            HStack(alignment: .top, spacing: 4) {
                Text("\(temperature)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appTextPrimary)
                
                Text("°F")
                    .font(.title2)
                    .foregroundColor(Color.appTextSecondary)
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20) // Added padding for better spacing
        .background(Color.appSurface)
    }
    
    // Regular layout for tablets and larger screens
    private var regularLayout: some View {
        VStack(spacing: 24) {
            // Top section - Location
            Text(location)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.appTextPrimary)
                .multilineTextAlignment(.center)
            
            // Center section - Temperature and icon
            HStack(spacing: 20) {
                Image(systemName: weatherIconName)
                    .font(.system(size: 48))
                    .foregroundColor(Color.appPrimary)
                
                HStack(alignment: .top, spacing: 6) {
                    Text("\(temperature)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(Color.appTextPrimary)
                    
                    Text("°F")
                        .font(.largeTitle)
                        .foregroundColor(Color.appTextSecondary)
                        .padding(.top, 16)
                }
            }
            
            // Bottom section - Additional weather info (placeholder)
            HStack(spacing: 16) {
                WeatherInfoItem(icon: "thermometer", label: "Feels like", value: "\(temperature)°")
                WeatherInfoItem(icon: "humidity", label: "Humidity", value: "65%")
                WeatherInfoItem(icon: "wind", label: "Wind", value: "8 mph")
                .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20) // Added padding for better spacing
        .background(Color.appSurface)
    }
    
    // MARK: - Helper Views
    
    private var weatherIconName: String {
        // Simple temperature-based icon selection
        if temperature >= 80 {
            return "sun.max.fill"
        } else if temperature >= 60 {
            return "cloud.sun.fill"
        } else if temperature >= 40 {
            return "cloud.fill"
        } else {
            return "cloud.snow.fill"
        }
    }
}

// MARK: - Previews

#Preview("Compact Layout (Phone Portrait)") {
    WeatherContentView(temperature: 72, location: "San Jose, CA")
        .padding()
        .background(previewBackgroundColor)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("Landscape Layout (Phone Landscape)") {
    WeatherContentView(temperature: 72, location: "San Jose, CA")
        .padding()
        .background(previewBackgroundColor)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
}

#Preview("Regular Layout (Tablet)") {
    WeatherContentView(temperature: 72, location: "San Jose, CA")
        .padding()
        .background(previewBackgroundColor)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("Large Dynamic Type") {
    WeatherContentView(temperature: 72, location: "San Jose, CA")
        .padding()
        .background(previewBackgroundColor)
        .environment(\.dynamicTypeSize, .accessibility3)
}

// Cross-platform preview background
private var previewBackgroundColor: Color {
    #if os(iOS)
    return Color.appSurfaceGrouped
    #elseif os(tvOS)
    return Color.primary.opacity(0.05)
    #else
    return Color.primary.opacity(0.05) // Default fallback
    #endif
}
