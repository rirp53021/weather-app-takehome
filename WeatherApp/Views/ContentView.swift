//
//  ContentView.swift
//  WeatherApp
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI
import WeatherUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                WeatherWidget(state: viewModel.uiState)
                    .padding()
                
                Button("Refresh Weather") {
                    Task {
                        await viewModel.fetchWeather()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Weather App")
            .task {
                await viewModel.fetchWeather()
            }
        }
    }
}

#Preview {
    ContentView()
}
