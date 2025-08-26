//
//  ViewExtensions.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

// MARK: - View Extensions
public extension View {
    func appButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(height: 50)
            .background(Color.appAccent)
            .cornerRadius(AppSpacing.md)
    }
}
