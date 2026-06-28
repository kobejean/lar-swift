// swift-tools-version:5.9
// Standalone prototype: direct Swift/C++ interop for the LARGPSObservation
// value type, demonstrating the "narrow C++ facade" pattern that replaces the
// Objective-C++ bridge. Self-contained — builds with only a Swift 5.9+
// toolchain (no Eigen / OpenCV / xcframeworks).
import PackageDescription

let package = Package(
    name: "CxxInteropGPS",
    platforms: [.macOS(.v12), .iOS(.v14)],
    products: [
        .library(name: "LARGPSInterop", targets: ["LARGPSInterop"]),
    ],
    targets: [
        // C++ facade: exposes a template-free POD view of GPSObservation.
        // In the real package this is the seam where Eigen::Vector3d is
        // flattened into plain doubles — Eigen never crosses into Swift.
        .target(
            name: "LARGPSFacade",
            cxxSettings: [.unsafeFlags(["-std=c++17"])]
        ),
        // Swift target consuming the facade via direct C++ interop.
        .target(
            name: "LARGPSInterop",
            dependencies: ["LARGPSFacade"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        // Note: the test target does NOT enable C++ interop — LARGPSInterop's
        // public API is pure Swift (no C++ types leak out), proving the wrapper
        // fully encapsulates the interop boundary.
        .testTarget(
            name: "LARGPSInteropTests",
            dependencies: ["LARGPSInterop"]
        ),
    ]
)
