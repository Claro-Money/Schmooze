// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Schmooze",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Schmooze",
            targets: ["Schmooze"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manGoweb/Presentables.git", from: "1.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1")
    ],
    targets: [
        .target(
            name: "Schmooze",
            dependencies: [
                "SnapKit",
                "Presentables"
            ]),
        .testTarget(
            name: "SchmoozeTests",
            dependencies: ["Schmooze"]),
    ]
)
