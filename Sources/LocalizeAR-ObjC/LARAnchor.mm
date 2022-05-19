//
//  LARLandmark.mm
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import "lar/core/anchor.h"

#import "Helpers/LARConversion.h"
#import "LARAnchor.h"

//@interface LARAnchor ()
//
//@property(nonatomic,readwrite) lar::Anchor* _internal;
//
//@end

@implementation LARAnchor

- (id)initWithInternal:(lar::Anchor*)anchor {
    self = [super init];
    self._internal = anchor;
    return self;
}

- (id)initWithTransform:(simd_double4x4)transform {
    self = [super init];
    self._internal = new lar::Anchor {
        .id=0,
        .transform=[LARConversion transform3dFromSIMD4x4:transform]
    };
    return self;
}

- (int)id {
    return self._internal->id;
}

- (simd_double4x4)transform {
    Eigen::Transform<double,3,Eigen::Affine> transform = self._internal->transform;
    return [LARConversion simd4x4FromTransform3d:transform];
}

@end
