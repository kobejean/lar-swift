//
//  Tracking.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <opencv2/core.hpp>
    #import <geoar/tracking/tracker.h>
#endif

#import "opencv2/Mat.h"
#import <Foundation/Foundation.h>

#import "LARMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface LARTracker: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Tracker* _internal;
#endif

@property(nonatomic,readonly) LARMap* map;

- (id)initWithMap:(LARMap*)map;

- (void)localize:(Mat*)image intrinsics:(Mat*)intrinsics transform:(Mat*)transform;

@end

NS_ASSUME_NONNULL_END
