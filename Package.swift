// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bivouac",
    platforms: [.macOS(.v12),
                .iOS(.v13)],
    products: [
        .library(
            name: "Bivouac",
            targets: ["Bivouac"]),
    ],
    dependencies: [
        .package(url: "git@github.com:nicklockwood/Euclid.git", branch: "main"),
        .package(url: "git@github.com:pointfreeco/swift-dependencies.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Bivouac",
            dependencies: ["Euclid",
                           .product(name: "Dependencies",
                                    package: "swift-dependencies")],
            resources: [.process("Shaders/")]),
        .testTarget(
            name: "BivouacTests",
            dependencies: ["Bivouac"]),
    ]
)
