//
//  Tracking.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#if __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_OS_IPHONE
        #import <ARKit/ARKit.h>
        #import <CoreLocation/CoreLocation.h>
    #endif
#endif

#ifdef __cplusplus
    #import <geoar/collection/collection.h>
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARCollection: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Collection* _internal;
#endif

@property(nonatomic,readonly) NSURL* directory;

- (id)initWithDirectory:(NSURL*)directory;

#if TARGET_OS_IPHONE
    - (void)addFrame:(ARFrame*)frame;
    - (void)addGPSObservation:(CLLocation*)location position:(simd_float3)position;
#endif

@end

NS_ASSUME_NONNULL_END
