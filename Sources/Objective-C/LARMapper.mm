//
//  Collection.mm
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#include <filesystem>

#import <geoar/mapping/mapper.h>

#import "Helpers/LARConversion.h"
#import "LARMapper.h"
#import "LARMapperData.h"


namespace fs = std::filesystem;

@interface LARMapper ()

@property(nonatomic,readwrite) geoar::Mapper* _internal;
@property(nonatomic,retain,readwrite) NSURL* directory;
@property(nonatomic,readwrite) LARMapperData* data;


@end

@implementation LARMapper

- (id)initWithDirectory:(NSURL*)directory {
    fs::path path = [[directory path] UTF8String];
    self = [super init];
    self._internal = new geoar::Mapper(path);
    self.directory = directory;
    self.data = [[LARMapperData alloc] initWithInternal:&self._internal->data];
    return self;
}

- (void)dealloc {
    delete self._internal;
}


- (void)addFrame:(ARFrame*)frame {
    CVPixelBufferRef imageBuffer = frame.capturedImage;
    CVPixelBufferRef depthBuffer = frame.smoothedSceneDepth.depthMap;
    CVPixelBufferRef confidenceBuffer = frame.smoothedSceneDepth.confidenceMap;
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferLockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferLockBaseAddress(confidenceBuffer, kCVPixelBufferLock_ReadOnly);
    
    // Convert inputs
    cv::Mat image = [LARConversion matFromBuffer:imageBuffer planeIndex:0 type: CV_8UC1];
    cv::Mat depth = [LARConversion matFromBuffer:depthBuffer planeIndex:0 type: CV_32FC1];
    cv::Mat confidence = [LARConversion matFromBuffer:confidenceBuffer planeIndex:0 type: CV_8UC1];
    geoar::Frame aFrame;
    aFrame.timestamp = [LARConversion timestampFromInterval:frame.timestamp];
    aFrame.intrinsics = [LARConversion eigenFromSIMD3:frame.camera.intrinsics].cast<double>();
    aFrame.extrinsics = [LARConversion eigenFromSIMD4:frame.camera.transform].cast<double>();
    
    self._internal->addFrame(aFrame, image, depth, confidence);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferUnlockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferUnlockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
}


- (void)addPosition:(simd_float3)position timestamp:(NSDate*)timestamp {
    long long time = (long long)round(1000 * timestamp.timeIntervalSince1970);
    self._internal->addPosition({ position.x, position.y, position.z }, time);
}


- (void)addLocation:(CLLocation*)location {
    long long time = (long long)round(1000 * location.timestamp.timeIntervalSince1970);
    Eigen::Vector3d loc{location.coordinate.latitude, location.coordinate.longitude, location.altitude};
    Eigen::Vector3d acc{location.horizontalAccuracy, location.horizontalAccuracy, location.verticalAccuracy};
    self._internal->addLocation(loc, acc, time);
}

- (void)writeMetadata {
    self._internal->writeMetadata();
}

@end
