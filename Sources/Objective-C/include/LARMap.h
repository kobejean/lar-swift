//
//  LARMap.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <geoar/core/map.h>
#endif

#import <Foundation/Foundation.h>
#import "LARLandmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface LARMap: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Map* _internal;
#endif

@property(nonatomic,readonly) NSArray<LARLandmark*> *landmarks;

- (id)initWithContentsOf:(NSString*)filepath NS_SWIFT_NAME( init(contentsOf:) );

#ifdef __cplusplus
    - (id)initWithInternal:(geoar::Map*)map;
#endif

@end

NS_ASSUME_NONNULL_END
