//
//  LARMap.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <fstream>
#import "geoar/core/utils/json.h"

#import "LARMap.h"

@interface LARMap ()

@property(nonatomic,readwrite) geoar::Map _internal;

@end

@implementation LARMap

- (id)initFromFile:(NSString*)filepath {
    self = [super init];
    self._internal = nlohmann::json::parse(std::ifstream([filepath UTF8String]));
    return self;
}

- (NSArray<LARLandmark*>*)landmarks {
    int size = (int)self._internal.landmarks.size();
    NSMutableArray<LARLandmark *> *landmarks = [[NSMutableArray<LARLandmark*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARLandmark *landmark = [[LARLandmark alloc] initWithInternal: &self._internal.landmarks[i]];
        [landmarks addObject: landmark];
    }
    return [landmarks copy];
}

@end
