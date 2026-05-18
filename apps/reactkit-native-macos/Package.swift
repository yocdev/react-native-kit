// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ReactNativeKit",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ReactNativeKit", targets: ["reactkit"])
    ],
    targets: [
        .executableTarget(
            name: "reactkit"
        )
    ]
)
