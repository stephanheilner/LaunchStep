// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LaunchStep",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "LaunchStep",
            targets: ["LaunchStep"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LaunchStep",
            dependencies: [],
            path: "Sources/LaunchStep",
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "LaunchStepTests",
            dependencies: ["LaunchStep"]),
    ]
)
