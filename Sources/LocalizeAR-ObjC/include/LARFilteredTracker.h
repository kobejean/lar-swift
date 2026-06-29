//
//  LARFilteredTracker.h
//  LocalizeAR
//
//  Created by Jean Flaherty on 2025-09-22.
//

#pragma once

#ifdef __cplusplus
    #include <lar/tracking/filtered_tracker.h>
#endif

#import <Foundation/Foundation.h>
#import <simd/simd.h>

#import "LARImage.h"         // canonical def: lar/tracking/image.h
#import "LARSpatialQuery.h"  // canonical def: lar/core/spatial/spatial_query.h
#import "LARMap.h"
#import "LARFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface LARFilteredTrackerResult : NSObject
@property(nonatomic, readonly) BOOL success;
@property(nonatomic, readonly) simd_float4x4 mapToVIOTransform;
@property(nonatomic, readonly) double confidence;
@property(nonatomic, readonly) NSInteger matchedLandmarkCount;
@property(nonatomic, readonly) NSInteger inlierCount;
@property(nonatomic, readonly, nullable) NSArray<NSNumber*>* inlierLandmarkIds;

- (instancetype)initWithSuccess:(BOOL)success
                      transform:(simd_float4x4)transform
                     confidence:(double)confidence
            matchedLandmarkCount:(NSInteger)matchedCount
                    inlierCount:(NSInteger)inlierCount
              inlierLandmarkIds:(nullable NSArray<NSNumber*>*)inlierIds;
@end

@interface LARFilteredTracker: NSObject {
#ifdef __cplusplus
    @public std::unique_ptr<lar::FilteredTracker> _internal;
#endif
};

@property(nonatomic, readonly) LARMap* map;
@property(nonatomic, readonly) double measurementInterval;
@property(nonatomic, readonly) BOOL isInitialized;
@property(nonatomic, readonly) double positionUncertainty;
@property(nonatomic, readonly) BOOL isAnimating;

/**
 * Initialize FilteredTracker with map
 * @param map LAR map for localization
 * Uses default image size (1920x1440) and 2.0s measurement interval.
 */
- (instancetype)initWithMap:(LARMap*)map;

/**
 * Initialize FilteredTracker with map and measurement interval
 * @param map LAR map for localization
 * @param measurementInterval Update interval for LAR measurements
 * Uses default image size (1920x1440).
 */
- (instancetype)initWithMap:(LARMap*)map measurementInterval:(double)measurementInterval;

/**
 * Initialize FilteredTracker with specific image dimensions
 * @param map LAR map for localization
 * @param imageWidth Image width for feature extraction
 * @param imageHeight Image height for feature extraction
 * @param measurementInterval Update interval for LAR measurements (default: 2.0s)
 */
- (instancetype)initWithMap:(LARMap*)map imageWidth:(int)imageWidth imageHeight:(int)imageHeight measurementInterval:(double)measurementInterval;
- (instancetype)initWithMap:(LARMap*)map imageWidth:(int)imageWidth imageHeight:(int)imageHeight; // Default 2.0s interval

/**
 * Reconfigure tracker with new image dimensions
 * Call this if the actual image size differs from initialization
 */
- (void)configureImageSizeWithWidth:(int)imageWidth height:(int)imageHeight;

/**
 * Update current VIO camera pose - call every VIO frame BEFORE predictStep
 * @param transform VIO camera transform (ARKit: frame.camera.transform, ARCore: pose.matrix)
 */
- (void)updateVIOCameraPose:(simd_float4x4)transform;

/**
 * Prediction step - call every VIO frame AFTER updateVIOCameraPose
 */
- (void)predictStep;

/**
 * Measurement update - call every measurement interval
 * @param image Grayscale (CV_8UC1) image input for localization
 * @param frame Frame data with GPS and camera info
 * @param query Spatial query (map-local center + search diameter)
 * @return Measurement result with success status and transform
 */
// `image` is a grayscale (CV_8UC1) buffer; opencv stays in the .mm implementation.
- (LARFilteredTrackerResult*)measurementUpdateWithImage:(LARImage)image
                                                  frame:(LARFrame*)frame
                                                  query:(LARSpatialQuery)query
    NS_SWIFT_NAME( measurementUpdate(image:frame:query:) );

/**
 * Get current filtered VIO → LAR map transform
 * This transform can be applied to VIO poses to get map-aligned poses
 */
- (simd_float4x4)getFilteredTransform;

/**
 * Reset tracker state (call when tracking is lost)
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END