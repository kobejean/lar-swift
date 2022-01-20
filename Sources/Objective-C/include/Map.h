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

NS_ASSUME_NONNULL_BEGIN

@interface Map: NSObject

#ifdef __cplusplus
@property(nonatomic,readonly) geoar::Map _internal;
#endif

- (id)initFromFile:(NSString*)filepath;

@end

NS_ASSUME_NONNULL_END
