//
//  LARGPSObservation.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import "lar/mapping/location_matcher.h"

#import "LARGPSObservation.h"

@interface LARGPSObservation ()

@end

@implementation LARGPSObservation

- (id)initWithInternal:(lar::GPSObservation*)observation {
    self = [super init];
    self->_internal = observation;
    return self;
}

- (simd_double3)relative {
    Eigen::Vector3d relative = self->_internal->relative;
    return simd_make_double3(relative.x(), relative.y(), relative.z());
}

- (simd_double3)global {
    Eigen::Vector3d global = self->_internal->global;
    return simd_make_double3(global.x(), global.y(), global.z());
}

@end
