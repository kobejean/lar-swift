// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let cxxSettings: [CXXSetting] = [
    // Include header only libraries
    .headerSearchPath("../External/Headers/"),
    .define("G2O_USE_VENDORED_CERES"),
    .unsafeFlags(["-std=c++17"])
]

let package = Package(
    name: "LocalizeAR",
    platforms: [
		.macOS(.v12), .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LocalizeAR",
            targets: ["LocalizeAR"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LocalizeAR",
            dependencies: [
                .target(name: "LocalizeAR_ObjC"),
                .product(name: "Swinject", package: "Swinject")
            ],
            path: "Sources/LocalizeAR",
            cxxSettings: [.unsafeFlags(["-Wno-incomplete-umbrella"])],
        ),
        .target(
            name: "LocalizeAR_CPP",
            dependencies: ["g2o", "opencv2"],
            path: "Sources/LocalizeAR-CPP",
            cxxSettings: cxxSettings,
            linkerSettings: [
				.linkedLibrary("c++"),
				.linkedLibrary("sqlite3"),
				.linkedLibrary("z"),
				.linkedFramework("Metal"),
				.linkedFramework("MetalPerformanceShaders"),
			]
        ),
        .target(
            name: "LocalizeAR_ObjC",
            dependencies: ["LocalizeAR_CPP"],
            path: "Sources/LocalizeAR-ObjC",
            cxxSettings: cxxSettings,
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedFramework("Accelerate"),
                .linkedFramework("ARKit", .when(platforms: [.iOS])),
                .linkedFramework("OpenCL", .when(platforms: [.macOS]))
            ]
        ),
        // Uncoment below if working with local frameworks
//        .binaryTarget(name: "lar", path: "Frameworks/lar.xcframework"),
    //    .binaryTarget(name: "g2o", path: "Frameworks/g2o.xcframework"),
        .binaryTarget(name: "opencv2", path: "Frameworks/opencv2.xcframework"),
        
        // Recompute checksum via:
        // `swift package --package-path /path/to/package compute-checksum *.xcframework.zip`
//        .binaryTarget(
//            name: "lar",
//            url: "https://github.com/kobejean/lar/releases/download/v0.9.0/lar.xcframework.zip",
//            checksum: "e0637b4089b5607e0aa0b4f6f3d496b83eab2b6b7fe85b717f0504b6d058e1a2"
//        ),
        .binaryTarget(
            name: "g2o",
            url: "https://github.com/kobejean/lar/releases/download/v0.10.0/g2o.xcframework.zip",
            checksum: "428b53efb2fb6cea954f129fe7e56cb44915ee6bc670859d6398e1ee80f3849c"
        ),
//        .binaryTarget(
//            name: "opencv2",
//            url: "https://github.com/kobejean/lar/releases/download/v0.10.0/opencv2.xcframework.zip",
//            checksum: "a095d6664510a0548cb4edcc8eec1097cf03e41b8ae6d6995c2c8c64ab1deb8e"
//        ),

        .testTarget(
            name: "LocalizeARTests",
            dependencies: ["LocalizeAR"],
            path: "Tests/LocalizeARTests"
        )
    ]
)
