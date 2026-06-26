//
// This file is auto-generated. Please don't modify it!
//
#pragma once

#ifdef __cplusplus
//#import "opencv.hpp"
#import "opencv2/imgproc.hpp"
#else
#define CV_EXPORTS
#endif

#import <Foundation/Foundation.h>






NS_ASSUME_NONNULL_BEGIN

// C++: class Filter2DParams
/**
 * The Filter2DParams module
 *
 * Member of `Imgproc`
 */
CV_EXPORTS @interface Filter2DParams : NSObject


#ifdef __cplusplus
@property(readonly)cv::Ptr<cv::Filter2DParams> nativePtr;
#endif

#ifdef __cplusplus
- (instancetype)initWithNativePtr:(cv::Ptr<cv::Filter2DParams>)nativePtr;
+ (instancetype)fromNative:(cv::Ptr<cv::Filter2DParams>)nativePtr;
#endif


#pragma mark - Methods


    //
    // C++: int cv::Filter2DParams::anchorX
    //

@property int anchorX;

    //
    // C++: int cv::Filter2DParams::anchorY
    //

@property int anchorY;

    //
    // C++: int cv::Filter2DParams::borderType
    //

@property int borderType;

    //
    // C++: int cv::Filter2DParams::ddepth
    //

@property int ddepth;

    //
    // C++: double cv::Filter2DParams::scale
    //

@property double scale;

    //
    // C++: double cv::Filter2DParams::shift
    //

@property double shift;


@end

NS_ASSUME_NONNULL_END


