# Prototype: direct Swift/C++ interop for `LARGPSObservation`

A self-contained spike evaluating whether direct Swift/C++ interoperability can
replace the Objective-C++ bridge, using `LARGPSObservation` as the pilot value
type. It builds with **only a Swift 5.9+ toolchain** — no Eigen, OpenCV, or
xcframeworks — so you get a fast build-time / ergonomics read without the full
macOS app build.

## Run it

```bash
# macOS (matches project convention — Apple Clang):
export CC=$(xcrun --find clang)
export CXX=$(xcrun --find clang++)
cd Experiments/CxxInteropGPS
swift test

# Linux: any Swift 5.9+ toolchain, `swift test`
```

> Not built in this session: the dev box is Linux with no Swift toolchain
> installed, and the main package needs Apple frameworks. Files are written to
> compile under Swift 5.9+; please run the command above to confirm locally.

## The pattern

The blocker for direct interop is that `lar::GPSObservation` stores
`Eigen::Vector3d` members, and Swift cannot import heavily-templated types like
Eigen (class templates aren't surfaced; only instantiated specializations).
The officially-implied workaround is a **narrow C++ facade** that exposes a
template-free POD struct; Eigen stays entirely on the C++ side.

```
lar::GPSObservation (Eigen)  ──►  lardemo::GPSObservation (POD, facade)  ──►  Swift GPSObservation (SIMD3)
        C++ only                       C++ header, no Eigen                      pure Swift value type
```

- `Sources/LARGPSFacade/` — C++ target. Template-free POD header + impl.
- `Sources/LARGPSInterop/` — Swift target, `interoperabilityMode(.Cxx)`. Wraps
  the facade into a native `GPSObservation` and an array accessor.
- `Tests/` — exercises the bridge. Crucially the test target does **not** enable
  interop, proving the C++ boundary is fully hidden behind the Swift API.

## Ergonomics: before vs after

**Today (Objective-C++)** — two files, a stored `lar::GPSObservation*`, one
Objective-C getter per field doing the Eigen→simd unpack, plus a manual
`NSMutableArray` loop in `LARMapperData`:

```objc
// LARGPSObservation.mm
- (simd_double3)relative {
    Eigen::Vector3d relative = self->_internal->relative;
    return simd_make_double3(relative.x(), relative.y(), relative.z());
}
// ...repeated for `global`; plus a 9-line NSMutableArray loop in LARMapperData.mm
```

**Direct interop** — the POD struct imports automatically (no per-field getter),
and the collection bridge is one line:

```swift
init(_ c: lardemo.GPSObservation) {           // C++ struct imported as-is
    self.relative = SIMD3(c.relative.x, c.relative.y, c.relative.z)
    // ...
}
public func demoGPSObservations() -> [GPSObservation] {
    lardemo.demo_observations().map(GPSObservation.init)   // std::vector is a Collection
}
```

Net: the `.mm` getter class and the hand-rolled `NSMutableArray` loop both
disappear. The remaining hand-written code is the same Eigen→POD unpack, but it
now lives once in the facade instead of being spread across Objective-C getters.

## Findings (fill in after running locally)

- [ ] `swift test` passes
- [ ] Clean-build time for the two targets: ____
- [ ] Does `std::vector<lardemo::GPSObservation>` import cleanly, or need
      `import CxxStdlib` only / a C-style `count`+`at` fallback? ____
- [ ] Any toolchain warnings about the POD import / namespace handling? ____

## Grafting onto the real `lar::GPSObservation`

To validate against live data inside the main package (macOS build), add a
facade target that depends on `LocalizeAR_CPP` and reads the real type:

```cpp
// Sources/LARGPSFacade/include/LARGPSFacade.h  (real version)
#include <vector>
namespace larbridge {
struct Vec3 { double x, y, z; };
struct GPSObservation { long long timestamp; Vec3 relative, global, accuracy; };
std::vector<GPSObservation> gpsObservations(const void* mapperData); // takes Mapper::Data*
}
```

```cpp
// .cpp — Eigen confined here
#include <lar/mapping/mapper.h>
static larbridge::Vec3 conv(const Eigen::Vector3d& v) { return {v.x(), v.y(), v.z()}; }
std::vector<larbridge::GPSObservation> larbridge::gpsObservations(const void* p) {
    auto* data = static_cast<const lar::Mapper::Data*>(p);
    std::vector<larbridge::GPSObservation> out;
    for (const auto& o : data->gps_obs)
        out.push_back({o.timestamp, conv(o.relative), conv(o.global), conv(o.accuracy)});
    return out;
}
```

Package.swift — new C++ target + interop on the Swift consumer:

```swift
.target(name: "LARGPSFacade", dependencies: ["LocalizeAR_CPP"], cxxSettings: cxxSettings),
.target(name: "LocalizeAR", dependencies: [..., "LARGPSFacade"],
        swiftSettings: [.interoperabilityMode(.Cxx)]),
```

Caveat to watch: enabling `.interoperabilityMode(.Cxx)` on `LocalizeAR`
propagates the requirement to its dependents, and the `LocalizeAR_CPP` umbrella
must stay parseable as C++ from Swift (the existing
`-Wno-incomplete-umbrella` hints it's already touchy). Keep the facade as a
**separate** target with a minimal header to avoid dragging the full Eigen/OpenCV
header graph through the Swift importer.
