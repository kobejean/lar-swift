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
#import "Feature2D.h"

@class ALIKEDParams;



NS_ASSUME_NONNULL_BEGIN

// C++: class ALIKED
/**
 * ALIKED feature detector and descriptor extractor.
 *
 * ALIKED (A Lightweight Image KEYpoint Detector) is a CNN-based feature detector and descriptor
 * extractor, as described in *Cite:* Zhao23 . It produces 128-dimensional float descriptors and
 * keypoints with sub-pixel accuracy.
 *
 * The model expects RGB input [1,3,H,W] and internally converts BGR images to RGB.
 *
 * Member of `Features`
 */
CV_EXPORTS @interface ALIKED : Feature2D


#ifdef __cplusplus
@property(readonly)cv::Ptr<cv::ALIKED> nativePtrALIKED;
#endif

#ifdef __cplusplus
- (instancetype)initWithNativePtr:(cv::Ptr<cv::ALIKED>)nativePtr;
+ (instancetype)fromNative:(cv::Ptr<cv::ALIKED>)nativePtr;
#endif


#pragma mark - Methods


//
// static Ptr_ALIKED cv::ALIKED::create(String modelPath, ALIKED_Params params = ALIKED::Params())
//
/**
 * Creates ALIKED from a model file path.
 * @param modelPath Path to the ONNX model file.
 * @param params ALIKED parameters.
 */
+ (ALIKED*)create:(NSString*)modelPath params:(ALIKEDParams*)params NS_SWIFT_NAME(create(modelPath:params:));

/**
 * Creates ALIKED from a model file path.
 * @param modelPath Path to the ONNX model file.
 */
+ (ALIKED*)create:(NSString*)modelPath NS_SWIFT_NAME(create(modelPath:));



@end

NS_ASSUME_NONNULL_END


