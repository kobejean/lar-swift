//
// This file is auto-generated. Please don't modify it!
//
#pragma once

#ifdef __cplusplus
//#import "opencv.hpp"
#import "opencv2/geometry.hpp"
#import "opencv2/geometry/mst.hpp"
#else
#define CV_EXPORTS
#endif

#import <Foundation/Foundation.h>






NS_ASSUME_NONNULL_BEGIN

// C++: class MSTEdge
/**
 * Represents an edge in a graph for Minimum Spanning Tree (MST) computation.
 *
 * Each edge connects two nodes (source and target) and has an associated weight.
 *
 * Member of `Geometry`
 */
CV_EXPORTS @interface MSTEdge : NSObject


#ifdef __cplusplus
@property(readonly)cv::Ptr<cv::MSTEdge> nativePtr;
#endif

#ifdef __cplusplus
- (instancetype)initWithNativePtr:(cv::Ptr<cv::MSTEdge>)nativePtr;
+ (instancetype)fromNative:(cv::Ptr<cv::MSTEdge>)nativePtr;
#endif


#pragma mark - Methods


    //
    // C++: int cv::MSTEdge::source
    //

@property int source;

    //
    // C++: int cv::MSTEdge::target
    //

@property int target;

    //
    // C++: double cv::MSTEdge::weight
    //

@property double weight;


@end

NS_ASSUME_NONNULL_END


