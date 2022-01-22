//
//  Map.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <geoar/core/map.h>
#endif

#import <Foundation/Foundation.h>
#import "Landmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface Map: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Map _internal;
#endif

@property(nonatomic,readonly) NSArray<Landmark*> *landmarks;

- (id)initFromFile:(NSString*)filepath;

@end

NS_ASSUME_NONNULL_END
