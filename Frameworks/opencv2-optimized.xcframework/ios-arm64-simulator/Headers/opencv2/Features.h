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

@class ByteVector;
@class DMatch;
@class KeyPoint;
@class Mat;
@class Scalar;


// C++: enum DrawMatchesFlags (cv.DrawMatchesFlags)
typedef NS_ENUM(int, DrawMatchesFlags) {
    DrawMatchesFlags_DEFAULT NS_SWIFT_NAME(DEFAULT) = 0,
    DrawMatchesFlags_DRAW_OVER_OUTIMG NS_SWIFT_NAME(DRAW_OVER_OUTIMG) = 1,
    DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS NS_SWIFT_NAME(NOT_DRAW_SINGLE_POINTS) = 2,
    DrawMatchesFlags_DRAW_RICH_KEYPOINTS NS_SWIFT_NAME(DRAW_RICH_KEYPOINTS) = 4
};



NS_ASSUME_NONNULL_BEGIN

// C++: class Features
/**
 * The Features module
 *
 * Member classes: `Feature2D`, `AffineFeature`, `SIFT`, `ORB`, `MSER`, `FastFeatureDetector`, `GFTTDetector`, `SimpleBlobDetector`, `SimpleBlobDetectorParams`, `ALIKED`, `ALIKEDParams`, `DescriptorMatcher`, `BFMatcher`, `FlannBasedMatcher`, `LightGlueMatcher`, `ANNIndex`
 *
 * Member enums: `ScoreType`, `FastDetectorType`, `MatcherType`, `DrawMatchesFlags`, `Distance`
 */
CV_EXPORTS @interface Features : NSObject

#pragma mark - Methods


//
//  void cv::goodFeaturesToTrack(Mat image, Mat& corners, int maxCorners, double qualityLevel, double minDistance, Mat mask = Mat(), int blockSize = 3, bool useHarrisDetector = false, double k = 0.04)
//
/**
 * Determines strong corners on an image.
 *
 * The function finds the most prominent corners in the image or in the specified image region, as
 * described in *Cite:* Shi94
 *
 * -   Function calculates the corner quality measure at every source image pixel using the
 *     #cornerMinEigenVal or #cornerHarris .
 * -   Function performs a non-maximum suppression (the local maximums in *3 x 3* neighborhood are
 *     retained).
 * -   The corners with the minimal eigenvalue less than
 *     `$$\texttt{qualityLevel} \cdot \max_{x,y} qualityMeasureMap(x,y)$$` are rejected.
 * -   The remaining corners are sorted by the quality measure in the descending order.
 * -   Function throws away each corner for which there is a stronger corner at a distance less than
 *     maxDistance.
 *
 * The function can be used to initialize a point-based tracker of an object.
 *
 * Note:* If the function is called with different values A and B of the parameter qualityLevel , and
 * A \> B, the vector of returned corners with qualityLevel=A will be the prefix of the output vector
 * with qualityLevel=B .
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Optional region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * @param useHarrisDetector Parameter indicating whether to use a Harris detector (see #cornerHarris)
 * or #cornerMinEigenVal.
 * @param k Free parameter of the Harris detector.
 *
 * - SeeAlso cornerMinEigenVal, cornerHarris, calcOpticalFlowPyrLK, estimateRigidTransform, 
 */
+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask blockSize:(int)blockSize useHarrisDetector:(BOOL)useHarrisDetector k:(double)k NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:blockSize:useHarrisDetector:k:));

/**
 * Determines strong corners on an image.
 *
 * The function finds the most prominent corners in the image or in the specified image region, as
 * described in *Cite:* Shi94
 *
 * -   Function calculates the corner quality measure at every source image pixel using the
 *     #cornerMinEigenVal or #cornerHarris .
 * -   Function performs a non-maximum suppression (the local maximums in *3 x 3* neighborhood are
 *     retained).
 * -   The corners with the minimal eigenvalue less than
 *     `$$\texttt{qualityLevel} \cdot \max_{x,y} qualityMeasureMap(x,y)$$` are rejected.
 * -   The remaining corners are sorted by the quality measure in the descending order.
 * -   Function throws away each corner for which there is a stronger corner at a distance less than
 *     maxDistance.
 *
 * The function can be used to initialize a point-based tracker of an object.
 *
 * Note:* If the function is called with different values A and B of the parameter qualityLevel , and
 * A \> B, the vector of returned corners with qualityLevel=A will be the prefix of the output vector
 * with qualityLevel=B .
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Optional region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * @param useHarrisDetector Parameter indicating whether to use a Harris detector (see #cornerHarris)
 * or #cornerMinEigenVal.
 *
 * - SeeAlso cornerMinEigenVal, cornerHarris, calcOpticalFlowPyrLK, estimateRigidTransform, 
 */
