// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalAR",
    platforms: [
        .macOS(.v10_15), .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LocalAR",
            targets: ["LocalAR"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "0.0.3")
        ),
        .package(
            url: "https://github.com/phlegmaticprogrammer/LANumerics.git",
            .upToNextMajor(from: "0.1.12")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "Mapper",
            dependencies: ["LocalAR"],
            path: "Sources/Mapper"),
        .target(
            name: "LocalAR",
            dependencies: [
                .target(name: "LocalARObjC"),
                .target(name: "GeoARExtra", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/Swift"
        ),
        .target(
            name: "GeoARExtra",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "LANumerics", package: "LANumerics"),
                .target(name: "LocalARObjC"),
                .target(name: "opencv2")
            ],
            path: "Sources/Extra"
        ),
        
        .target(
            name: "LocalARObjC",
            dependencies: ["geoar", "g2o", "opencv2"],
            path: "Sources/Objective-C",
            cxxSettings: [
                // Include header only libraries
                .headerSearchPath("../External/Headers/"),
                .define("G2O_USE_VENDORED_CERES"),
                .unsafeFlags(["-std=c++17"])
            ],
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedFramework("Accelerate"),
                .linkedFramework("ARKit", .when(platforms: [.iOS])),
                .linkedFramework("OpenCL", .when(platforms: [.macOS]))
            ]
        ),
        // Uncoment below if working with local frameworks
//        .binaryTarget(name: "geoar", path: "Frameworks/geoar.xcframework"),
//        .binaryTarget(name: "g2o", path: "Frameworks/g2o.xcframework"),
//        .binaryTarget(name: "opencv2", path: "Frameworks/opencv2.xcframework"),
        
        // Recompute checksum via:
        // `swift package --package-path /path/to/package compute-checksum *.xcframework.zip`
        .binaryTarget(
            name: "geoar",
            url: "https://github.com/kobejean/GeoARCore/releases/download/v0.1.0/geoar.xcframework.zip",
            checksum: "34a2458b98737346dd213677d7edb395b74b73464950a0e326a5a15bd7763f35"
        ),
        .binaryTarget(
            name: "g2o",
            url: "https://github.com/kobejean/GeoARCore/releases/download/v0.1.0/g2o.xcframework.zip",
            checksum: "94f7054f14cfeb99d32336af28596e5bbc731ed803539ac97f91e0ae5ebe1f81"
        ),
        .binaryTarget(
            name: "opencv2",
            url: "https://github.com/kobejean/GeoARCore/releases/download/v0.1.0/opencv2.xcframework.zip",
            checksum: "543e3341c053057f3e218c62f149e31b7d8175f4d3cdb648c6a51bf9ffab0737"
        ),
        
        .testTarget(
            name: "GeoARExtraTests",
            dependencies: ["LocalAR"]
        )
    ]
)
