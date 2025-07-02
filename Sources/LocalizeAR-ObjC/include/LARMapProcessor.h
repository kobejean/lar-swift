//
//  LARMapProcessor.h
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <lar/processing/map_processor.h>
#endif

#import "LARMapperData.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LARMapProcessor: NSObject

#ifdef __cplusplus
    @property(nonatomic,readonly) lar::MapProcessor* _internal;
#endif

- (id)initWithMapperData:(LARMapperData*)data;

- (void)process;
- (void)rescale:(double)scaleFactor;
- (void)saveMap:(NSString*)directory;
- (void)updateGlobalAlignment;

@end

NS_ASSUME_NONNULL_END
