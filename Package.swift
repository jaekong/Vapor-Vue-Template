// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "<PackageName>",
    products: [
        .library(name: "<PackageName>", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        // .package(url: "https://github.com/swift-aws/aws-sdk-swift.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Leaf", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
    ]
)
