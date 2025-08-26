// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherUI",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "WeatherUI",
            targets: ["WeatherUI"]),
    ],
    dependencies: [
        .package(path: "../WeatherAPI"),
    ],
    targets: [
        .target(
            name: "WeatherUI",
            dependencies: ["WeatherAPI"]),
        .testTarget(
            name: "WeatherUITests",
            dependencies: ["WeatherUI"]),
    ]
)
