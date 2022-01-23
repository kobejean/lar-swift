//
//  Collection.mm
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#include <filesystem>

#import <geoar/collection/collection.h>

#import "Helpers/LARConversion.h"
#import "LARCollection.h"


namespace fs = std::filesystem;

@interface LARCollection ()

@property(nonatomic,readwrite) geoar::Collection* _internal;
@property(nonatomic,retain,readwrite) NSURL* directory;

@end

@implementation LARCollection

- (id)initWithDirectory:(NSURL*)directory {
    fs::path path = [[directory path] UTF8String];
    self = [super init];
    self._internal = new geoar::Collection(path);
    self.directory = directory;
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
    geoar::Collection::FrameMetadata metadata{
        .timestamp=[LARConversion timestampFromInterval:frame.timestamp],
        .intrinsics=[LARConversion eigenFromSIMD3:frame.camera.intrinsics].cast<double>(),
        .extrinsics=[LARConversion eigenFromSIMD4:frame.camera.transform].cast<double>(),
    };
    
    self._internal->addFrame(image, depth, confidence, metadata);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferUnlockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferUnlockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
}


- (void)addGPSObservation:(CLLocation*)location position:(simd_float3)position {
    geoar::Collection::GPSObservation observation{
        .timestamp=(long int)round(location.timestamp.timeIntervalSince1970 * 1e3),
        .relative{ position.x, position.y, position.z },
        .global{ location.coordinate.latitude, location.coordinate.longitude, location.altitude },
        .accuracy{ location.horizontalAccuracy, location.horizontalAccuracy, location.verticalAccuracy }
    };
    
    self._internal->addGPSObservation(observation);
}

@end
