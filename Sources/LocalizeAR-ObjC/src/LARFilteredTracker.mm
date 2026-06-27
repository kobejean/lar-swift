//
//  LARFilteredTracker.mm
//  LocalizeAR
//
//  Created by Jean Flaherty on 2025-09-22.
//

#import "LARFilteredTracker.h"
#import "LARMap.h"
#import "LARFrame.h"

#include <lar/tracking/tracker.h>
#include <lar/tracking/filtered_tracker.h>
#include <memory>

@implementation LARFilteredTrackerResult

- (instancetype)initWithSuccess:(BOOL)success
                      transform:(simd_float4x4)transform
                     confidence:(double)confidence
            matchedLandmarkCount:(NSInteger)matchedCount
                    inlierCount:(NSInteger)inlierCount
              inlierLandmarkIds:(nullable NSArray<NSNumber*>*)inlierIds {
    self = [super init];
    if (self) {
        _success = success;
        _mapToVIOTransform = transform;
        _confidence = confidence;
        _matchedLandmarkCount = matchedCount;
        _inlierCount = inlierCount;
        _inlierLandmarkIds = inlierIds;
    }
    return self;
}

@end

// All access to the underlying lar::FilteredTracker (_internal) is serialized on
// _trackerQueue. The per-frame predictStep/updateVIOCameraPose calls arrive on the
// ARKit delegate thread while measurementUpdate runs on a background task; the C++
// object has no internal locking, so without this serialization they would race.
// Note: a long measurementUpdate still briefly serializes against per-frame calls;
// fully decoupling it would require splitting feature extraction from the filter
// apply step in lar's FilteredTracker (a core follow-up).
@implementation LARFilteredTracker {
    dispatch_queue_t _trackerQueue;
}

- (instancetype)initWithMap:(LARMap*)map {
    return [self initWithMap:map measurementInterval:2.0];
}

- (instancetype)initWithMap:(LARMap*)map measurementInterval:(double)measurementInterval {
    self = [super init];
    if (self) {
        _map = map;
        _measurementInterval = measurementInterval;
        _trackerQueue = dispatch_queue_create("com.localizar.filteredtracker", DISPATCH_QUEUE_SERIAL);

        // Create base tracker from map with default image size
        auto base_tracker = std::make_unique<lar::Tracker>(*map->_internal);

        // Create filtered tracker
        _internal = std::make_unique<lar::FilteredTracker>(std::move(base_tracker), measurementInterval);
    }
    return self;
}

- (instancetype)initWithMap:(LARMap*)map imageWidth:(int)imageWidth imageHeight:(int)imageHeight measurementInterval:(double)measurementInterval {
    self = [super init];
    if (self) {
        _map = map;
        _measurementInterval = measurementInterval;
        _trackerQueue = dispatch_queue_create("com.localizar.filteredtracker", DISPATCH_QUEUE_SERIAL);

        // Create base tracker from map with image size
        cv::Size imageSize(imageWidth, imageHeight);
        auto base_tracker = std::make_unique<lar::Tracker>(*map->_internal, imageSize);

        // Create filtered tracker
        _internal = std::make_unique<lar::FilteredTracker>(std::move(base_tracker), measurementInterval);
    }
    return self;
}

- (instancetype)initWithMap:(LARMap*)map imageWidth:(int)imageWidth imageHeight:(int)imageHeight {
    return [self initWithMap:map imageWidth:imageWidth imageHeight:imageHeight measurementInterval:2.0];
}

- (void)configureImageSizeWithWidth:(int)imageWidth height:(int)imageHeight {
    dispatch_sync(_trackerQueue, ^{
        cv::Size imageSize(imageWidth, imageHeight);
        _internal->getBaseTracker().configureImageSize(imageSize);
    });
}

- (BOOL)isInitialized {
    __block BOOL result;
    dispatch_sync(_trackerQueue, ^{ result = _internal->isInitialized(); });
    return result;
}

- (double)positionUncertainty {
    __block double result;
    dispatch_sync(_trackerQueue, ^{ result = _internal->getPositionUncertainty(); });
    return result;
}

- (BOOL)isAnimating {
    __block BOOL result;
    dispatch_sync(_trackerQueue, ^{ result = _internal->isAnimating(); });
    return result;
}

