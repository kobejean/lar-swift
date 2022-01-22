//
//  MapProcessing.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//


#import <geoar/process/map_processing.h>

#import "MapProcessing.h"

@implementation MapProcessing

- (void)createMap:(NSString*)directory {
    std::string directory_string = std::string([directory UTF8String]);
    self._internal.createMap(directory_string, directory_string);
}

@end
