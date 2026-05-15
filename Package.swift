// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Segmentify",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Segmentify",
            targets: ["Segmentify"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Segmentify",
            path: "Sources/segmentify",
            resources: [
                .copy("version")
            ],
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "SegmentifyTests",
            dependencies: ["Segmentify"],
            path: "Tests"
        )
    ]
)
