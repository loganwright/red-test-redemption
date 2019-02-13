// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporApp",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .branch("master")),
        
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "FluentPostgreSQL", 
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)