+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask blockSize:(int)blockSize useHarrisDetector:(BOOL)useHarrisDetector NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:blockSize:useHarrisDetector:));

/**
 * Determines strong corners on an image.
 *
 * The function finds the most prominent corners in the image or in the specified image region, as
 * described in *Cite:* Shi94
 *
 * -   Function calculates the corner quality measure at every source image pixel using the
 *     #cornerMinEigenVal or #cornerHarris .
 * -   Function performs a non-maximum suppression (the local maximums in *3 x 3* neighborhood are
 *     retained).
 * -   The corners with the minimal eigenvalue less than
 *     `$$\texttt{qualityLevel} \cdot \max_{x,y} qualityMeasureMap(x,y)$$` are rejected.
 * -   The remaining corners are sorted by the quality measure in the descending order.
 * -   Function throws away each corner for which there is a stronger corner at a distance less than
 *     maxDistance.
 *
 * The function can be used to initialize a point-based tracker of an object.
 *
 * Note:* If the function is called with different values A and B of the parameter qualityLevel , and
 * A \> B, the vector of returned corners with qualityLevel=A will be the prefix of the output vector
 * with qualityLevel=B .
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Optional region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * or #cornerMinEigenVal.
 *
 * - SeeAlso cornerMinEigenVal, cornerHarris, calcOpticalFlowPyrLK, estimateRigidTransform, 
 */
+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask blockSize:(int)blockSize NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:blockSize:));

/**
 * Determines strong corners on an image.
 *
 * The function finds the most prominent corners in the image or in the specified image region, as
 * described in *Cite:* Shi94
 *
 * -   Function calculates the corner quality measure at every source image pixel using the
 *     #cornerMinEigenVal or #cornerHarris .
 * -   Function performs a non-maximum suppression (the local maximums in *3 x 3* neighborhood are
 *     retained).
 * -   The corners with the minimal eigenvalue less than
 *     `$$\texttt{qualityLevel} \cdot \max_{x,y} qualityMeasureMap(x,y)$$` are rejected.
 * -   The remaining corners are sorted by the quality measure in the descending order.
 * -   Function throws away each corner for which there is a stronger corner at a distance less than
 *     maxDistance.
 *
 * The function can be used to initialize a point-based tracker of an object.
 *
 * Note:* If the function is called with different values A and B of the parameter qualityLevel , and
 * A \> B, the vector of returned corners with qualityLevel=A will be the prefix of the output vector
 * with qualityLevel=B .
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Optional region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * or #cornerMinEigenVal.
 *
 * - SeeAlso cornerMinEigenVal, cornerHarris, calcOpticalFlowPyrLK, estimateRigidTransform, 
 */
+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:));

/**
 * Determines strong corners on an image.
 *
 * The function finds the most prominent corners in the image or in the specified image region, as
 * described in *Cite:* Shi94
 *
 * -   Function calculates the corner quality measure at every source image pixel using the
 *     #cornerMinEigenVal or #cornerHarris .
 * -   Function performs a non-maximum suppression (the local maximums in *3 x 3* neighborhood are
 *     retained).
 * -   The corners with the minimal eigenvalue less than
 *     `$$\texttt{qualityLevel} \cdot \max_{x,y} qualityMeasureMap(x,y)$$` are rejected.
 * -   The remaining corners are sorted by the quality measure in the descending order.
 * -   Function throws away each corner for which there is a stronger corner at a distance less than
 *     maxDistance.
 *
 * The function can be used to initialize a point-based tracker of an object.
 *
 * Note:* If the function is called with different values A and B of the parameter qualityLevel , and
 * A \> B, the vector of returned corners with qualityLevel=A will be the prefix of the output vector
 * with qualityLevel=B .
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * or #cornerMinEigenVal.
 *
 * - SeeAlso cornerMinEigenVal, cornerHarris, calcOpticalFlowPyrLK, estimateRigidTransform, 
 */
