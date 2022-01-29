//
//  LARMapProcessing.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//


#import <geoar/processing/map_processor.h>

#import "LARMapProcessor.h"

@interface LARMapProcessor ()

@property(nonatomic,readwrite) geoar::MapProcessor* _internal;

@end

@implementation LARMapProcessor

- (id)initWithMapperData:(LARMapperData*)data {
    self = [super init];
    self._internal = new geoar::MapProcessor(*data._internal);
    return self;
}

- (void)dealloc {
    delete self._internal;
}

- (void)process {
    self._internal->process();
}

- (void)createMap:(NSString*)directory {
    std::string directory_string = std::string([directory UTF8String]);
    self._internal->createMap(directory_string);
}

@end
