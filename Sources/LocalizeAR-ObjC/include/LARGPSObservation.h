//
//  LARLandmark.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <lar/mapping/location_matcher.h>
#endif

#import <Foundation/Foundation.h>
#include <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARGPSObservation: NSObject {
#ifdef __cplusplus
    @public lar::GPSObservation* _internal;
#endif
}

@property(readonly) simd_double3 relative;
@property(readonly) simd_double3 global;

#ifdef __cplusplus
    - (id)initWithInternal:(lar::GPSObservation*)observation;
#endif

@end

NS_ASSUME_NONNULL_END
