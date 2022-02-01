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
#import "LARLandmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface LARMap: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) lar::Map* _internal;
#endif

@property(nonatomic,readonly) NSArray<LARLandmark*> *landmarks;

- (id)initWithContentsOf:(NSString*)filepath NS_SWIFT_NAME( init(contentsOf:) );

- (simd_double3)globalPointFrom:(simd_double3)relative;
- (simd_double3)relativePointFrom:(simd_double3)global;

#ifdef __cplusplus
    - (id)initWithInternal:(lar::Map*)map;
#endif

@end

NS_ASSUME_NONNULL_END
