//
//  LARGPSFacade.cpp
//
#include "LARGPSFacade.h"

// In the real package this would be:
//     #include <lar/mapping/location_matcher.h>   // defines lar::GPSObservation
// and demo_observations() would instead take a lar::Mapper::Data and read
// obs.relative.x(), obs.relative.y(), obs.relative.z() off each Eigen::Vector3d.
//
// Here we synthesize equivalent data so the prototype compiles with only a bare
// Swift toolchain — no Eigen / OpenCV / xcframeworks required.

namespace lardemo {

static Vec3 vec(double x, double y, double z) { return Vec3{x, y, z}; }

std::vector<GPSObservation> demo_observations() {
    return {
        GPSObservation{1000, vec(1, 2, 3), vec(10, 20, 30), vec(0.1, 0.1, 0.2)},
        GPSObservation{2000, vec(4, 5, 6), vec(40, 50, 60), vec(0.2, 0.2, 0.3)},
    };
}

}  // namespace lardemo
