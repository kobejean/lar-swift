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

@interface LARMap: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) lar::Map* _internal;
#endif

@property(nonatomic,assign) id <LARMapDelegate> delegate;
@property(nonatomic,strong,readonly) NSArray<LARLandmark*>* landmarks;
@property(nonatomic,strong,readonly) NSArray<LARAnchor*>* anchors;

- (id)initWithContentsOf:(NSString*)filepath NS_SWIFT_NAME( init(contentsOf:) );

- (bool)globalPointFrom:(simd_double3)relative global:(simd_double3*) global;
- (bool)relativePointFrom:(simd_double3)global relative:(simd_double3*) relative;
- (CLLocation*)locationFrom:(LARAnchor*)anchor  NS_SWIFT_NAME( location(anchor:) );
- (void)add:(LARAnchor*)anchor;


#ifdef __cplusplus
    - (id)initWithInternal:(lar::Map*)map;
#endif

@end

@protocol LARMapDelegate<NSObject>

  @optional -(void)map:(LARMap *)map didAdd: (LARAnchor *)anchor;

@end

NS_ASSUME_NONNULL_END
