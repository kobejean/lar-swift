//
//  LARTracking.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <geoar/tracking/tracking.h>

#import "LARTracking.h"

@interface LARTracking ()

@property(nonatomic,readwrite) geoar::Tracking* _internal;
@property(nonatomic,retain,readwrite) LARMap* map;

@end

@implementation LARTracking

- (id)initWithMap:(LARMap*)map {
    self = [super init];
    self._internal = new geoar::Tracking(map._internal);
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
