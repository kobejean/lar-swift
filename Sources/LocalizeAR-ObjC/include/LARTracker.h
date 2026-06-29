//
//  Tracking.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#import <simd/simd.h>

#ifdef __cplusplus
    #include <lar/tracking/tracker.h>
#endif

#import <Foundation/Foundation.h>

#import "LARImage.h"         // canonical def: lar/tracking/image.h
#import "LARSpatialQuery.h"  // canonical def: lar/core/spatial/spatial_query.h
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

// Frame-based localization with a spatial query.
// `image` is a grayscale (CV_8UC1) buffer; opencv stays in the .mm implementation.
- (bool)localizeWithImage:(LARImage)image
                    frame:(LARFrame*)frame
                    query:(LARSpatialQuery)query
          outputTransform:(simd_double4x4*)outTransform
    NS_SWIFT_NAME( localize(image:frame:query:outputTransform:) );

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