+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:));


//
//  void cv::goodFeaturesToTrack(Mat image, Mat& corners, int maxCorners, double qualityLevel, double minDistance, Mat mask, int blockSize, int gradientSize, bool useHarrisDetector = false, double k = 0.04)
//
+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask blockSize:(int)blockSize gradientSize:(int)gradientSize useHarrisDetector:(BOOL)useHarrisDetector k:(double)k NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:blockSize:gradientSize:useHarrisDetector:k:));

+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask blockSize:(int)blockSize gradientSize:(int)gradientSize useHarrisDetector:(BOOL)useHarrisDetector NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:blockSize:gradientSize:useHarrisDetector:));

+ (void)goodFeaturesToTrack:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask blockSize:(int)blockSize gradientSize:(int)gradientSize NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:blockSize:gradientSize:));


//
//  void cv::goodFeaturesToTrack(Mat image, Mat& corners, int maxCorners, double qualityLevel, double minDistance, Mat mask, Mat& cornersQuality, int blockSize = 3, int gradientSize = 3, bool useHarrisDetector = false, double k = 0.04)
//
/**
 * Same as above, but returns also quality measure of the detected corners.
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param cornersQuality Output vector of quality measure of the detected corners.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * @param gradientSize Aperture parameter for the Sobel operator used for derivatives computation.
 * See cornerEigenValsAndVecs .
 * @param useHarrisDetector Parameter indicating whether to use a Harris detector (see #cornerHarris)
 * or #cornerMinEigenVal.
 * @param k Free parameter of the Harris detector.
 */
+ (void)goodFeaturesToTrackWithQuality:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask cornersQuality:(Mat*)cornersQuality blockSize:(int)blockSize gradientSize:(int)gradientSize useHarrisDetector:(BOOL)useHarrisDetector k:(double)k NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:cornersQuality:blockSize:gradientSize:useHarrisDetector:k:));

/**
 * Same as above, but returns also quality measure of the detected corners.
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param cornersQuality Output vector of quality measure of the detected corners.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * @param gradientSize Aperture parameter for the Sobel operator used for derivatives computation.
 * See cornerEigenValsAndVecs .
 * @param useHarrisDetector Parameter indicating whether to use a Harris detector (see #cornerHarris)
 * or #cornerMinEigenVal.
 */
+ (void)goodFeaturesToTrackWithQuality:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask cornersQuality:(Mat*)cornersQuality blockSize:(int)blockSize gradientSize:(int)gradientSize useHarrisDetector:(BOOL)useHarrisDetector NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:cornersQuality:blockSize:gradientSize:useHarrisDetector:));

/**
 * Same as above, but returns also quality measure of the detected corners.
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param cornersQuality Output vector of quality measure of the detected corners.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * @param gradientSize Aperture parameter for the Sobel operator used for derivatives computation.
 * See cornerEigenValsAndVecs .
 * or #cornerMinEigenVal.
 */
+ (void)goodFeaturesToTrackWithQuality:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask cornersQuality:(Mat*)cornersQuality blockSize:(int)blockSize gradientSize:(int)gradientSize NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:cornersQuality:blockSize:gradientSize:));

/**
 * Same as above, but returns also quality measure of the detected corners.
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param cornersQuality Output vector of quality measure of the detected corners.
 * @param blockSize Size of an average block for computing a derivative covariation matrix over each
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * See cornerEigenValsAndVecs .
 * or #cornerMinEigenVal.
 */
+ (void)goodFeaturesToTrackWithQuality:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask cornersQuality:(Mat*)cornersQuality blockSize:(int)blockSize NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:cornersQuality:blockSize:));

