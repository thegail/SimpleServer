// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleServer",
	platforms: [
		.macOS(.v10_14)
	],
    products: [
        .library(
            name: "SimpleServer",
            targets: ["SimpleServer"]),
    ],
    dependencies: [
		
	],
    targets: [
        .target(
            name: "SimpleServer",
            dependencies: [])
    ]
)
