#!/bin/bash

echo "🔄 Regenerating Xcode project..."

# Remove old project files
rm -rf WeatherApp.xcodeproj
rm -rf WeatherApp.xcworkspace

# Generate new project
xcodegen generate

echo "✅ Project regenerated successfully!"
echo "📱 You can now open WeatherApp.xcodeproj in Xcode"
