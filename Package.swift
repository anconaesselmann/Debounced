// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Debounced",
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Debounced",
            targets: ["Debounced"]),
    ],
    targets: [
        .target(
            name: "Debounced"),
        .testTarget(
            name: "DebouncedTests",
            dependencies: ["Debounced"]),
    ]
)
