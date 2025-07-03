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

// LARFrame implementation - temporary location until build system issue resolved
@implementation LARFrame

- (instancetype)init {
    self = [super init];
    if (self) {
        self->_internal = new lar::Frame();
        self->_internal->id = 0;
        self->_internal->timestamp = 0;
    }
    return self;
}

- (instancetype)initWithCppFrame:(const lar::Frame&)cppFrame {
    self = [super init];
    if (self) {
        self->_internal = new lar::Frame(cppFrame);
    }
    return self;
}

+ (nullable NSArray<LARFrame*>*)loadFramesFromFile:(NSString*)path {
    std::ifstream file([path UTF8String]);
    if (!file.is_open()) {
        return nil;
    }
    
    try {
        nlohmann::json j;
        file >> j;
        
        std::vector<lar::Frame> frames = j.get<std::vector<lar::Frame>>();
        NSMutableArray<LARFrame*>* result = [NSMutableArray arrayWithCapacity:frames.size()];
        
        for (const auto& frame : frames) {
            LARFrame* larFrame = [[LARFrame alloc] initWithCppFrame:frame];
            [result addObject:larFrame];
        }
        
        return result;
        
    } catch (const std::exception& e) {
        NSLog(@"Error loading frames: %s", e.what());
        return nil;
    }
}

- (void)dealloc {
    delete self->_internal;
}

- (NSInteger)frameId {
    return self->_internal->id;
}

- (NSInteger)timestamp {
    return self->_internal->timestamp;
}

@end

@interface LARTracker ()

@property(nonatomic,retain,readwrite) LARMap* map;

@end

@implementation LARTracker

- (id)initWithMap:(LARMap*)map {
    self = [super init];
    self->_internal = new lar::Tracker(*map->_internal);
    self.map = map;
    return self;
}

- (void)dealloc {
    delete self->_internal;
}

- (bool)localize:(Mat*)image intrinsics:(Mat*)intrinsics transform:(Mat*)transform gvec:(Mat*)gvec {
	return self->_internal->localize(image.nativeRef, intrinsics.nativeRef, transform.nativeRef, gvec.nativeRef);
}

- (bool)localizeWithImage:(Mat*)image frame:(LARFrame*)frame outputTransform:(Mat*)transform {
    cv::Mat imageMat = image.nativeRef;
    lar::Frame* internalFrame = frame->_internal;
    
    // Copy extrinsics to working matrix
    Eigen::Matrix4d extrinsics = internalFrame->extrinsics;
    
    // Call the frame-based localize method (same as C++ lar_localize.cpp)
    bool success = self->_internal->localize(imageMat, *internalFrame, extrinsics);
    
    // Copy result back to output transform Mat
    if (success) {
        cv::Mat transformMat = transform.nativeRef;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                transformMat.at<double>(i, j) = extrinsics(i, j);
            }
        }
    }
    
    return success;
}

- (bool)localizeWithImage:(Mat*)image frame:(LARFrame*)frame initialPose:(Mat*)initialPose outputTransform:(Mat*)transform {
    cv::Mat imageMat = image.nativeRef;
    lar::Frame* internalFrame = frame->_internal;
    cv::Mat initialPoseMat = initialPose.nativeRef;
    
    // Use initial camera pose as starting point for spatial querying
    Eigen::Matrix4d extrinsics;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            extrinsics(i, j) = initialPoseMat.at<double>(i, j);
        }
    }
    
    // Call the frame-based localize method with initial pose for spatial indexing
    bool success = self->_internal->localize(imageMat, *internalFrame, extrinsics);
    
    // Copy result back to output transform Mat
    if (success) {
        cv::Mat transformMat = transform.nativeRef;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                transformMat.at<double>(i, j) = extrinsics(i, j);
            }
        }
    }
    
    return success;
}

@end
