//
//  WeatherCardContainer.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

struct WeatherCardContainer<Content: View>: View {
    let content: Content
    
    // Environment values for responsive design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(adaptivePadding)
            .background(
                RoundedRectangle(cornerRadius: adaptiveCornerRadius)
                    .fill(cardBackgroundColor)
                    .shadow(color: .black.opacity(0.1), radius: adaptiveShadowRadius, x: 0, y: 4)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: horizontalSizeClass)
            .animation(.easeInOut(duration: 0.3), value: verticalSizeClass)
    }
    
    // MARK: - Adaptive Properties
    
    private var adaptivePadding: CGFloat {
        if isTablet {
            return 32 // Larger padding for tablets
        } else if isLandscapePhone {
            return 20 // Medium padding for landscape phones
        } else {
            return 24 // Standard padding for portrait phones
        }
    }
    
    private var adaptiveCornerRadius: CGFloat {
        if isTablet {
            return 20 // Larger corner radius for tablets
        } else {
            return 16 // Standard corner radius for phones
        }
    }
    
    private var adaptiveShadowRadius: CGFloat {
        if isTablet {
            return 12 // Larger shadow for tablets
        } else {
            return 8 // Standard shadow for phones
        }
    }
    
    // MARK: - Layout Computations
    
    private var isTablet: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var isLandscapePhone: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .compact
    }
    
    // Cross-platform background color
    private var cardBackgroundColor: Color {
        Color.appSurface
    }
}

// MARK: - Previews

#Preview("Phone Portrait") {
    WeatherCardContainer {
        VStack {
            Text("Sample Content")
                .font(.title)
        }
    }
    .padding()
    .background(previewBackgroundColor)
    .environment(\.horizontalSizeClass, .compact)
    .environment(\.verticalSizeClass, .regular)
}

#Preview("Phone Landscape") {
    WeatherCardContainer {
        VStack {
            Text("Sample Content")
                .font(.title)
        }
    }
    .padding()
    .background(previewBackgroundColor)
    .environment(\.horizontalSizeClass, .compact)
    .environment(\.verticalSizeClass, .compact)
}

#Preview("Tablet") {
    WeatherCardContainer {
        VStack {
            Text("Sample Content")
                .font(.title)
        }
    }
    .padding()
    .background(previewBackgroundColor)
    .environment(\.horizontalSizeClass, .regular)
    .environment(\.verticalSizeClass, .regular)
}

// Cross-platform preview background
private var previewBackgroundColor: Color { Color.appSurfaceGrouped }