/**
 * Same as above, but returns also quality measure of the detected corners.
 *
 * @param image Input 8-bit or floating-point 32-bit, single-channel image.
 * @param corners Output vector of detected corners.
 * @param maxCorners Maximum number of corners to return. If there are more corners than are found,
 * the strongest of them is returned. `maxCorners <= 0` implies that no limit on the maximum is set
 * and all detected corners are returned.
 * @param qualityLevel Parameter characterizing the minimal accepted quality of image corners. The
 * parameter value is multiplied by the best corner quality measure, which is the minimal eigenvalue
 * (see #cornerMinEigenVal ) or the Harris function response (see #cornerHarris ). The corners with the
 * quality measure less than the product are rejected. For example, if the best corner has the
 * quality measure = 1500, and the qualityLevel=0.01 , then all the corners with the quality measure
 * less than 15 are rejected.
 * @param minDistance Minimum possible Euclidean distance between the returned corners.
 * @param mask Region of interest. If the image is not empty (it needs to have the type
 * CV_8UC1 and the same size as image ), it specifies the region in which the corners are detected.
 * @param cornersQuality Output vector of quality measure of the detected corners.
 * pixel neighborhood. See cornerEigenValsAndVecs .
 * See cornerEigenValsAndVecs .
 * or #cornerMinEigenVal.
 */
+ (void)goodFeaturesToTrackWithQuality:(Mat*)image corners:(Mat*)corners maxCorners:(int)maxCorners qualityLevel:(double)qualityLevel minDistance:(double)minDistance mask:(Mat*)mask cornersQuality:(Mat*)cornersQuality NS_SWIFT_NAME(goodFeaturesToTrack(image:corners:maxCorners:qualityLevel:minDistance:mask:cornersQuality:));


//
//  void cv::drawKeypoints(Mat image, vector_KeyPoint keypoints, Mat& outImage, Scalar color = Scalar::all(-1), DrawMatchesFlags flags = DrawMatchesFlags::DEFAULT)
//
/**
 * Draws keypoints.
 *
 * @param image Source image.
 * @param keypoints Keypoints from the source image.
 * @param outImage Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * @param color Color of keypoints.
 * @param flags Flags setting drawing features. Possible flags bit values are defined by
 * DrawMatchesFlags. See details above in drawMatches .
 *
 * Note:*
 * For Python API, flags are modified as cv.DRAW_MATCHES_FLAGS_DEFAULT,
 * cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS, cv.DRAW_MATCHES_FLAGS_DRAW_OVER_OUTIMG,
 * cv.DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS
 */
+ (void)drawKeypoints:(Mat*)image keypoints:(NSArray<KeyPoint*>*)keypoints outImage:(Mat*)outImage color:(Scalar*)color flags:(DrawMatchesFlags)flags NS_SWIFT_NAME(drawKeypoints(image:keypoints:outImage:color:flags:));

/**
 * Draws keypoints.
 *
 * @param image Source image.
 * @param keypoints Keypoints from the source image.
 * @param outImage Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * @param color Color of keypoints.
 * DrawMatchesFlags. See details above in drawMatches .
 *
 * Note:*
 * For Python API, flags are modified as cv.DRAW_MATCHES_FLAGS_DEFAULT,
 * cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS, cv.DRAW_MATCHES_FLAGS_DRAW_OVER_OUTIMG,
 * cv.DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS
 */
+ (void)drawKeypoints:(Mat*)image keypoints:(NSArray<KeyPoint*>*)keypoints outImage:(Mat*)outImage color:(Scalar*)color NS_SWIFT_NAME(drawKeypoints(image:keypoints:outImage:color:));

/**
 * Draws keypoints.
 *
 * @param image Source image.
 * @param keypoints Keypoints from the source image.
 * @param outImage Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * DrawMatchesFlags. See details above in drawMatches .
 *
 * Note:*
 * For Python API, flags are modified as cv.DRAW_MATCHES_FLAGS_DEFAULT,
 * cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS, cv.DRAW_MATCHES_FLAGS_DRAW_OVER_OUTIMG,
 * cv.DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS
 */
+ (void)drawKeypoints:(Mat*)image keypoints:(NSArray<KeyPoint*>*)keypoints outImage:(Mat*)outImage NS_SWIFT_NAME(drawKeypoints(image:keypoints:outImage:));


