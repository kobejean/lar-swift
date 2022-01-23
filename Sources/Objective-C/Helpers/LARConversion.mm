//
//  LARConversion.mm
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <CoreVideo/CoreVideo.h>

#import <geoar/tracking/tracking.h>

#import "Helpers/LARConversion.h"


@implementation LARConversion

+ (long int)timestampFromInterval:(NSTimeInterval)interval {
    double offset = [[NSDate date] timeIntervalSince1970] - [NSProcessInfo processInfo].systemUptime;
    return (long int) round((offset + interval) * 1e3);
}

+ (Eigen::Matrix3f)eigenFromSIMD3:(simd_float3x3)simd {
    Eigen::Matrix3f matrix;
    matrix << simd.columns[0][0], simd.columns[1][0], simd.columns[2][0],
              simd.columns[0][1], simd.columns[1][1], simd.columns[2][1],
              simd.columns[0][2], simd.columns[1][2], simd.columns[2][2];
    return matrix;
}

+ (Eigen::Matrix4f)eigenFromSIMD4:(simd_float4x4)simd {
    Eigen::Matrix4f matrix;
    matrix << simd.columns[0][0], simd.columns[1][0], simd.columns[2][0], simd.columns[3][0],
              simd.columns[0][1], simd.columns[1][1], simd.columns[2][1], simd.columns[3][1],
              simd.columns[0][2], simd.columns[1][2], simd.columns[2][2], simd.columns[3][2],
              simd.columns[0][3], simd.columns[1][3], simd.columns[2][3], simd.columns[3][3];
    return matrix;
}

+ (cv::Mat)matFromBuffer:(CVPixelBufferRef)buffer planeIndex:(size_t)planeIndex type:(int)type {
    int width = (int) CVPixelBufferGetWidthOfPlane(buffer, planeIndex);
    int height = (int) CVPixelBufferGetHeightOfPlane(buffer, planeIndex);
    void * data = CVPixelBufferGetBaseAddressOfPlane(buffer, planeIndex);
    return cv::Mat(height, width, type, data);
}

@end
