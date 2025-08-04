// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyRres",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftyRres",
            targets: ["SwiftyRres"]),
    ],
    targets: [
        .target(
            name: "RresC",
            sources: ["rres_impl.c"],
            publicHeadersPath: "rres/src",
            cSettings: [
                .define("RRES_IMPLEMENTATION"),
                .headerSearchPath("rres/src")
            ]
        ),
        .target(
            name: "SwiftyRres",
            dependencies: ["RresC"],
            sources: ["SwiftyRres.swift", "RresDataUtils.swift"]
        ),
        .testTarget(
            name: "SwiftyRresTests",
            dependencies: ["SwiftyRres"]),
    ]
) 