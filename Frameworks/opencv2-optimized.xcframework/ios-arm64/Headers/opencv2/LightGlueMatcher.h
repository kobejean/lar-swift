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
#import "DescriptorMatcher.h"

@class Mat;
@class Size2i;



NS_ASSUME_NONNULL_BEGIN

// C++: class LightGlueMatcher
/**
 * LightGlue feature matcher.
 *
 * LightGlue is a CNN-based feature matcher, as described in *Cite:* Lindenberger23 . It takes
 * keypoint locations and descriptors from two images and directly predicts match pairs. Unlike
 * traditional matchers that compute descriptor distances, LightGlue uses attention mechanisms
 * to produce confidence scores for each potential match pair.
 *
 * The matcher extends DescriptorMatcher and supports the standard match(), knnMatch(), and
 * radiusMatch() interfaces. Context (keypoints and image sizes) must be provided via
 * setPairInfo() before matching.
 *
 * Member of `Features`
 */
CV_EXPORTS @interface LightGlueMatcher : DescriptorMatcher


#ifdef __cplusplus
@property(readonly)cv::Ptr<cv::LightGlueMatcher> nativePtrLightGlueMatcher;
#endif

#ifdef __cplusplus
- (instancetype)initWithNativePtr:(cv::Ptr<cv::LightGlueMatcher>)nativePtr;
+ (instancetype)fromNative:(cv::Ptr<cv::LightGlueMatcher>)nativePtr;
#endif


#pragma mark - Methods


//
// static Ptr_LightGlueMatcher cv::LightGlueMatcher::create(String modelPath, float scoreThreshold = 0.0f, int backend = 0, int target = 0)
//
/**
 * Creates LightGlueMatcher from a model file path.
 * @param modelPath Path to the ONNX model file.
 * @param scoreThreshold Match confidence threshold.
 * @param backend DNN backend
 * @param target DNN target
 */
+ (LightGlueMatcher*)createFromFile:(NSString*)modelPath scoreThreshold:(float)scoreThreshold backend:(int)backend target:(int)target NS_SWIFT_NAME(create(modelPath:scoreThreshold:backend:target:));

/**
 * Creates LightGlueMatcher from a model file path.
 * @param modelPath Path to the ONNX model file.
 * @param scoreThreshold Match confidence threshold.
 * @param backend DNN backend
 */
+ (LightGlueMatcher*)createFromFile:(NSString*)modelPath scoreThreshold:(float)scoreThreshold backend:(int)backend NS_SWIFT_NAME(create(modelPath:scoreThreshold:backend:));

/**
 * Creates LightGlueMatcher from a model file path.
 * @param modelPath Path to the ONNX model file.
 * @param scoreThreshold Match confidence threshold.
 */
+ (LightGlueMatcher*)createFromFile:(NSString*)modelPath scoreThreshold:(float)scoreThreshold NS_SWIFT_NAME(create(modelPath:scoreThreshold:));

/**
 * Creates LightGlueMatcher from a model file path.
 * @param modelPath Path to the ONNX model file.
 */
+ (LightGlueMatcher*)createFromFile:(NSString*)modelPath NS_SWIFT_NAME(create(modelPath:));


//
//  void cv::LightGlueMatcher::setPairInfo(Mat queryKpts, Mat trainKpts, Size queryImageSize = Size(), Size trainImageSize = Size())
//
/**
 * Sets the keypoint and image size context for the next match() call.
 *
 *     This provides the spatial context that LightGlue needs in addition to descriptors.
 *     Must be called before match()/knnMatch()/radiusMatch() unless using automatic context
 *     from in-process ALIKED instances.
 *
 * @param queryKpts Query image keypoints (Nx2 float matrix with x,y coordinates).
 * @param trainKpts Train image keypoints (Nx2 float matrix with x,y coordinates).
 * @param queryImageSize Size of the query image (width, height).
 * @param trainImageSize Size of the train image (width, height).
 */
- (void)setPairInfo:(Mat*)queryKpts trainKpts:(Mat*)trainKpts queryImageSize:(Size2i*)queryImageSize trainImageSize:(Size2i*)trainImageSize NS_SWIFT_NAME(setPairInfo(queryKpts:trainKpts:queryImageSize:trainImageSize:));

/**
 * Sets the keypoint and image size context for the next match() call.
 *
 *     This provides the spatial context that LightGlue needs in addition to descriptors.
 *     Must be called before match()/knnMatch()/radiusMatch() unless using automatic context
 *     from in-process ALIKED instances.
 *
 * @param queryKpts Query image keypoints (Nx2 float matrix with x,y coordinates).
 * @param trainKpts Train image keypoints (Nx2 float matrix with x,y coordinates).
 * @param queryImageSize Size of the query image (width, height).
 */
- (void)setPairInfo:(Mat*)queryKpts trainKpts:(Mat*)trainKpts queryImageSize:(Size2i*)queryImageSize NS_SWIFT_NAME(setPairInfo(queryKpts:trainKpts:queryImageSize:));

/**
 * Sets the keypoint and image size context for the next match() call.
 *
 *     This provides the spatial context that LightGlue needs in addition to descriptors.
 *     Must be called before match()/knnMatch()/radiusMatch() unless using automatic context
 *     from in-process ALIKED instances.
 *
 * @param queryKpts Query image keypoints (Nx2 float matrix with x,y coordinates).
 * @param trainKpts Train image keypoints (Nx2 float matrix with x,y coordinates).
 */
- (void)setPairInfo:(Mat*)queryKpts trainKpts:(Mat*)trainKpts NS_SWIFT_NAME(setPairInfo(queryKpts:trainKpts:));


//
//  void cv::LightGlueMatcher::clearPairInfo()
//
/**
 * Clears stored pair context information.
 */
- (void)clearPairInfo NS_SWIFT_NAME(clearPairInfo());



@end

NS_ASSUME_NONNULL_END


