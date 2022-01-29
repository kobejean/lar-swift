//
//  LARTracker.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <geoar/tracking/tracker.h>

#import "LARTracker.h"

@interface LARTracker ()

@property(nonatomic,readwrite) geoar::Tracker* _internal;
@property(nonatomic,retain,readwrite) LARMap* map;

@end

@implementation LARTracker

- (id)initWithMap:(LARMap*)map {
    self = [super init];
    self._internal = new geoar::Tracker(*map._internal);
    self.map = map;
    return self;
}

- (void)dealloc {
    delete self._internal;
}


- (void)localize:(Mat*)image intrinsics:(Mat*)intrinsics transform:(Mat*)transform {
    self._internal->localize(image.nativeRef, intrinsics.nativeRef, transform.nativeRef);
}

@end
