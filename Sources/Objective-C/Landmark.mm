//
//  Landmark.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import "geoar/core/landmark.h"

#import "Landmark.h"

@interface Landmark ()

@property(nonatomic,readwrite) geoar::Landmark* _internal;

@end

@implementation Landmark

- (id)initWithInternal:(geoar::Landmark*)landmark {
    self = [super init];
    self._internal = landmark;
    return self;
}

- (simd_double3)position {
    Eigen::Vector3d position = self._internal->position;
    return simd_make_double3(position.x(), position.y(), position.z());
}

@end