//
//  void cv::drawMatches(Mat img1, vector_KeyPoint keypoints1, Mat img2, vector_KeyPoint keypoints2, vector_DMatch matches1to2, Mat& outImg, Scalar matchColor = Scalar::all(-1), Scalar singlePointColor = Scalar::all(-1), vector_char matchesMask = std::vector<char>(), DrawMatchesFlags flags = DrawMatchesFlags::DEFAULT)
//
/**
 * Draws the found matches of keypoints from two images.
 *
 * @param img1 First source image.
 * @param keypoints1 Keypoints from the first source image.
 * @param img2 Second source image.
 * @param keypoints2 Keypoints from the second source image.
 * @param matches1to2 Matches from the first image to the second one, which means that keypoints1[i]
 * has a corresponding point in keypoints2[matches[i]] .
 * @param outImg Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * @param matchColor Color of matches (lines and connected keypoints). If matchColor==Scalar::all(-1)
 * , the color is generated randomly.
 * @param singlePointColor Color of single keypoints (circles), which means that keypoints do not
 * have the matches. If singlePointColor==Scalar::all(-1) , the color is generated randomly.
 * @param matchesMask Mask determining which matches are drawn. If the mask is empty, all matches are
 * drawn.
 * @param flags Flags setting drawing features. Possible flags bit values are defined by
 * DrawMatchesFlags.
 *
 * This function draws matches of keypoints from two images in the output image. Match is a line
 * connecting two keypoints (circles). See cv::DrawMatchesFlags.
 */
+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor matchesMask:(ByteVector*)matchesMask flags:(DrawMatchesFlags)flags NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:singlePointColor:matchesMask:flags:));

/**
 * Draws the found matches of keypoints from two images.
 *
 * @param img1 First source image.
 * @param keypoints1 Keypoints from the first source image.
 * @param img2 Second source image.
 * @param keypoints2 Keypoints from the second source image.
 * @param matches1to2 Matches from the first image to the second one, which means that keypoints1[i]
 * has a corresponding point in keypoints2[matches[i]] .
 * @param outImg Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * @param matchColor Color of matches (lines and connected keypoints). If matchColor==Scalar::all(-1)
 * , the color is generated randomly.
 * @param singlePointColor Color of single keypoints (circles), which means that keypoints do not
 * have the matches. If singlePointColor==Scalar::all(-1) , the color is generated randomly.
 * @param matchesMask Mask determining which matches are drawn. If the mask is empty, all matches are
 * drawn.
 * DrawMatchesFlags.
 *
 * This function draws matches of keypoints from two images in the output image. Match is a line
 * connecting two keypoints (circles). See cv::DrawMatchesFlags.
 */
+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor matchesMask:(ByteVector*)matchesMask NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:singlePointColor:matchesMask:));

/**
 * Draws the found matches of keypoints from two images.
 *
 * @param img1 First source image.
 * @param keypoints1 Keypoints from the first source image.
 * @param img2 Second source image.
 * @param keypoints2 Keypoints from the second source image.
 * @param matches1to2 Matches from the first image to the second one, which means that keypoints1[i]
 * has a corresponding point in keypoints2[matches[i]] .
 * @param outImg Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * @param matchColor Color of matches (lines and connected keypoints). If matchColor==Scalar::all(-1)
 * , the color is generated randomly.
 * @param singlePointColor Color of single keypoints (circles), which means that keypoints do not
 * have the matches. If singlePointColor==Scalar::all(-1) , the color is generated randomly.
 * drawn.
 * DrawMatchesFlags.
 *
 * This function draws matches of keypoints from two images in the output image. Match is a line
 * connecting two keypoints (circles). See cv::DrawMatchesFlags.
 */
+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:singlePointColor:));

/**
 * Draws the found matches of keypoints from two images.
 *
 * @param img1 First source image.
 * @param keypoints1 Keypoints from the first source image.
 * @param img2 Second source image.
 * @param keypoints2 Keypoints from the second source image.
 * @param matches1to2 Matches from the first image to the second one, which means that keypoints1[i]
 * has a corresponding point in keypoints2[matches[i]] .
 * @param outImg Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * @param matchColor Color of matches (lines and connected keypoints). If matchColor==Scalar::all(-1)
 * , the color is generated randomly.
 * have the matches. If singlePointColor==Scalar::all(-1) , the color is generated randomly.
 * drawn.
 * DrawMatchesFlags.
 *
 * This function draws matches of keypoints from two images in the output image. Match is a line
 * connecting two keypoints (circles). See cv::DrawMatchesFlags.
 */
