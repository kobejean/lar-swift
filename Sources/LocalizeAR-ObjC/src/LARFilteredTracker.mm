//
//  LARFilteredTracker.mm
//  LocalizeAR
//
//  Created by Jean Flaherty on 2025-09-22.
//

#import "LARFilteredTracker.h"
#import "LARMap.h"
#import "LARFrame.h"
#import "Helpers/LARConversion.h"

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

// lar::FilteredTracker is now internally thread-safe (its state_mutex_ guards the filter
// and VIO pose state). So the lightweight per-frame / state methods call straight through
// to C++ with no dispatch — they take that mutex for microseconds and, crucially, never
// block on a running measurementUpdate (its expensive CV runs unlocked in C++).
//
// The only methods that touch the underlying base tracker (its CV state, which is NOT
// mutex-guarded by design) are measurementUpdate and configureImageSize. Per the
// FilteredTracker caller contract those must not run concurrently with each other, so we
// keep a single serial queue, _measurementQueue, just for them. Per-frame ops deliberately
// bypass that queue.
@implementation LARFilteredTracker {
    dispatch_queue_t _measurementQueue;
}

- (instancetype)initWithMap:(LARMap*)map {
    return [self initWithMap:map measurementInterval:2.0];
}

- (instancetype)initWithMap:(LARMap*)map measurementInterval:(double)measurementInterval {
    self = [super init];
    if (self) {
        _map = map;
        _measurementInterval = measurementInterval;
        _measurementQueue = dispatch_queue_create("com.localizar.filteredtracker.measurement", DISPATCH_QUEUE_SERIAL);

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
        _measurementQueue = dispatch_queue_create("com.localizar.filteredtracker.measurement", DISPATCH_QUEUE_SERIAL);

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
    // Touches the base tracker's CV state: serialize with measurementUpdate.
    dispatch_sync(_measurementQueue, ^{
        cv::Size imageSize(imageWidth, imageHeight);
        _internal->getBaseTracker().configureImageSize(imageSize);
    });
}

- (BOOL)isInitialized {
    // Direct: FilteredTracker locks its own state_mutex_ briefly.
    return _internal->isInitialized();
}

- (double)positionUncertainty {
    return _internal->getPositionUncertainty();
}

- (BOOL)isAnimating {
    return _internal->isAnimating();
}

- (void)updateVIOCameraPose:(simd_float4x4)transform {
    // Direct, per-frame: FilteredTracker locks state_mutex_ for microseconds and never
    // blocks on a running measurementUpdate (its CV runs unlocked in C++).
    Eigen::Matrix4d mat;
    mat << transform.columns[0][0], transform.columns[1][0], transform.columns[2][0], transform.columns[3][0],
           transform.columns[0][1], transform.columns[1][1], transform.columns[2][1], transform.columns[3][1],
           transform.columns[0][2], transform.columns[1][2], transform.columns[2][2], transform.columns[3][2],
           transform.columns[0][3], transform.columns[1][3], transform.columns[2][3], transform.columns[3][3];

    _internal->updateVIOCameraPose(mat);
}

- (void)predictStep {
    // Direct, per-frame. Call after updateVIOCameraPose on the same (ARKit) thread to
    // preserve ordering.
    _internal->predictStep();
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
    // Serialized on _measurementQueue: this is the only heavy op (plus configureImageSize)
    // that touches the base tracker's CV state. Per-frame ops run concurrently — they don't
    // use this queue.
    dispatch_sync(_measurementQueue, ^{
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
        simd_float4x4 simd_transform = matrix_identity_float4x4;
        if (result.success) {
            simd_transform = [LARConversion simd4x4FloatFromMatrix4d:result.map_to_vio_transform];
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
    // Direct, per-frame: reads filter + VIO state under state_mutex_ in C++.
    return [LARConversion simd4x4FloatFromMatrix4d:_internal->getFilteredTransform()];
}

- (void)reset {
    // Direct: only touches filter/VIO state (state_mutex_), not the base tracker. A
    // concurrent measurementUpdate re-checks isInitialized() under the lock.
    _internal->reset();
}

@end
