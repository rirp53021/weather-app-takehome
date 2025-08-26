//
//  WeatherInfoItem.swift
//  WeatherUI
//
//  Created by Pedro Ferreira on 26/08/25.
//

import SwiftUI

// MARK: - Weather Info Item Component
public struct WeatherInfoItem: View {
    let icon: String
    let label: String
    let value: String
    
    public init(icon: String, label: String, value: String) {
        self.icon = icon
        self.label = label
        self.value = value
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.appSurface)
        .cornerRadius(8)
    }
}

// MARK: - Previews
#Preview {
    WeatherInfoItem(icon: "thermometer", label: "Feels like", value: "72°")
        .padding()
        .background(Color.appSurfaceGrouped)
}
