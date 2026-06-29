//
//  LARMapper.mm
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#include <filesystem>

#import <opencv2/imgproc.hpp>

#import <lar/mapping/mapper.h>

#import "Helpers/LARConversion.h"
#import "LARMapper.h"
#import "LARMapperData.h"


namespace fs = std::filesystem;

@interface LARMapper ()

@property(nonatomic,retain,readwrite) NSURL* directory;
@property(nonatomic,strong,readwrite) LARMapperData* data;


@end

@implementation LARMapper

- (id)initWithDirectory:(NSURL*)directory {
    fs::path path = [[directory path] UTF8String];
    self = [super init];
    _internal = new lar::Mapper(path);
    self.directory = directory;
    self.data = [[LARMapperData alloc] initWithInternal: _internal->data];
    return self;
}

- (void)dealloc {
    delete _internal;
}

- (void)readMetadata {
    self->_internal->readMetadata();
}

- (void)writeMetadata {
    self->_internal->writeMetadata();
}

- (LARAnchor*)createAnchor:(simd_float4x4)transform {
    auto _transform = [LARConversion transform3dFromSIMD4x4f: transform];
    LARAnchor *anchor = [[LARAnchor alloc] initWithInternal: &_internal->createAnchor(_transform)];
    return anchor;
}

- (void)addPosition:(simd_float3)position timestamp:(NSDate*)timestamp {
	long long time = (long long)round(1000 * timestamp.timeIntervalSince1970);
	self->_internal->addPosition({ position.x, position.y, position.z }, time);
}

- (void)addLocation:(CLLocation*)location {
	long long time = (long long)round(1000 * location.timestamp.timeIntervalSince1970);
	Eigen::Vector3d loc{location.coordinate.latitude, location.coordinate.longitude, location.altitude};
	Eigen::Vector3d acc{location.horizontalAccuracy, location.horizontalAccuracy, location.verticalAccuracy};
	self->_internal->addLocation(loc, acc, time);
}

#if TARGET_OS_IPHONE

- (void)addFrame:(ARFrame*)frame transform:(simd_float4x4)transform {
    [self addFramePixelBuffer:frame.capturedImage
                   intrinsics:frame.camera.intrinsics
                    timestamp:frame.timestamp
                    transform:transform];
}

- (void)addFramePixelBuffer:(CVPixelBufferRef)imageBuffer
                 intrinsics:(simd_float3x3)intrinsics
                  timestamp:(NSTimeInterval)timestamp
                  transform:(simd_float4x4)transform {
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    // Capture in color during mapping. ARKit's captured image is biplanar YCbCr
    // (plane 0 = full-res luma, plane 1 = half-res CbCr); combine both planes into BGR.
    // Localization uses grayscale (luma plane) directly elsewhere for efficiency.
    cv::Mat luma = [LARConversion matFromBuffer:imageBuffer planeIndex:0 type: CV_8UC1];
    cv::Mat chroma = [LARConversion matFromBuffer:imageBuffer planeIndex:1 type: CV_8UC2];
    cv::Mat image;
    cv::cvtColorTwoPlane(luma, chroma, image, cv::COLOR_YUV2BGR_NV12);

    lar::Frame aFrame;
    aFrame.timestamp = [LARConversion timestampFromInterval:timestamp];
    aFrame.intrinsics = [LARConversion eigenFromSIMD3:intrinsics].cast<double>();
    aFrame.extrinsics = [LARConversion eigenFromSIMD4:transform].cast<double>();

    // Depth/confidence intentionally omitted (LiDAR disabled): pass empty mats so the
    // mapper skips writing depth.pfm/confidence.pfm. The COLMAP pipeline doesn't use them.
    _internal->addFrame(aFrame, image, cv::Mat(), cv::Mat());

    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
}

#endif

@end
