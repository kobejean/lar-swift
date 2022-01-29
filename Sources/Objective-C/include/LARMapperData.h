//
//  Tracking.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <geoar/mapping/mapper.h>
#endif

#import "LARMap.h"
#import "LARGPSObservation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LARMapper.Data)
@interface LARMapperData: NSObject

@property(nonatomic,readonly) LARMap* map;
@property(nonatomic,readonly) NSArray<LARGPSObservation*>* gps_observations;

#ifdef __cplusplus
    @property(nonatomic,readonly) geoar::Mapper::Data* _internal;

    - (id)initWithInternal:(geoar::Mapper::Data*)data;
#endif


@end

NS_ASSUME_NONNULL_END
