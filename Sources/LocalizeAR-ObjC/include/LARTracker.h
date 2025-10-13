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

/**
 * Initialize tracker with map
 * @param map LAR map for localization
 * Uses default image size (1920x1440). Call configureImageSizeWithWidth:height: if actual size differs.
 */
- (id)initWithMap:(LARMap*)map;

/**
 * Initialize tracker with specific image dimensions
 * @param map LAR map for localization
 * @param imageWidth Expected image width
 * @param imageHeight Expected image height
 */
- (id)initWithMap:(LARMap*)map imageWidth:(int)imageWidth imageHeight:(int)imageHeight;

/**
 * Reconfigure tracker with new image dimensions
 * Call this if the actual image size differs from initialization
 */
- (void)configureImageSizeWithWidth:(int)imageWidth height:(int)imageHeight;

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
