//
//  LARTracker.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <geoar/mapping/mapper.h>

#import "LARMapperData.h"

@interface LARMapperData ()

@property(nonatomic,readwrite) geoar::Mapper::Data* _internal;
@property(nonatomic,readwrite) LARMap* map;

@end

@implementation LARMapperData

- (id)initWithInternal:(geoar::Mapper::Data*)data {
    self = [super init];
    self._internal = data;
    self.map = [[LARMap alloc] initWithInternal:&self._internal->map];
    return self;
}

- (NSArray<LARGPSObservation*>*)gps_observations {
    int size = (int)self._internal->gps_observations.size();
    NSMutableArray<LARGPSObservation *> *observations = [[NSMutableArray<LARGPSObservation*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARGPSObservation *observation = [[LARGPSObservation alloc] initWithInternal: &self._internal->gps_observations[i]];
        [observations addObject: observation];
    }
    return [observations copy];
}

@end
