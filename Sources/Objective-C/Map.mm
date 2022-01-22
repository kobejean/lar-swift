//
//  Map.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <fstream>
#import "geoar/core/utils/json.h"

#import "Map.h"

@interface Map ()

@property(nonatomic,readwrite) geoar::Map _internal;

@end

@implementation Map

- (id)initFromFile:(NSString*)filepath {
    self = [super init];
    self._internal = nlohmann::json::parse(std::ifstream([filepath UTF8String]));
    return self;
}

- (NSArray<Landmark*>*)landmarks {
    int size = (int)self._internal.landmarks.size();
    NSMutableArray<Landmark *> *landmarks = [[NSMutableArray<Landmark*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        Landmark *landmark = [[Landmark alloc] initWithInternal: &self._internal.landmarks[i]];
        [landmarks addObject: landmark];
    }
    return [landmarks copy];
}

@end
