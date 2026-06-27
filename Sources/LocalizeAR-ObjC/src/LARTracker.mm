//
//  LARTracker.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <lar/tracking/tracker.h>
#import <iostream>
#import <fstream>
#import <vector>
#import "lar/core/utils/json.h"
#import "lar/mapping/frame.h"

#import "LARTracker.h"
#import "LARFrame.h"
#import "Helpers/LARConversion.h"


@interface LARTracker ()

@property(nonatomic,retain,readwrite) LARMap* map;

@end

@implementation LARTracker

- (id)initWithMap:(LARMap*)map {
    self = [super init];
    // Use default image size (1920x1440) - will be reconfigured automatically if needed
    self->_internal = new lar::Tracker(*map->_internal);
    self.map = map;
    return self;
}

- (id)initWithMap:(LARMap*)map imageWidth:(int)imageWidth imageHeight:(int)imageHeight {
    self = [super init];
    cv::Size imageSize(imageWidth, imageHeight);
    self->_internal = new lar::Tracker(*map->_internal, imageSize);
    self.map = map;
    return self;
}

- (void)dealloc {
    delete self->_internal;
}

- (void)configureImageSizeWithWidth:(int)imageWidth height:(int)imageHeight {
    cv::Size imageSize(imageWidth, imageHeight);
    self->_internal->configureImageSize(imageSize);
}

- (bool)localizeWithGrayscaleData:(const void*)data width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow frame:(LARFrame*)frame queryX:(double)queryX queryZ:(double)queryZ queryDiameter:(double)queryDiameter outputTransform:(simd_double4x4*)outTransform {
    // Wrap the caller's grayscale bytes in a cv::Mat (no copy). const_cast is safe:
    // cv::Mat's ctor only accepts void*, and localize treats the buffer read-only.
    cv::Mat imageMat(height, width, CV_8UC1, const_cast<void*>(data), (size_t)bytesPerRow);
    lar::Frame* internalFrame = frame->_internal;

    Eigen::Matrix4d resultTransform;
    bool success = self->_internal->localize(imageMat, *internalFrame, queryX, queryZ, queryDiameter, resultTransform);

    if (success && outTransform) {
        *outTransform = [LARConversion simd4x4DoubleFromMatrix4d:resultTransform];
    }

    return success;
}

// Diagnostic information methods
- (NSInteger)spatialQueryCount {
    return self->_internal->local_landmarks.size();
}

- (NSArray<NSNumber*>*)spatialQueryLandmarkIds {
    NSMutableArray<NSNumber*>* landmarkIds = [NSMutableArray array];
    
    for (const auto& landmark : self->_internal->local_landmarks) {
        if (landmark) { // Check if landmark pointer is valid
            [landmarkIds addObject:@(landmark->id)];
        }
    }
    
    return [landmarkIds copy];
}

- (NSInteger)matchCount {
    return self->_internal->matches.size();
}

- (NSArray<NSNumber*>*)matchLandmarkIds {
    NSMutableArray<NSNumber*>* landmarkIds = [NSMutableArray array];
    
    for (const auto& match : self->_internal->matches) {
        if (match.first) { // Check if landmark pointer is valid
            [landmarkIds addObject:@(match.first->id)];
        }
    }
    
    return [landmarkIds copy];
}

- (NSInteger)inlierCount {
    return self->_internal->inliers.size();
}

- (NSArray<NSNumber*>*)inlierLandmarkIds {
    NSMutableArray<NSNumber*>* landmarkIds = [NSMutableArray array];
    
    for (const auto& inlier : self->_internal->inliers) {
        if (inlier.first) { // Check if landmark pointer is valid
            [landmarkIds addObject:@(inlier.first->id)];
        }
    }
    
    return [landmarkIds copy];
}

- (double)gravityAngleDifference {
    return self->_internal->getLastGravityAngleDifference();
}

@end