- (void)updateVIOCameraPose:(simd_float4x4)transform {
    dispatch_sync(_trackerQueue, ^{
        // Convert simd_float4x4 to Eigen::Matrix4d
        Eigen::Matrix4d mat;
        mat << transform.columns[0][0], transform.columns[1][0], transform.columns[2][0], transform.columns[3][0],
               transform.columns[0][1], transform.columns[1][1], transform.columns[2][1], transform.columns[3][1],
               transform.columns[0][2], transform.columns[1][2], transform.columns[2][2], transform.columns[3][2],
               transform.columns[0][3], transform.columns[1][3], transform.columns[2][3], transform.columns[3][3];

        _internal->updateVIOCameraPose(mat);
    });
}

- (void)predictStep {
    dispatch_sync(_trackerQueue, ^{ _internal->predictStep(); });
}

- (LARFilteredTrackerResult*)measurementUpdateWithGrayscaleData:(const void*)data
                                                          width:(int)width
                                                         height:(int)height
                                                    bytesPerRow:(int)bytesPerRow
                                                          frame:(LARFrame*)frame
                                                         queryX:(double)queryX
                                                         queryZ:(double)queryZ
                                                  queryDiameter:(double)queryDiameter {
    __block LARFilteredTrackerResult* output = nil;
    dispatch_sync(_trackerQueue, ^{
        // Wrap the caller's grayscale bytes in a cv::Mat (no copy). const_cast is safe:
        // cv::Mat's ctor only accepts void*, and the tracker treats the buffer read-only.
        cv::Mat imageMat(height, width, CV_8UC1, const_cast<void*>(data), (size_t)bytesPerRow);

        // Perform measurement update
        lar::FilteredTracker::MeasurementResult result = _internal->measurementUpdate(
            imageMat,
            *frame->_internal,
            queryX,
            queryZ,
            queryDiameter
        );

        // Convert transform to simd format
        simd_float4x4 simd_transform = simd_matrix(
            (simd_float4){ 1.0f, 0.0f, 0.0f, 0.0f },
            (simd_float4){ 0.0f, 1.0f, 0.0f, 0.0f },
            (simd_float4){ 0.0f, 0.0f, 1.0f, 0.0f },
            (simd_float4){ 0.0f, 0.0f, 0.0f, 1.0f }
        );
        if (result.success) {
            const Eigen::Matrix4d& mat = result.map_to_vio_transform;
            simd_transform = simd_matrix(
                (simd_float4){ (float)mat(0,0), (float)mat(1,0), (float)mat(2,0), (float)mat(3,0) },
                (simd_float4){ (float)mat(0,1), (float)mat(1,1), (float)mat(2,1), (float)mat(3,1) },
                (simd_float4){ (float)mat(0,2), (float)mat(1,2), (float)mat(2,2), (float)mat(3,2) },
                (simd_float4){ (float)mat(0,3), (float)mat(1,3), (float)mat(2,3), (float)mat(3,3) }
            );
        }

        // Extract inlier landmark IDs
        NSMutableArray<NSNumber*>* inlierIds = nil;
        if (!result.inliers.empty()) {
            inlierIds = [NSMutableArray arrayWithCapacity:result.inliers.size()];
            for (const auto& inlier : result.inliers) {
                [inlierIds addObject:@(inlier.first->id)];
            }
        }

        // Create result object
        output = [[LARFilteredTrackerResult alloc] initWithSuccess:result.success
                                                        transform:simd_transform
                                                       confidence:result.confidence
                                              matchedLandmarkCount:result.matched_landmarks.size()
                                                      inlierCount:result.inliers.size()
                                                inlierLandmarkIds:inlierIds];
    });
    return output;
}

- (simd_float4x4)getFilteredTransform {
    __block simd_float4x4 result;
    dispatch_sync(_trackerQueue, ^{
        Eigen::Matrix4d mat = _internal->getFilteredTransform();
        result = simd_matrix(
            (simd_float4){ (float)mat(0,0), (float)mat(1,0), (float)mat(2,0), (float)mat(3,0) },
            (simd_float4){ (float)mat(0,1), (float)mat(1,1), (float)mat(2,1), (float)mat(3,1) },
            (simd_float4){ (float)mat(0,2), (float)mat(1,2), (float)mat(2,2), (float)mat(3,2) },
            (simd_float4){ (float)mat(0,3), (float)mat(1,3), (float)mat(2,3), (float)mat(3,3) }
        );
    });
    return result;
}

- (void)reset {
    dispatch_sync(_trackerQueue, ^{ _internal->reset(); });
}

@end
