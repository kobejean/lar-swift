//
//  LARTracker.mm
//  
//
//  Created by Jean Flaherty on 2021/12/26.
//

#import <lar/tracking/tracker.h>

#import "LARTracker.h"

@interface LARTracker ()

@property(nonatomic,readwrite) lar::Tracker *_internal;
@property(nonatomic,retain,readwrite) LARMap* map;

@end

@implementation LARTracker

- (id)initWithMap:(LARMap*)map {
    self = [super init];
    self._internal = new lar::Tracker(*map._internal);
    self.map = map;
    return self;
}

- (void)dealloc {
    delete self._internal;
}


- (bool)localize:(Mat*)image intrinsics:(Mat*)intrinsics transform:(Mat*)transform {
    return self._internal->localize(image.nativeRef, intrinsics.nativeRef, transform.nativeRef);
}

- (NSArray<LARLandmark*>*)local_landmarks {
    int size = (int)self._internal->local_landmarks.size();
    NSMutableArray<LARLandmark *> *local_landmarks = [[NSMutableArray<LARLandmark*> alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        LARLandmark *landmark = [[LARLandmark alloc] initWithInternal: &self._internal->local_landmarks[i]];
        [local_landmarks addObject: landmark];
    }
    return [local_landmarks copy];
}

@end
