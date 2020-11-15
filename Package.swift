// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CoreLocationCombine",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "CoreLocationCombine", targets: ["CoreLocationCombine"]),
    ],
    targets: [
        .target(name: "CoreLocationCombine"),
        .testTarget(name: "CoreLocationCombineTests", dependencies: ["CoreLocationCombine"]),
    ]
)
