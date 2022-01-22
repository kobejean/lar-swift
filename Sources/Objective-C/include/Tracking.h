//
//  Tracking.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

//#if __APPLE__
//    #include "TargetConditionals.h"
//    #if TARGET_OS_IPHONE
//        #import <ARKit/ARKit.h>
//    #endif
//#endif

#ifdef __cplusplus
    #import <opencv2/core.hpp>
    #import <geoar/tracking/tracking.h>
#endif

#import <opencv2/Mat.h>
#import <Foundation/Foundation.h>

#import "Map.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tracking: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Tracking* _internal;
#endif

@property(readonly) Map* map;

- (id)initWithMap:(Map*)map;

- (void)localize:(Mat*)image intrinsics:(Mat*)intrinsics transform:(Mat*)transform;

@end

NS_ASSUME_NONNULL_END
