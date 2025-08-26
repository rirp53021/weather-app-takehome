//
//  WeatherLoadingView.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

struct WeatherLoadingView: View {
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .scaleEffect(1.5)
        }
    }
}

#Preview("Loading State") {
    WeatherLoadingView()
        .padding()
        .background(previewBackgroundColor)
}

// Cross-platform preview background
private var previewBackgroundColor: Color { Color.appSurfaceGrouped }
