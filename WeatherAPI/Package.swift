// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherAPI",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "WeatherAPI",
            targets: ["WeatherAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WeatherAPI",
            dependencies: []),
        .testTarget(
            name: "WeatherAPITests",
            dependencies: ["WeatherAPI"]),
    ]
)
