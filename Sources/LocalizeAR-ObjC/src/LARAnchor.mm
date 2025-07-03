//
//  LARLandmark.mm
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import "lar/core/anchor.h"

#import "Helpers/LARConversion.h"
#import "LARAnchor.h"

@interface LARAnchor ()

@end

@implementation LARAnchor

- (id)initWithInternal:(lar::Anchor*)anchor {
    self = [super init];
    self->_internal = anchor;
    self->_ownsInternal = NO;
    return self;
}

- (id)initWithInternalCopy:(lar::Anchor*)anchor {
    self = [super init];
    // Create a copy of the anchor to avoid dangling pointer issues (used only for removal)
    self->_internal = new lar::Anchor(anchor->id, anchor->transform);
    #ifndef LAR_COMPACT_BUILD
    self->_internal->frame_id = anchor->frame_id;
    self->_internal->relative_transform = anchor->relative_transform;
    #endif
    self->_ownsInternal = YES;
    return self;
}

- (id)initWithTransform:(simd_double4x4)transform {
    self = [super init];
    self->_internal = new lar::Anchor(0, [LARConversion transform3dFromSIMD4x4d:transform]);
    self->_ownsInternal = YES;
    return self;
}

- (void)dealloc {
    if (self->_ownsInternal && self->_internal) {
        delete self->_internal;
    }
}

- (int)id {
    return (int)self->_internal->id;
}

- (void)setId:(int)id {
    self->_internal->id = id;
}

- (simd_double4x4)transform {
    Eigen::Transform<double,3,Eigen::Affine> transform = self->_internal->transform;
    return [LARConversion simd4x4FromTransform3d:transform];
}

@end
