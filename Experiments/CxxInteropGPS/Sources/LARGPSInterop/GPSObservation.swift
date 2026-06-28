//
//  GPSObservation.swift
//
//  Direct-interop replacement for the Objective-C++ `LARGPSObservation`.
//
import CxxStdlib
import LARGPSFacade

/// Swift-native value type. Mirrors the public surface of the existing
/// Objective-C++ `LARGPSObservation` (timestamp + simd_double3 fields) so the
/// two can be compared directly. Note it exposes NO C++ types — the interop
/// boundary is fully encapsulated, so downstream code needs no `-cxx-interop`.
public struct GPSObservation: Equatable {
    public let timestamp: Int64
    public let relative: SIMD3<Double>
    public let global: SIMD3<Double>
    public let accuracy: SIMD3<Double>
}

extension GPSObservation {
    /// Bridge one C++ POD observation into the Swift value type.
    /// `lardemo.GPSObservation` is the C++ struct, imported automatically.
    init(_ c: lardemo.GPSObservation) {
        self.timestamp = c.timestamp
        self.relative = SIMD3(c.relative.x, c.relative.y, c.relative.z)
        self.global = SIMD3(c.global.x, c.global.y, c.global.z)
        self.accuracy = SIMD3(c.accuracy.x, c.accuracy.y, c.accuracy.z)
    }
}

/// Direct-interop equivalent of `LARMapperData.gpsObservations`.
///
/// Compare with the Objective-C++ version, which hand-rolls an NSMutableArray
/// loop and a per-field getter class. Here the std::vector is a Swift
/// Collection and `.map` produces a native `[GPSObservation]` in one line.
public func demoGPSObservations() -> [GPSObservation] {
    // `.map` makes exactly one copy into native Swift storage; after it returns
    // no C++ memory is referenced. (Iterating a std::vector with `for-in` can
    // deep-copy per the interop docs — `.map` into a value type sidesteps that
    // as a hot-path concern.)
    lardemo.demo_observations().map(GPSObservation.init)
}
