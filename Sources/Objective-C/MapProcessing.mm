//
//  MapProcessing.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <geoar/process/map_processing.h>
#pragma clang diagnostic pop

#import "MapProcessing.h"

@implementation MapProcessing

- (void)createMap:(NSString*)directory {
    std::string directory_string = std::string([directory UTF8String]);
    self._internal.createMap(directory_string, directory_string);
}

@end
