//
//  LARLandmark.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <lar/core/landmark.h>
#endif

#import <Foundation/Foundation.h>
#include <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARLandmark: NSObject {
    
#ifdef __cplusplus
    @public lar::Landmark* _internal;
#endif
}

@property(readonly) long long id;
@property(readonly) simd_double3 position;
@property(readonly) simd_float3 orientation;
@property(readonly) simd_double2 boundsLower;
@property(readonly) simd_double2 boundsUpper;
@property(readonly) long long lastSeen;
@property(readonly) BOOL isMatched;
@property(readonly) int sightings;
#ifdef __cplusplus
    - (id)initWithInternal:(lar::Landmark*)landmark;
#endif

- (BOOL)isUsable;

@end

NS_ASSUME_NONNULL_END
