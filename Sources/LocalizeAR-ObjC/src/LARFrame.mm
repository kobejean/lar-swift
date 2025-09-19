//
//  LARFrame.mm
//  
//
//  Created by Jean Flaherty on 2025-07-03.
//

#import <iostream>
#import <fstream>
#import <vector>
#import "lar/core/utils/json.h"
#import "lar/mapping/frame.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <opencv2/Mat.h>
#pragma clang diagnostic pop

#import "LARFrame.h"

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

- (void)dealloc {
    delete self->_internal;
}

- (NSInteger)frameId {
    return self->_internal->id;
}

- (NSInteger)timestamp {
    return self->_internal->timestamp;
}

- (simd_float3x3)intrinsics {
    // Convert Eigen::Matrix3d to simd_float3x3
    Eigen::Matrix3d mat = self->_internal->intrinsics;
    return simd_matrix(
        (simd_float3){ (float)mat(0,0), (float)mat(1,0), (float)mat(2,0) },
        (simd_float3){ (float)mat(0,1), (float)mat(1,1), (float)mat(2,1) },
        (simd_float3){ (float)mat(0,2), (float)mat(1,2), (float)mat(2,2) }
    );
}

- (simd_float4x4)extrinsics {
    // Convert Eigen::Matrix4d to simd_float4x4
    Eigen::Matrix4d mat = self->_internal->extrinsics;
    return simd_matrix(
        (simd_float4){ (float)mat(0,0), (float)mat(1,0), (float)mat(2,0), (float)mat(3,0) },
        (simd_float4){ (float)mat(0,1), (float)mat(1,1), (float)mat(2,1), (float)mat(3,1) },
        (simd_float4){ (float)mat(0,2), (float)mat(1,2), (float)mat(2,2), (float)mat(3,2) },
        (simd_float4){ (float)mat(0,3), (float)mat(1,3), (float)mat(2,3), (float)mat(3,3) }
    );
}

- (instancetype)initWithId:(NSInteger)id timestamp:(NSInteger)timestamp intrinsics:(simd_float3x3)intrinsics extrinsics:(simd_float4x4)extrinsics {
    self = [super init];
    if (self) {
        self->_internal = new lar::Frame();
        self->_internal->id = id;
        self->_internal->timestamp = timestamp;
        
        // Convert simd_float3x3 to Eigen::Matrix3d for intrinsics
        Eigen::Matrix3d intrinsicsMat;
        intrinsicsMat << intrinsics.columns[0][0], intrinsics.columns[1][0], intrinsics.columns[2][0],
                         intrinsics.columns[0][1], intrinsics.columns[1][1], intrinsics.columns[2][1],
                         intrinsics.columns[0][2], intrinsics.columns[1][2], intrinsics.columns[2][2];
        self->_internal->intrinsics = intrinsicsMat;
        
        // Convert simd_float4x4 to Eigen::Matrix4d for extrinsics
        Eigen::Matrix4d extrinsicsMat;
        extrinsicsMat << extrinsics.columns[0][0], extrinsics.columns[1][0], extrinsics.columns[2][0], extrinsics.columns[3][0],
                         extrinsics.columns[0][1], extrinsics.columns[1][1], extrinsics.columns[2][1], extrinsics.columns[3][1],
                         extrinsics.columns[0][2], extrinsics.columns[1][2], extrinsics.columns[2][2], extrinsics.columns[3][2],
                         extrinsics.columns[0][3], extrinsics.columns[1][3], extrinsics.columns[2][3], extrinsics.columns[3][3];
        self->_internal->extrinsics = extrinsicsMat;
    }
    return self;
}

+ (nullable NSArray<LARFrame*>*)loadFramesFromFile:(NSString*)path {
    try {
        // Convert NSString path to std::string
        std::string filepath = [path UTF8String];

        // Open and parse JSON file
        std::ifstream file(filepath);
        if (!file.is_open()) {
            NSLog(@"Failed to open file: %@", path);
            return nil;
        }

        // Parse JSON
        nlohmann::json json_data = nlohmann::json::parse(file);

        // Parse as vector of lar::Frame
        std::vector<lar::Frame> frames = json_data;

        // Convert to NSArray of LARFrame objects
        NSMutableArray<LARFrame*>* result = [NSMutableArray arrayWithCapacity:frames.size()];

        for (const auto& frame : frames) {
            LARFrame* objcFrame = [[LARFrame alloc] init];

            // Copy frame data to internal C++ object
            objcFrame->_internal->id = frame.id;
            objcFrame->_internal->timestamp = frame.timestamp;
            objcFrame->_internal->intrinsics = frame.intrinsics;
            objcFrame->_internal->extrinsics = frame.extrinsics;

            [result addObject:objcFrame];
        }

        return [result copy]; // Return immutable copy

    } catch (const nlohmann::json::exception& e) {
        NSLog(@"JSON parsing error: %s", e.what());
        return nil;
    } catch (const std::exception& e) {
        NSLog(@"Error loading frames: %s", e.what());
        return nil;
    }
}

@end