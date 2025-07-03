//
//  Tracking.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <opencv2/Mat.h>
#pragma clang diagnostic pop

#ifdef __cplusplus
    #include <lar/tracking/tracker.h>
#endif

#import <Foundation/Foundation.h>

#import "LARMap.h"
#import "LARFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface LARTracker: NSObject {
#ifdef __cplusplus
    @public lar::Tracker* _internal;
#endif
};

@property(nonatomic,readonly) LARMap* map;

- (id)initWithMap:(LARMap*)map;

- (bool)localize:(Mat*)image intrinsics:(Mat*)intrinsics transform:(Mat*)transform gvec:(Mat*)gvec;

// Frame-based localization with spatial query parameters
- (bool)localizeWithImage:(Mat*)image frame:(LARFrame*)frame queryX:(double)queryX queryZ:(double)queryZ queryDiameter:(double)queryDiameter outputTransform:(Mat*)transform;

// Diagnostic information (available after localization)
- (NSInteger)spatialQueryCount;
- (NSArray<NSNumber*>*)spatialQueryLandmarkIds;
- (NSInteger)matchCount;
- (NSArray<NSNumber*>*)matchLandmarkIds;
- (NSInteger)inlierCount;
- (NSArray<NSNumber*>*)inlierLandmarkIds;
- (double)gravityAngleDifference;

@end

NS_ASSUME_NONNULL_END
