//
//  LARMapperData.h
//
//
//  Created by Jean Flaherty on 2021/12/26.
//

#pragma once

#ifdef __cplusplus
    #import <lar/mapping/mapper.h>
#endif

#import "LARMap.h"
#import "LARGPSObservation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LARMapper.Data)
@interface LARMapperData: NSObject {
#ifdef __cplusplus
    @public std::shared_ptr<lar::Mapper::Data> _internal;
#endif
}

@property(nonatomic,strong,readonly) LARMap* map;
@property(nonatomic,readonly) NSArray<LARGPSObservation*>* gpsObservations;

#ifdef __cplusplus
    - (id)initWithInternal:(std::shared_ptr<lar::Mapper::Data>)data;
#endif


@end

NS_ASSUME_NONNULL_END
