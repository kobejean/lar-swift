//
//  LARMapProcessing.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <geoar/processing/map_processing.h>
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARMapProcessing: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::MapProcessing _internal;
#endif


- (void)createMap:(NSString*)directory;

@end

NS_ASSUME_NONNULL_END