+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:));

/**
 * Draws the found matches of keypoints from two images.
 *
 * @param img1 First source image.
 * @param keypoints1 Keypoints from the first source image.
 * @param img2 Second source image.
 * @param keypoints2 Keypoints from the second source image.
 * @param matches1to2 Matches from the first image to the second one, which means that keypoints1[i]
 * has a corresponding point in keypoints2[matches[i]] .
 * @param outImg Output image. Its content depends on the flags value defining what is drawn in the
 * output image. See possible flags bit values below.
 * , the color is generated randomly.
 * have the matches. If singlePointColor==Scalar::all(-1) , the color is generated randomly.
 * drawn.
 * DrawMatchesFlags.
 *
 * This function draws matches of keypoints from two images in the output image. Match is a line
 * connecting two keypoints (circles). See cv::DrawMatchesFlags.
 */
+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:));


//
//  void cv::drawMatches(Mat img1, vector_KeyPoint keypoints1, Mat img2, vector_KeyPoint keypoints2, vector_DMatch matches1to2, Mat& outImg, int matchesThickness, Scalar matchColor = Scalar::all(-1), Scalar singlePointColor = Scalar::all(-1), vector_char matchesMask = std::vector<char>(), DrawMatchesFlags flags = DrawMatchesFlags::DEFAULT)
//
+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchesThickness:(int)matchesThickness matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor matchesMask:(ByteVector*)matchesMask flags:(DrawMatchesFlags)flags NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchesThickness:matchColor:singlePointColor:matchesMask:flags:));

+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchesThickness:(int)matchesThickness matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor matchesMask:(ByteVector*)matchesMask NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchesThickness:matchColor:singlePointColor:matchesMask:));

+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchesThickness:(int)matchesThickness matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchesThickness:matchColor:singlePointColor:));

+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchesThickness:(int)matchesThickness matchColor:(Scalar*)matchColor NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchesThickness:matchColor:));

+ (void)drawMatches:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<DMatch*>*)matches1to2 outImg:(Mat*)outImg matchesThickness:(int)matchesThickness NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchesThickness:));


//
//  void cv::drawMatches(Mat img1, vector_KeyPoint keypoints1, Mat img2, vector_KeyPoint keypoints2, vector_vector_DMatch matches1to2, Mat& outImg, Scalar matchColor = Scalar::all(-1), Scalar singlePointColor = Scalar::all(-1), vector_vector_char matchesMask = std::vector<std::vector<char> >(), DrawMatchesFlags flags = DrawMatchesFlags::DEFAULT)
//
+ (void)drawMatchesKnn:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<NSArray<DMatch*>*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor matchesMask:(NSArray<ByteVector*>*)matchesMask flags:(DrawMatchesFlags)flags NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:singlePointColor:matchesMask:flags:));

+ (void)drawMatchesKnn:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<NSArray<DMatch*>*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor matchesMask:(NSArray<ByteVector*>*)matchesMask NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:singlePointColor:matchesMask:));

+ (void)drawMatchesKnn:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<NSArray<DMatch*>*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor singlePointColor:(Scalar*)singlePointColor NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:singlePointColor:));

+ (void)drawMatchesKnn:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<NSArray<DMatch*>*>*)matches1to2 outImg:(Mat*)outImg matchColor:(Scalar*)matchColor NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:matchColor:));

+ (void)drawMatchesKnn:(Mat*)img1 keypoints1:(NSArray<KeyPoint*>*)keypoints1 img2:(Mat*)img2 keypoints2:(NSArray<KeyPoint*>*)keypoints2 matches1to2:(NSArray<NSArray<DMatch*>*>*)matches1to2 outImg:(Mat*)outImg NS_SWIFT_NAME(drawMatches(img1:keypoints1:img2:keypoints2:matches1to2:outImg:));



@end

NS_ASSUME_NONNULL_END


