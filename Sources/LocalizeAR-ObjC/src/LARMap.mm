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

@end

@implementation LARMap;

- (id)initWithContentsOf:(NSString*)filepath {
    if (self = [super init]) {
        nlohmann::json json = nlohmann::json::parse(std::ifstream([filepath UTF8String]));
        lar::Map* map = new lar::Map();
        lar::from_json(json, *map);
        self->_internal = map;
    }
    return self;
}

- (void)dealloc {
    // TODO: see how to dealloc
//    delete self->_internal;
}

- (void)globalPointFromRelative:(simd_double3)relative global:(simd_double3*) global {
    Eigen::Vector3d _relative = [LARConversion vector3dFromSIMD3:relative];
    Eigen::Vector3d _global;
    self->_internal->globalPointFrom(_relative, _global);
    *global = [LARConversion simd3FromVector3d:_global];
}

- (void)globalPointFromAnchor:(LARAnchor*)anchor global:(simd_double3*) global {
    Eigen::Vector3d _global;
    self->_internal->globalPointFrom(*anchor->_internal, _global);
    *global = [LARConversion simd3FromVector3d:_global];
}

- (void)relativePointFrom:(simd_double3)global relative:(simd_double3*) relative {
    Eigen::Vector3d _global = [LARConversion vector3dFromSIMD3:global];
    Eigen::Vector3d _relative;
    self->_internal->relativePointFrom(_global, _relative);
    *relative = [LARConversion simd3FromVector3d:_relative];
}

- (LARAnchor*)createAnchor:(simd_float4x4)transform {
    auto _transform = [LARConversion transform3dFromSIMD4x4f: transform];
    LARAnchor *anchor = [[LARAnchor alloc] initWithInternal: &_internal->createAnchor(_transform)];
    return anchor;
}

- (void)updateAnchor:(LARAnchor*)anchor transform:(simd_float4x4)transform {
    auto _transform = [LARConversion transform3dFromSIMD4x4f: transform];
    _internal->updateAnchor(*anchor->_internal, _transform);
}

- (void)removeAnchor:(LARAnchor*)anchor {
    _internal->removeAnchor(*anchor->_internal);
}

- (void)updateOrigin:(simd_double4x4)transform {
    auto _transform = [LARConversion transform3dFromSIMD4x4d: transform];
    _internal->updateOrigin(_transform);
}

- (simd_double4x4)origin {
    return [LARConversion simd4x4FromTransform3d:_internal->origin];
}

- (void)addEdgeFrom:(int)start_id to: (int)goal_id {
    _internal->addEdge(start_id, goal_id);
}

- (id)initWithInternal:(lar::Map*)map {
    self = [super init];
    self->_internal = map;
    return self;
}

- (BOOL)originReady {
    return _internal ? _internal->origin_ready : NO;
}

- (NSArray<LARLandmark*>*)landmarks {
    int size = (int)self->_internal->landmarks.size();
    NSMutableArray<LARLandmark *> *landmarks = [[NSMutableArray<LARLandmark*> alloc] initWithCapacity: size];
    for (lar::Landmark *_landmark : self->_internal->landmarks.all()) {
        LARLandmark *landmark = [[LARLandmark alloc] initWithInternal: _landmark];
        [landmarks addObject: landmark];
    }
    return [landmarks copy];
}

- (NSArray<LARAnchor*>*)anchors {
    int size = (int)self->_internal->anchors.size();
    NSMutableArray<LARAnchor *> *anchors = [[NSMutableArray<LARAnchor*> alloc] initWithCapacity: size];
    for (const auto& pair : self->_internal->anchors) {
        LARAnchor *anchor = [[LARAnchor alloc] initWithInternal: const_cast<lar::Anchor*>(&pair.second)];
        [anchors addObject: anchor];
    }
    return [anchors copy];
}

- (NSDictionary<NSNumber*, NSArray<NSNumber*>*>*)edges {
	if (!_internal) {
		return @{};
	}
	
	NSMutableDictionary<NSNumber*, NSArray<NSNumber*>*>* objcEdges = [[NSMutableDictionary alloc] init];
	
	for (const auto& pair : _internal->edges) {
		NSNumber* key = [NSNumber numberWithInt:(int32_t)pair.first];
		
		NSMutableArray<NSNumber*>* values = [[NSMutableArray alloc] initWithCapacity:pair.second.size()];
		for (std::size_t value : pair.second) {
			[values addObject:[NSNumber numberWithInt:(int32_t)value]];
		}
		
		objcEdges[key] = [values copy];
	}
	
	return [objcEdges copy];
}

- (void)setDelegate:(id<LARMapDelegate>)delegate {
    _delegate = delegate;
    if (delegate && _internal) {
        __weak LARMap* weakSelf = self;
        
        _internal->setDidAddAnchorCallback([weakSelf](lar::Anchor& anchor) {
            LARMap* strongSelf = weakSelf;
            if (strongSelf && strongSelf.delegate) {
                LARAnchor* objcAnchor = [[LARAnchor alloc] initWithInternal:&anchor];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([strongSelf.delegate respondsToSelector:@selector(map:didAdd:)]) {
                        [strongSelf.delegate map:strongSelf didAdd:objcAnchor];
                    }
                });
            }
        });
        
        _internal->setDidUpdateAnchorCallback([weakSelf](lar::Anchor& anchor) {
            LARMap* strongSelf = weakSelf;
            if (strongSelf && strongSelf.delegate) {
                LARAnchor* objcAnchor = [[LARAnchor alloc] initWithInternal:&anchor];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([strongSelf.delegate respondsToSelector:@selector(map:didUpdate:)]) {
                        [strongSelf.delegate map:strongSelf didUpdate:objcAnchor];
                    }
                });
            }
        });
        
        _internal->setWillRemoveAnchorCallback([weakSelf](lar::Anchor& anchor) {
            LARMap* strongSelf = weakSelf;
            if (strongSelf && strongSelf.delegate) {
                LARAnchor* objcAnchor = [[LARAnchor alloc] initWithInternalCopy:&anchor];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([strongSelf.delegate respondsToSelector:@selector(map:willRemove:)]) {
                        [strongSelf.delegate map:strongSelf willRemove:objcAnchor];
                    }
                });
            }
        });
        
        _internal->setDidUpdateOriginCallback([weakSelf](const lar::Map::Transform& transform) {
            LARMap* strongSelf = weakSelf;
            if (strongSelf && strongSelf.delegate) {
                simd_double4x4 simdTransform = [LARConversion simd4x4FromTransform3d:transform];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([strongSelf.delegate respondsToSelector:@selector(map:didUpdateOrigin:)]) {
                        [strongSelf.delegate map:strongSelf didUpdateOrigin:simdTransform];
                    }
                });
            }
        });
    } else if (_internal) {
        _internal->setDidAddAnchorCallback([](lar::Anchor& anchor) {});
        _internal->setDidUpdateAnchorCallback([](lar::Anchor& anchor) {});
        _internal->setWillRemoveAnchorCallback([](lar::Anchor& anchor) {});
        _internal->setDidUpdateOriginCallback([](const lar::Map::Transform& transform) {});
    }
}

@end
