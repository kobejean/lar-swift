//
//  LARLandmark.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import "lar/core/landmark.h"

#import "LARLandmark.h"

@interface LARLandmark ()

@property(nonatomic,readwrite) lar::Landmark* _internal;

@end

@implementation LARLandmark

- (id)initWithInternal:(lar::Landmark*)landmark {
    self = [super init];
    self._internal = landmark;
    return self;
}

- (simd_double3)position {
    Eigen::Vector3d position = self._internal->position;
    return simd_make_double3(position.x(), position.y(), position.z());
}

- (simd_float3)orientation {
    Eigen::Vector3f position = self._internal->orientation;
    return simd_make_float3(position.x(), position.y(), position.z());
}

- (long long)lastSeen {
    return self._internal->last_seen;
}


- (bool)isUsable {
    return self._internal->isUseable();
}

@end
