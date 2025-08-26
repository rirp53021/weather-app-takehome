//
//  WeatherErrorView.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

struct WeatherErrorView: View {
    let errorMessage: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundColor(Color.appAccent)
            
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(Color.appTextSecondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview("Error State") {
    WeatherErrorView(errorMessage: "Unable to fetch weather data")
        .padding()
        .background(previewBackgroundColor)
}

// Cross-platform preview background
private var previewBackgroundColor: Color { Color.appSurfaceGrouped }
