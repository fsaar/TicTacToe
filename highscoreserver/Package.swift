// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "highscoreserver",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "1.7.9"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git",from: "1.8.3"),
        
    ],
    targets: [
        .target(
            name: "highscoreserver",
            dependencies: ["Kitura","HeliumLogger","KituraStencil"]),
    ]
)
