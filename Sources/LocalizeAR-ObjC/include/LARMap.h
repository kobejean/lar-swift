//
//  LARMap.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <lar/core/map.h>
#endif

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LARAnchor.h"
#import "LARLandmark.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LARMapDelegate;

@interface LARMap: NSObject {
#ifdef __cplusplus
    @public lar::Map* _internal;
#endif
}

@property(nonatomic,assign) id <LARMapDelegate> delegate;
@property(nonatomic,strong,readonly) NSArray<LARLandmark*>* landmarks;
@property(nonatomic,strong,readonly) NSArray<LARAnchor*>* anchors;
@property (nonatomic,strong,readonly) NSDictionary<NSNumber*, NSArray<NSNumber*>*>* edges;
@property(nonatomic,readonly) BOOL originReady;
@property(nonatomic,readonly) simd_double4x4 origin;

- (id)initWithContentsOf:(NSString*)filepath NS_SWIFT_NAME( init(contentsOf:) );
- (void)globalPointFromRelative:(simd_double3)relative global:(simd_double3*) global NS_SWIFT_NAME(globalPoint(from:global:));
- (void)globalPointFromAnchor:(LARAnchor*)anchor global:(simd_double3*) global NS_SWIFT_NAME(globalPoint(from:global:));
- (void)relativePointFrom:(simd_double3)global relative:(simd_double3*) relative NS_SWIFT_NAME(relativePoint(from:relative:));
- (LARAnchor*)createAnchor:(simd_float4x4)transform;
- (void)updateAnchor:(LARAnchor*)anchor transform:(simd_float4x4)transform;
- (void)removeAnchor:(LARAnchor*)anchor;
- (void)updateOrigin:(simd_double4x4)transform;
- (void)addEdgeFrom:(int)start_id to:(int)goal_id;
- (void)removeEdgeFrom:(int)start_id to:(int)goal_id;


#ifdef __cplusplus
    - (id)initWithInternal:(lar::Map*)map;
#endif

@end

@protocol LARMapDelegate<NSObject>

// Bulk operation callbacks (preferred)
@optional -(void)map:(LARMap *)map didAddAnchors:(NSArray<LARAnchor*> *)anchors;
@optional -(void)map:(LARMap *)map didUpdateAnchors:(NSArray<LARAnchor*> *)anchors;
@optional -(void)map:(LARMap *)map willRemoveAnchors:(NSArray<LARAnchor*> *)anchors;
@optional -(void)map:(LARMap *)map didUpdateOrigin:(simd_double4x4)transform;
@optional -(void)map:(LARMap *)map didAddEdgeFrom:(int)fromId to:(int)toId;
@optional -(void)map:(LARMap *)map didRemoveEdgeFrom:(int)fromId to:(int)toId;

@end

NS_ASSUME_NONNULL_END
