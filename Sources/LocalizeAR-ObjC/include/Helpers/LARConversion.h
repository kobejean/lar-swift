//
//  LARConversion.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus

#import <Eigen/Core>
#import <opencv2/core/mat.hpp>

#import <CoreVideo/CoreVideo.h>
#import <simd/simd.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARConversion : NSObject

+ (long int)timestampFromInterval:(NSTimeInterval)interval;
+ (Eigen::Matrix3f)eigenFromSIMD3:(simd_float3x3)simd;
+ (Eigen::Matrix4f)eigenFromSIMD4:(simd_float4x4)simd;
+ (Eigen::Vector3d)vector3dFromSIMD3:(simd_double3)simd;
+ (Eigen::Vector3f)vector3fFromSIMD3:(simd_float3)simd;
+ (simd_double3)simd3FromVector3d:(Eigen::Vector3d)vector;
+ (simd_float3)simd3FromVector3f:(Eigen::Vector3f)vector;
+ (simd_double4x4)simd4x4FromTransform3d:(Eigen::Transform<double,3,Eigen::Affine>)transform;
+ (Eigen::Transform<double,3,Eigen::Affine>)transform3dFromSIMD4x4:(simd_double4x4)simd;
+ (cv::Mat)matFromBuffer:(CVPixelBufferRef)buffer planeIndex:(size_t)planeIndex type:(int)type;

@end

NS_ASSUME_NONNULL_END

#endif
