//
//  LARGPSFacade.h
//
//  Narrow C++ facade over lar::GPSObservation for direct Swift/C++ interop.
//
//  Design rule: NO heavy-template types (Eigen, OpenCV) appear in this header.
//  Swift imports these as plain value types with stored properties — zero
//  accessor boilerplate, unlike the Objective-C++ bridge which needs a getter
//  per field.
//
#pragma once

#include <vector>

namespace lardemo {

// Plain 3-component vector. Swift imports this as a struct with `x/y/z: Double`.
struct Vec3 {
    double x;
    double y;
    double z;
};

// POD mirror of lar::GPSObservation. Swift imports this directly as a value
// type — `obs.relative.x` is readable from Swift with no glue code.
struct GPSObservation {
    long long timestamp;
    Vec3 relative;
    Vec3 global;
    Vec3 accuracy;
};

// Returns demo observations as a std::vector. Swift exposes std::vector as a
// Collection (via CxxStdlib), so the Swift side can `.map` over it directly.
//
// In the real integration this is the conversion seam: it would read a
// lar::Mapper::Data's `gps_obs` and copy each Eigen::Vector3d field into Vec3
// (e.g. relative.x() -> Vec3.x). Eigen stays entirely on this side of the line.
std::vector<GPSObservation> demo_observations();

}  // namespace lardemo
