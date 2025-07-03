//
//  LARFrame.mm
//  
//
//  Created by Jean Flaherty on 2025-07-03.
//

#import <iostream>
#import <fstream>
#import <vector>
#import "lar/core/utils/json.h"
#import "lar/mapping/frame.h"

#import "LARFrame.h"

@implementation LARFrame

- (instancetype)init {
    self = [super init];
    if (self) {
        self->_internal = new lar::Frame();
        self->_internal->id = 0;
        self->_internal->timestamp = 0;
    }
    return self;
}

- (void)dealloc {
    delete self->_internal;
}

- (NSInteger)frameId {
    return self->_internal->id;
}

- (NSInteger)timestamp {
    return self->_internal->timestamp;
}

@end