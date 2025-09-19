//
//  LARFrame.h
//  
//
//  Created by Jean Flaherty on 2025-07-03.
//

#pragma once

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <opencv2/Mat.h>
#pragma clang diagnostic pop

#ifdef __cplusplus
    #include <lar/mapping/frame.h>
#endif

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARFrame: NSObject {
#ifdef __cplusplus
    @public lar::Frame* _internal;
#endif
};

@property(nonatomic,readonly) NSInteger frameId;
@property(nonatomic,readonly) NSInteger timestamp;
@property(nonatomic,readonly) simd_float3x3 intrinsics;
@property(nonatomic,readonly) simd_float4x4 extrinsics;

// Convenience initializer
- (instancetype)initWithId:(NSInteger)id timestamp:(NSInteger)timestamp intrinsics:(simd_float3x3)intrinsics extrinsics:(simd_float4x4)extrinsics;

// Load frames from JSON file (like C++ lar_localize.cpp)
+ (nullable NSArray<LARFrame*>*)loadFramesFromFile:(NSString*)path;

@end

NS_ASSUME_NONNULL_END