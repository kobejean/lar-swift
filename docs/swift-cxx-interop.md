# Swift/C++ interop: evaluation & prototype

Investigation into whether direct Swift/C++ interoperability can replace the
Objective-C++ bridge in this project. Includes a runnable prototype on
`LARGPSObservation`.

## TL;DR

**Not ready as a wholesale replacement for the `.mm` bridge** — for the exact
reason the bridge exists. It wraps Eigen/OpenCV template-heavy types behind a
flat `simd`/POD boundary, which is the officially-implied best practice for
heavily-templated C++ libraries. Direct interop would delete that insulation
layer and expose us to template-import limits, source churn across Swift
releases, and silent deep-copies in loops.

**Worth adopting incrementally** behind clean, template-free signatures:
- New C++ APIs whose signatures are POD / `simd` / `std::`-only (no Eigen/OpenCV)
  — skip the `.mm` wrapper entirely.
- Narrow C++ *facade* headers that pre-instantiate the few specializations we
  need, imported directly — retiring `.mm` files one subsystem at a time.

## Why (state of the feature, mid-2026)

- Shipped in Swift 5.9; enabled per-target with
  `swiftSettings: [.interoperabilityMode(.Cxx)]`.
- Still officially **"actively evolving"** with **no source-stability guarantee**
  across toolchain versions — "some changes in future releases of Swift will
  require source changes in mixed Swift and C++ codebases."
- Swift 6.3 (Apr 2026) improved *C* interop (`@c`, `@implementation`) and added
  Android support — nothing that changes the C++ template story.
- **Templates are the wall**, and that's our Eigen/OpenCV boundary:
  - "Class and structure templates are not directly available in Swift" — only
    instantiated specializations via type aliases.
  - No non-type template params, template template params, or parameter packs;
    Swift's constraint-based generics don't map onto C++ syntactic substitution.
  - Community consensus: for Eigen/OpenCV, "bring the external C++ library into
    your own C++ code and wrap it before exposing it to Swift."
- Perf caveat relevant to AR hot paths: "Swift can make a deep copy of a
  collection when it's used in a `for-in` loop," no perf guarantees for C++
  containers yet.
- SPM: a target enabling C++ interop requires its dependents to enable it too.

### Sources

- [Supported Features and Constraints — Swift.org](https://www.swift.org/documentation/cxx-interop/status/)
- [Mixing Swift and C++ — Swift.org](https://www.swift.org/documentation/cxx-interop/)
- [Swift 6.3 Stabilizes Android SDK, Extends C Interop — InfoQ](https://www.infoq.com/news/2026/04/swift-6-3-android-c-interop/)
- [C++ interop limitations and future direction — Swift Forums](https://forums.swift.org/t/c-interop-limitations-and-future-direction/68198)
- [How to Create a Swift Package From a C++ Library — DEV](https://dev.to/ksemianov/how-to-create-a-swift-package-from-a-c-library-3g2l)

## Prototype

A self-contained spike lives in
[`Experiments/CxxInteropGPS/`](../Experiments/CxxInteropGPS/) — see its
[README](../Experiments/CxxInteropGPS/README.md). It demonstrates the facade
pattern on `LARGPSObservation` and builds with only a Swift 5.9+ toolchain (no
Eigen/OpenCV/xcframeworks).

```bash
export CC=$(xcrun --find clang) CXX=$(xcrun --find clang++)
cd Experiments/CxxInteropGPS && swift test
```

> Authored on a Linux box without a Swift toolchain, so it has **not** been
> compiled yet — run the command above on macOS to validate. The README has a
> findings checklist and the drop-in recipe to graft the facade onto the live
> `lar::GPSObservation` in the main package.
