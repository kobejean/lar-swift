//
// This file is auto-generated. Please don't modify it!
//
#pragma once

#ifdef __cplusplus
//#import "opencv.hpp"
#import "opencv2/features.hpp"
#else
#define CV_EXPORTS
#endif

#import <Foundation/Foundation.h>


@class Size2i;



NS_ASSUME_NONNULL_BEGIN

// C++: class Params
/**
 * The Params module
 *
 * Member of `Features`
 */
CV_EXPORTS @interface ALIKEDParams : NSObject


#ifdef __cplusplus
@property(readonly)cv::Ptr<cv::ALIKED::Params> nativePtr;
#endif

#ifdef __cplusplus
- (instancetype)initWithNativePtr:(cv::Ptr<cv::ALIKED::Params>)nativePtr;
+ (instancetype)fromNative:(cv::Ptr<cv::ALIKED::Params>)nativePtr;
#endif


#pragma mark - Methods


//
//   cv::ALIKED::Params::Params()
//
- (instancetype)init;


    //
    // C++: Size cv::ALIKED::Params::inputSize
    //

@property Size2i* inputSize;

    //
    // C++: bool cv::ALIKED::Params::normalizeDescriptors
    //

@property BOOL normalizeDescriptors;

    //
    // C++: int cv::ALIKED::Params::engine
    //

@property int engine;

    //
    // C++: int cv::ALIKED::Params::backend
    //

@property int backend;

    //
    // C++: int cv::ALIKED::Params::target
    //

@property int target;


@end

NS_ASSUME_NONNULL_END


