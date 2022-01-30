//
//  LARMap.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <iostream>
#import <fstream>
#import "lar/core/utils/json.h"

#import "LARMap.h"

@interface LARMap ()

@property(nonatomic,readwrite) lar::Map* _internal;

@end

@implementation LARMap

- (id)initWithContentsOf:(NSString*)filepath {
    self = [super init];
    nlohmann::json json = nlohmann::json::parse(std::ifstream([filepath UTF8String]));
    lar::Map* map = new lar::Map();
    lar::from_json(json, *map);
    self._internal = map;
    return self;
}

- (id)initWithInternal:(lar::Map*)map {
    self = [super init];
    self._internal = map;
    return self;
}

- (NSArray<LARLandmark*>*)landmarks {
    int size = (int)self._internal->landmarks.size();
    NSMutableArray<LARLandmark *> *landmarks = [[NSMutableArray<LARLandmark*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARLandmark *landmark = [[LARLandmark alloc] initWithInternal: &self._internal->landmarks[i]];
        [landmarks addObject: landmark];
    }
    return [landmarks copy];
}

@end
