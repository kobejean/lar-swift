//
//  Landmark.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <geoar/tracking/tracking.h>
#endif

#import <Foundation/Foundation.h>
#include <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface Landmark: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Landmark* _internal;
#endif

@property(readonly) simd_double3 position;

#ifdef __cplusplus
    - (id)initWithInternal:(geoar::Landmark*)landmark;
#endif

@end

NS_ASSUME_NONNULL_END
