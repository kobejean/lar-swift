//
//  LARGPSObservation.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import "geoar/mapping/location_matcher.h"

#import "LARGPSObservation.h"

@interface LARGPSObservation ()

@property(nonatomic,readwrite) geoar::GPSObservation* _internal;

@end

@implementation LARGPSObservation

- (id)initWithInternal:(geoar::GPSObservation*)observation {
    self = [super init];
    self._internal = observation;
    return self;
}

- (simd_double3)relative {
    Eigen::Vector3d relative = self._internal->relative;
    return simd_make_double3(relative.x(), relative.y(), relative.z());
}

@end
