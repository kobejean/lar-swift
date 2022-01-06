// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GeoAR",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GeoAR",
            targets: ["GeoAR"]),
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
            dependencies: ["GeoAR"],
            path: "Sources/Mapper"),
        .target(
            name: "GeoAR",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "LANumerics", package: "LANumerics"),
                .target(name: "GeoARObjC"),
                .target(name: "opencv2")
            ],
            path: "Sources/Swift"),
        
        .target(
            name: "GeoARObjC",
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
            url: "https://github.com/kobejean/GeoARCore/releases/download/v1.0.0-alpha.0/geoar.xcframework.zip",
            checksum: "2f07698faa79abe0ca3332840013e15f9b43d58e8447425c824ddb9b9c610a1a"
        ),
        .binaryTarget(
            name: "g2o",
            url: "https://github.com/kobejean/GeoARCore/releases/download/v1.0.0-alpha.0/g2o.xcframework.zip",
            checksum: "c7d2cfe60242aeba87fe1c1521a086b71cbe962fb14f070d00b6a56b177db396"
        ),
        .binaryTarget(
            name: "opencv2",
            url: "https://github.com/kobejean/GeoARCore/releases/download/v1.0.0-alpha.0/opencv2.xcframework.zip",
            checksum: "543e3341c053057f3e218c62f149e31b7d8175f4d3cdb648c6a51bf9ffab0737"
        ),
        
        .testTarget(
            name: "GeoARTests",
            dependencies: ["GeoAR"]
        ),
    ]
)
