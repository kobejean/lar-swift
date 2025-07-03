//
//  LARAnchor.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <lar/core/anchor.h>
#endif

#import <Foundation/Foundation.h>
#include <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARAnchor: NSObject {
#ifdef __cplusplus
    @public lar::Anchor* _internal;
    @public BOOL _ownsInternal;
#endif
}


@property(nonatomic,readwrite) int id;
@property(nonatomic,readonly) simd_double4x4 transform;

#ifdef __cplusplus
    - (id)initWithInternal:(lar::Anchor*)anchor;
    - (id)initWithInternalCopy:(lar::Anchor*)anchor;
#endif
- (id)initWithTransform:(simd_double4x4)transform;

@end

NS_ASSUME_NONNULL_END
