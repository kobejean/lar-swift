//
//  Map.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#include <fstream>
#include "geoar/core/utils/json.h"

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

@end
