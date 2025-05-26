//
//  LARMapProcessing.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//


#import <lar/processing/map_processor.h>

#import "LARMapProcessor.h"

@interface LARMapProcessor ()

@property(nonatomic,readwrite) lar::MapProcessor* _internal;

@end

@implementation LARMapProcessor

- (id)initWithMapperData:(LARMapperData*)data {
    self = [super init];
    self._internal = new lar::MapProcessor(data->_internal);
    return self;
}

- (void)dealloc {
    delete self._internal;
}

- (void)process {
    self._internal->process();
}

- (void)saveMap:(NSString*)directory {
    std::string directory_string = std::string([directory UTF8String]);
    self._internal->saveMap(directory_string);
}

@end
