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


@interface LARTracker ()

@property(nonatomic,retain,readwrite) LARMap* map;

@end

@implementation LARTracker

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

- (bool)localizeWithImage:(Mat*)image frame:(LARFrame*)frame queryX:(double)queryX queryZ:(double)queryZ queryDiameter:(double)queryDiameter outputTransform:(Mat*)transform {
    cv::Mat imageMat = image.nativeRef;
    lar::Frame* internalFrame = frame->_internal;
    
    // Prepare result transform
    Eigen::Matrix4d resultTransform;
    
    // Call the frame-based localize method with explicit spatial query parameters
    bool success = self->_internal->localize(imageMat, *internalFrame, queryX, queryZ, queryDiameter, resultTransform);
    
    // Copy result back to output transform Mat
    if (success) {
        cv::Mat transformMat = transform.nativeRef;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                transformMat.at<double>(i, j) = resultTransform(i, j);
            }
        }
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
