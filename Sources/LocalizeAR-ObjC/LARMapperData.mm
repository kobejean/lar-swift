//
//  LARTracker.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <lar/mapping/mapper.h>

#import "LARMapperData.h"

@interface LARMapperData ()

@property(nonatomic,readwrite) lar::Mapper::Data* _internal;
@property(nonatomic,readwrite) LARMap* map;

@end

@implementation LARMapperData

- (id)initWithInternal:(lar::Mapper::Data*)data {
    self = [super init];
    self._internal = data;
    self.map = [[LARMap alloc] initWithInternal:&self._internal->map];
    return self;
}

- (NSArray<LARGPSObservation*>*)gpsObservations {
    int size = (int)self._internal->gps_obs.size();
    NSMutableArray<LARGPSObservation *> *observations = [[NSMutableArray<LARGPSObservation*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARGPSObservation *observation = [[LARGPSObservation alloc] initWithInternal: &self._internal->gps_obs[i]];
        [observations addObject: observation];
    }
    return [observations copy];
}

@end
