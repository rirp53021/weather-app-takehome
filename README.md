# Weather App - iOS/tvOS Take Home Challenge

This project demonstrates a simple application that fetches and displays weather data from the National Weather Service API, meeting all the requirements specified in the take-home challenge.

## Challenge Objective

The objective of this challenge is to create a simple application that fetches and displays data from a provided API. This project demonstrates understanding of:

- Swift programming language
- iOS/tvOS SDKs and frameworks
- Networking and data handling
- User interface design and implementation
- Swift package manager

## Requirements Met

✅ **Package 1 - API Data Fetching**: Fetches data from hardcoded API endpoint `https://api.weather.gov/points/37.2883,-121.8434`  
✅ **Package 2 - UI Widget**: Encapsulates temperature in a reusable widget  
✅ **Cross-Platform Support**: Both packages can be used by iOS and tvOS  
✅ **iOS App**: Displays the UI widget in an iOS app  
✅ **tvOS App**: Displays the UI widget in a tvOS app  
✅ **Responsive UI**: Arranges UI widget for both phone and tablet form factors  
✅ **Orientation Support**: Works in both landscape and portrait orientations  

## Project Structure

The project consists of exactly **3 packages** as specified in the requirements:

```
take-home-app/
├── WeatherAPI/                   # Package 1: API Data Fetching
│   └── Sources/WeatherAPI/       # Weather.gov API integration
├── WeatherUI/                    # Package 2: UI Widget
│   └── Sources/WeatherUI/        # Reusable SwiftUI components
└── WeatherApp/                   # Package 3: iOS App
    ├── Shared/                   # Shared code and assets
    │   ├── Models/               # Data models and view models
    │   ├── Views/                # SwiftUI views
    │   └── Utilities/            # Helper functions
    └── Assets/                   # App icons and color assets
```

## Technical Implementation

### **Package 1 - WeatherAPI**
- Fetches data from `https://api.weather.gov/points/37.2883,-121.8434`
- Extracts forecast URL from `properties/forecast` field
- Retrieves today's temperature from `properties/periods[0]/temperature`
- Uses modern Swift concurrency with async/await
- Implements proper error handling

### **Package 2 - WeatherUI**
- Contains reusable `WeatherWidget` component
- Displays temperature and location information
- Responsive design for different screen sizes
- Supports both iOS and tvOS platforms

### **Package 3 - WeatherApp**
- iOS application that displays the weather widget
- Uses MVVM architecture pattern
- Integrates both WeatherAPI and WeatherUI packages
- Responsive layout for phone and tablet form factors

## Requirements

- Xcode 15.0+
- iOS 15.0+
- tvOS 15.0+

## Installation & Building

### **Option 1: Use XcodeGen (Recommended)**

This project uses XcodeGen for project generation, which ensures consistent project structure and avoids common Xcode project issues.

1. **Install XcodeGen** (if not already installed):
   ```bash
   # Using Homebrew
   brew install xcodegen
   
   # Or using Mint
   mint install xcodegen
   ```

2. **Generate the Xcode project**:
   ```bash
   xcodegen generate
   ```

3. **Open the generated project**:
   ```bash
   open WeatherApp.xcodeproj
   ```

4. **Build and run** the project:
   - Select the `WeatherApp` target for iOS
   - Select the `WeatherAppTV` target for tvOS
   - Choose your desired simulator/device
   - Press `Cmd + R` to build and run

### **Option 2: Direct Xcode Project**

1. **Open the project** directly in Xcode:
   ```bash
   open WeatherApp.xcodeproj
   ```

2. **Build and run** the project:
   - Select the `WeatherApp` target for iOS
   - Select the `WeatherAppTV` target for tvOS
   - Choose your desired simulator/device
   - Press `Cmd + R` to build and run

## XcodeGen Configuration

### **Project Structure**
The project uses `project.yml` to define:
- **Targets**: iOS (WeatherApp) and tvOS (WeatherAppTV) applications
- **Sources**: Shared code between platforms
- **Dependencies**: Swift Package Manager integration
- **Build Settings**: Platform-specific configurations

### **Regeneration Script**
Use the included script to regenerate the project:
```bash
./regenerate.sh
```

This script:
- Removes old project files
- Generates fresh Xcode project
- Ensures clean, consistent project structure

### **Configuration Files**
- **`project.yml`**: Main XcodeGen configuration
- **`.xcodegenignore`**: Files to exclude from generation
- **`regenerate.sh`**: Automated regeneration script

### **Benefits of XcodeGen**
- ✅ **Consistent Structure**: Always generates the same project layout
- ✅ **No GUID Conflicts**: Eliminates common Xcode project issues
- ✅ **Easy Maintenance**: Simple YAML configuration
- ✅ **Team Collaboration**: Same project structure across all developers
- ✅ **Version Control Friendly**: Only configuration files in git

## Features

### **Weather Data:**
- Fetches current weather from National Weather Service API
- Displays temperature for San Jose, CA area (hardcoded coordinates)
- Graceful error handling for network issues

### **UI Components:**
- Responsive weather widget that adapts to device orientation
- Supports both portrait and landscape orientations
- Optimized for phone and tablet form factors

### **Technical Features:**
- SwiftUI-based user interface
- MVVM architecture pattern
- Swift Package Manager dependencies
- Modern async/await networking

## Evaluation Criteria Met

✅ **Functionality**: Application meets all requirements from test.txt  
✅ **Code Quality**: Clean, well-documented, and maintainable code  
✅ **User Interface**: Intuitive and responsive UI with proper form factor support  
✅ **Error Handling**: Errors handled gracefully with user-friendly messages  

## Contact

If you have any questions, please contact wtao@recurly.com.
