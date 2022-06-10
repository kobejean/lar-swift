//
//  LARMap.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <iostream>
#import <fstream>
#import "lar/core/utils/json.h"

#import "Helpers/LARConversion.h"
#import "LARMap.h"
#import <CoreLocation/CoreLocation.h>

@interface LARMap ()

@property(nonatomic,readwrite) lar::Map* _internal;

@end

@implementation LARMap

- (id)initWithContentsOf:(NSString*)filepath {
    self = [super init];
    nlohmann::json json = nlohmann::json::parse(std::ifstream([filepath UTF8String]));
    lar::Map* map = new lar::Map();
    lar::from_json(json, *map);
    self._internal = map;
    return self;
}

- (void)dealloc {
    delete self._internal;
}

- (bool)globalPointFrom:(simd_double3)relative global:(simd_double3*) global {
    Eigen::Vector3d _relative = [LARConversion vector3dFromSIMD3:relative];
    Eigen::Vector3d _global;
    bool success = self._internal->globalPointFrom(_relative, _global);
    *global = [LARConversion simd3FromVector3d:_global];
    return success;
}

- (bool)relativePointFrom:(simd_double3)global relative:(simd_double3*) relative {
    Eigen::Vector3d _global = [LARConversion vector3dFromSIMD3:global];
    Eigen::Vector3d _relative;
    bool success = self._internal->relativePointFrom(_global, _relative);
    *relative = [LARConversion simd3FromVector3d:_relative];
    return success;
}

- (CLLocation*)locationFrom:(LARAnchor*) anchor {
    Eigen::Matrix4d transform = (self._internal->origin * anchor._internal->transform).matrix();
    return [[CLLocation alloc] initWithLatitude:transform(0,0) longitude:transform(0,1)];
}

- (void)add:(LARAnchor*)anchor {
    anchor.id = (int) self._internal->anchors.size();
    size_t idx = self._internal->anchors.size();
    self._internal->anchors.push_back(*anchor._internal);
    anchor._internal = &self._internal->anchors[idx];
    
    if ([self.delegate respondsToSelector:@selector(map:didAdd:)]) {
        [self.delegate map:self didAdd:anchor];
    }
}

- (id)initWithInternal:(lar::Map*)map {
    self = [super init];
    self._internal = map;
    return self;
}

- (NSArray<LARLandmark*>*)landmarks {
    int size = (int)self._internal->landmarks.size();
    NSMutableArray<LARLandmark *> *landmarks = [[NSMutableArray<LARLandmark*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARLandmark *landmark = [[LARLandmark alloc] initWithInternal: &self._internal->landmarks[i]];
        [landmarks addObject: landmark];
    }
    return [landmarks copy];
}

- (NSArray<LARAnchor*>*)anchors {
    int size = (int)self._internal->anchors.size();
    NSMutableArray<LARAnchor *> *anchors = [[NSMutableArray<LARAnchor*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARAnchor *anchor = [[LARAnchor alloc] initWithInternal: &self._internal->anchors[i]];
        [anchors addObject: anchor];
    }
    return [anchors copy];
}

@end
