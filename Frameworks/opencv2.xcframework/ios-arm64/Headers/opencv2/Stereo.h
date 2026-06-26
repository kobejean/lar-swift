//
// This file is auto-generated. Please don't modify it!
//
#pragma once

#ifdef __cplusplus
//#import "opencv.hpp"
#import "opencv2/stereo.hpp"
#else
#define CV_EXPORTS
#endif

#import <Foundation/Foundation.h>

@class Mat;
@class Rect2i;
@class Size2i;



NS_ASSUME_NONNULL_BEGIN

// C++: class Stereo
/**
 * The Stereo module
 *
 * Member classes: `StereoMatcher`, `StereoBM`, `StereoSGBM`
 *
 */
CV_EXPORTS @interface Stereo : NSObject

#pragma mark - Class Constants


@property (class, readonly) int STEREO_ZERO_DISPARITY NS_SWIFT_NAME(STEREO_ZERO_DISPARITY);

#pragma mark - Methods


//
//  void cv::stereoRectify(Mat cameraMatrix1, Mat distCoeffs1, Mat cameraMatrix2, Mat distCoeffs2, Size imageSize, Mat R, Mat T, Mat& R1, Mat& R2, Mat& P1, Mat& P2, Mat& Q, int flags = STEREO_ZERO_DISPARITY, double alpha = -1, Size newImageSize = Size(), Rect* validPixROI1 = 0, Rect* validPixROI2 = 0)
//
/**
 * Computes rectification transforms for each head of a calibrated stereo camera.
 *
 * @param cameraMatrix1 First camera intrinsic matrix.
 * @param distCoeffs1 First camera distortion parameters.
 * @param cameraMatrix2 Second camera intrinsic matrix.
 * @param distCoeffs2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param T Translation vector from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera. This matrix
 * brings points given in the unrectified first camera's coordinate system to points in the rectified
 * first camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified first camera's coordinate system to the rectified first camera's coordinate system.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera. This matrix
 * brings points given in the unrectified second camera's coordinate system to points in the rectified
 * second camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified second camera's coordinate system to the rectified second camera's coordinate system.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified first camera's image.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified second camera's image.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see *Ref:* reprojectImageTo3D).
 * @param flags Operation flags that may be zero or *Ref:* STEREO_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param alpha Free scaling parameter. If it is -1 or absent, the function performs the default
 * scaling. Otherwise, the parameter should be between 0 and 1. alpha=0 means that the rectified
 * images are zoomed and shifted so that only valid pixels are visible (no black areas after
 * rectification). alpha=1 means that the rectified image is decimated and shifted so that all the
 * pixels from the original images from the cameras are retained in the rectified images (no source
 * image pixels are lost). Any intermediate value yields an intermediate result between
 * those two extreme cases.
 * @param newImageSize New image resolution after rectification. The same size should be passed to
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to a larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * @param validPixROI1 Optional output rectangles inside the rectified images where all the pixels
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 * @param validPixROI2 Optional output rectangles inside the rectified images where all the pixels
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 *
 * The function computes the rotation matrices for each camera that (virtually) make both camera image
 * planes the same plane. Consequently, this makes all the epipolar lines parallel and thus simplifies
 * the dense stereo correspondence problem. The function takes the matrices computed by #stereoCalibrate
 * as input. As output, it provides two rotation matrices and also two projection matrices in the new
 * coordinates. The function distinguishes the following two cases:
 *
 * -   **Horizontal stereo**: the first and the second camera views are shifted relative to each other
 *     mainly along the x-axis (with possible small vertical shift). In the rectified images, the
 *     corresponding epipolar lines in the left and right cameras are horizontal and have the same
 *     y-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx_1 & 0 \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx_2 & T_x \cdot f \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix} ,$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx_1 \\
 *                         0 & 1 & 0 & -cy \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_x} & \frac{cx_1 - cx_2}{T_x}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_x$$` is a horizontal shift between the cameras and `$$cx_1=cx_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * -   **Vertical stereo**: the first and the second camera views are shifted relative to each other
 *     mainly in the vertical direction (and probably a bit in the horizontal direction too). The epipolar
 *     lines in the rectified images are vertical and have the same x-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_1 & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_2 & T_y \cdot f \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix},$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx \\
 *                         0 & 1 & 0 & -cy_1 \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_y} & \frac{cy_1 - cy_2}{T_y}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_y$$` is a vertical shift between the cameras and `$$cy_1=cy_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * As you can see, the first three columns of P1 and P2 will effectively be the new "rectified" camera
 * matrices. The matrices, together with R1 and R2 , can then be passed to #initUndistortRectifyMap to
 * initialize the rectification map for each camera.
 *
 * See below the screenshot from the stereo_calib.cpp sample. Some red horizontal lines pass through
 * the corresponding image regions. This means that the images are well rectified, which is what most
 * stereo correspondence algorithms rely on. The green rectangles are roi1 and roi2 . You see that
 * their interiors are all valid pixels.
 *
 * ![image](stereo_undistort)
 */
+ (void)stereoRectify:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 imageSize:(Size2i*)imageSize R:(Mat*)R T:(Mat*)T R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags alpha:(double)alpha newImageSize:(Size2i*)newImageSize validPixROI1:(Rect2i*)validPixROI1 validPixROI2:(Rect2i*)validPixROI2 NS_SWIFT_NAME(stereoRectify(cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:imageSize:R:T:R1:R2:P1:P2:Q:flags:alpha:newImageSize:validPixROI1:validPixROI2:));

/**
 * Computes rectification transforms for each head of a calibrated stereo camera.
 *
 * @param cameraMatrix1 First camera intrinsic matrix.
 * @param distCoeffs1 First camera distortion parameters.
 * @param cameraMatrix2 Second camera intrinsic matrix.
 * @param distCoeffs2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param T Translation vector from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera. This matrix
 * brings points given in the unrectified first camera's coordinate system to points in the rectified
 * first camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified first camera's coordinate system to the rectified first camera's coordinate system.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera. This matrix
 * brings points given in the unrectified second camera's coordinate system to points in the rectified
 * second camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified second camera's coordinate system to the rectified second camera's coordinate system.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified first camera's image.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified second camera's image.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see *Ref:* reprojectImageTo3D).
 * @param flags Operation flags that may be zero or *Ref:* STEREO_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param alpha Free scaling parameter. If it is -1 or absent, the function performs the default
 * scaling. Otherwise, the parameter should be between 0 and 1. alpha=0 means that the rectified
 * images are zoomed and shifted so that only valid pixels are visible (no black areas after
 * rectification). alpha=1 means that the rectified image is decimated and shifted so that all the
 * pixels from the original images from the cameras are retained in the rectified images (no source
 * image pixels are lost). Any intermediate value yields an intermediate result between
 * those two extreme cases.
 * @param newImageSize New image resolution after rectification. The same size should be passed to
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to a larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * @param validPixROI1 Optional output rectangles inside the rectified images where all the pixels
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 *
 * The function computes the rotation matrices for each camera that (virtually) make both camera image
 * planes the same plane. Consequently, this makes all the epipolar lines parallel and thus simplifies
 * the dense stereo correspondence problem. The function takes the matrices computed by #stereoCalibrate
 * as input. As output, it provides two rotation matrices and also two projection matrices in the new
 * coordinates. The function distinguishes the following two cases:
 *
 * -   **Horizontal stereo**: the first and the second camera views are shifted relative to each other
 *     mainly along the x-axis (with possible small vertical shift). In the rectified images, the
 *     corresponding epipolar lines in the left and right cameras are horizontal and have the same
 *     y-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx_1 & 0 \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx_2 & T_x \cdot f \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix} ,$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx_1 \\
 *                         0 & 1 & 0 & -cy \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_x} & \frac{cx_1 - cx_2}{T_x}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_x$$` is a horizontal shift between the cameras and `$$cx_1=cx_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * -   **Vertical stereo**: the first and the second camera views are shifted relative to each other
 *     mainly in the vertical direction (and probably a bit in the horizontal direction too). The epipolar
 *     lines in the rectified images are vertical and have the same x-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_1 & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_2 & T_y \cdot f \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix},$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx \\
 *                         0 & 1 & 0 & -cy_1 \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_y} & \frac{cy_1 - cy_2}{T_y}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_y$$` is a vertical shift between the cameras and `$$cy_1=cy_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * As you can see, the first three columns of P1 and P2 will effectively be the new "rectified" camera
 * matrices. The matrices, together with R1 and R2 , can then be passed to #initUndistortRectifyMap to
 * initialize the rectification map for each camera.
 *
 * See below the screenshot from the stereo_calib.cpp sample. Some red horizontal lines pass through
 * the corresponding image regions. This means that the images are well rectified, which is what most
 * stereo correspondence algorithms rely on. The green rectangles are roi1 and roi2 . You see that
 * their interiors are all valid pixels.
 *
 * ![image](stereo_undistort)
 */
+ (void)stereoRectify:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 imageSize:(Size2i*)imageSize R:(Mat*)R T:(Mat*)T R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags alpha:(double)alpha newImageSize:(Size2i*)newImageSize validPixROI1:(Rect2i*)validPixROI1 NS_SWIFT_NAME(stereoRectify(cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:imageSize:R:T:R1:R2:P1:P2:Q:flags:alpha:newImageSize:validPixROI1:));

/**
 * Computes rectification transforms for each head of a calibrated stereo camera.
 *
 * @param cameraMatrix1 First camera intrinsic matrix.
 * @param distCoeffs1 First camera distortion parameters.
 * @param cameraMatrix2 Second camera intrinsic matrix.
 * @param distCoeffs2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param T Translation vector from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera. This matrix
 * brings points given in the unrectified first camera's coordinate system to points in the rectified
 * first camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified first camera's coordinate system to the rectified first camera's coordinate system.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera. This matrix
 * brings points given in the unrectified second camera's coordinate system to points in the rectified
 * second camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified second camera's coordinate system to the rectified second camera's coordinate system.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified first camera's image.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified second camera's image.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see *Ref:* reprojectImageTo3D).
 * @param flags Operation flags that may be zero or *Ref:* STEREO_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param alpha Free scaling parameter. If it is -1 or absent, the function performs the default
 * scaling. Otherwise, the parameter should be between 0 and 1. alpha=0 means that the rectified
 * images are zoomed and shifted so that only valid pixels are visible (no black areas after
 * rectification). alpha=1 means that the rectified image is decimated and shifted so that all the
 * pixels from the original images from the cameras are retained in the rectified images (no source
 * image pixels are lost). Any intermediate value yields an intermediate result between
 * those two extreme cases.
 * @param newImageSize New image resolution after rectification. The same size should be passed to
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to a larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 *
 * The function computes the rotation matrices for each camera that (virtually) make both camera image
 * planes the same plane. Consequently, this makes all the epipolar lines parallel and thus simplifies
 * the dense stereo correspondence problem. The function takes the matrices computed by #stereoCalibrate
 * as input. As output, it provides two rotation matrices and also two projection matrices in the new
 * coordinates. The function distinguishes the following two cases:
 *
 * -   **Horizontal stereo**: the first and the second camera views are shifted relative to each other
 *     mainly along the x-axis (with possible small vertical shift). In the rectified images, the
 *     corresponding epipolar lines in the left and right cameras are horizontal and have the same
 *     y-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx_1 & 0 \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx_2 & T_x \cdot f \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix} ,$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx_1 \\
 *                         0 & 1 & 0 & -cy \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_x} & \frac{cx_1 - cx_2}{T_x}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_x$$` is a horizontal shift between the cameras and `$$cx_1=cx_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * -   **Vertical stereo**: the first and the second camera views are shifted relative to each other
 *     mainly in the vertical direction (and probably a bit in the horizontal direction too). The epipolar
 *     lines in the rectified images are vertical and have the same x-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_1 & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_2 & T_y \cdot f \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix},$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx \\
 *                         0 & 1 & 0 & -cy_1 \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_y} & \frac{cy_1 - cy_2}{T_y}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_y$$` is a vertical shift between the cameras and `$$cy_1=cy_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * As you can see, the first three columns of P1 and P2 will effectively be the new "rectified" camera
 * matrices. The matrices, together with R1 and R2 , can then be passed to #initUndistortRectifyMap to
 * initialize the rectification map for each camera.
 *
 * See below the screenshot from the stereo_calib.cpp sample. Some red horizontal lines pass through
 * the corresponding image regions. This means that the images are well rectified, which is what most
 * stereo correspondence algorithms rely on. The green rectangles are roi1 and roi2 . You see that
 * their interiors are all valid pixels.
 *
 * ![image](stereo_undistort)
 */
+ (void)stereoRectify:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 imageSize:(Size2i*)imageSize R:(Mat*)R T:(Mat*)T R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags alpha:(double)alpha newImageSize:(Size2i*)newImageSize NS_SWIFT_NAME(stereoRectify(cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:imageSize:R:T:R1:R2:P1:P2:Q:flags:alpha:newImageSize:));

/**
 * Computes rectification transforms for each head of a calibrated stereo camera.
 *
 * @param cameraMatrix1 First camera intrinsic matrix.
 * @param distCoeffs1 First camera distortion parameters.
 * @param cameraMatrix2 Second camera intrinsic matrix.
 * @param distCoeffs2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param T Translation vector from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera. This matrix
 * brings points given in the unrectified first camera's coordinate system to points in the rectified
 * first camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified first camera's coordinate system to the rectified first camera's coordinate system.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera. This matrix
 * brings points given in the unrectified second camera's coordinate system to points in the rectified
 * second camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified second camera's coordinate system to the rectified second camera's coordinate system.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified first camera's image.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified second camera's image.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see *Ref:* reprojectImageTo3D).
 * @param flags Operation flags that may be zero or *Ref:* STEREO_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param alpha Free scaling parameter. If it is -1 or absent, the function performs the default
 * scaling. Otherwise, the parameter should be between 0 and 1. alpha=0 means that the rectified
 * images are zoomed and shifted so that only valid pixels are visible (no black areas after
 * rectification). alpha=1 means that the rectified image is decimated and shifted so that all the
 * pixels from the original images from the cameras are retained in the rectified images (no source
 * image pixels are lost). Any intermediate value yields an intermediate result between
 * those two extreme cases.
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to a larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 *
 * The function computes the rotation matrices for each camera that (virtually) make both camera image
 * planes the same plane. Consequently, this makes all the epipolar lines parallel and thus simplifies
 * the dense stereo correspondence problem. The function takes the matrices computed by #stereoCalibrate
 * as input. As output, it provides two rotation matrices and also two projection matrices in the new
 * coordinates. The function distinguishes the following two cases:
 *
 * -   **Horizontal stereo**: the first and the second camera views are shifted relative to each other
 *     mainly along the x-axis (with possible small vertical shift). In the rectified images, the
 *     corresponding epipolar lines in the left and right cameras are horizontal and have the same
 *     y-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx_1 & 0 \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx_2 & T_x \cdot f \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix} ,$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx_1 \\
 *                         0 & 1 & 0 & -cy \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_x} & \frac{cx_1 - cx_2}{T_x}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_x$$` is a horizontal shift between the cameras and `$$cx_1=cx_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * -   **Vertical stereo**: the first and the second camera views are shifted relative to each other
 *     mainly in the vertical direction (and probably a bit in the horizontal direction too). The epipolar
 *     lines in the rectified images are vertical and have the same x-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_1 & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_2 & T_y \cdot f \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix},$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx \\
 *                         0 & 1 & 0 & -cy_1 \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_y} & \frac{cy_1 - cy_2}{T_y}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_y$$` is a vertical shift between the cameras and `$$cy_1=cy_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * As you can see, the first three columns of P1 and P2 will effectively be the new "rectified" camera
 * matrices. The matrices, together with R1 and R2 , can then be passed to #initUndistortRectifyMap to
 * initialize the rectification map for each camera.
 *
 * See below the screenshot from the stereo_calib.cpp sample. Some red horizontal lines pass through
 * the corresponding image regions. This means that the images are well rectified, which is what most
 * stereo correspondence algorithms rely on. The green rectangles are roi1 and roi2 . You see that
 * their interiors are all valid pixels.
 *
 * ![image](stereo_undistort)
 */
+ (void)stereoRectify:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 imageSize:(Size2i*)imageSize R:(Mat*)R T:(Mat*)T R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags alpha:(double)alpha NS_SWIFT_NAME(stereoRectify(cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:imageSize:R:T:R1:R2:P1:P2:Q:flags:alpha:));

/**
 * Computes rectification transforms for each head of a calibrated stereo camera.
 *
 * @param cameraMatrix1 First camera intrinsic matrix.
 * @param distCoeffs1 First camera distortion parameters.
 * @param cameraMatrix2 Second camera intrinsic matrix.
 * @param distCoeffs2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param T Translation vector from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera. This matrix
 * brings points given in the unrectified first camera's coordinate system to points in the rectified
 * first camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified first camera's coordinate system to the rectified first camera's coordinate system.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera. This matrix
 * brings points given in the unrectified second camera's coordinate system to points in the rectified
 * second camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified second camera's coordinate system to the rectified second camera's coordinate system.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified first camera's image.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified second camera's image.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see *Ref:* reprojectImageTo3D).
 * @param flags Operation flags that may be zero or *Ref:* STEREO_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * scaling. Otherwise, the parameter should be between 0 and 1. alpha=0 means that the rectified
 * images are zoomed and shifted so that only valid pixels are visible (no black areas after
 * rectification). alpha=1 means that the rectified image is decimated and shifted so that all the
 * pixels from the original images from the cameras are retained in the rectified images (no source
 * image pixels are lost). Any intermediate value yields an intermediate result between
 * those two extreme cases.
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to a larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 *
 * The function computes the rotation matrices for each camera that (virtually) make both camera image
 * planes the same plane. Consequently, this makes all the epipolar lines parallel and thus simplifies
 * the dense stereo correspondence problem. The function takes the matrices computed by #stereoCalibrate
 * as input. As output, it provides two rotation matrices and also two projection matrices in the new
 * coordinates. The function distinguishes the following two cases:
 *
 * -   **Horizontal stereo**: the first and the second camera views are shifted relative to each other
 *     mainly along the x-axis (with possible small vertical shift). In the rectified images, the
 *     corresponding epipolar lines in the left and right cameras are horizontal and have the same
 *     y-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx_1 & 0 \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx_2 & T_x \cdot f \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix} ,$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx_1 \\
 *                         0 & 1 & 0 & -cy \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_x} & \frac{cx_1 - cx_2}{T_x}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_x$$` is a horizontal shift between the cameras and `$$cx_1=cx_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * -   **Vertical stereo**: the first and the second camera views are shifted relative to each other
 *     mainly in the vertical direction (and probably a bit in the horizontal direction too). The epipolar
 *     lines in the rectified images are vertical and have the same x-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_1 & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_2 & T_y \cdot f \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix},$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx \\
 *                         0 & 1 & 0 & -cy_1 \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_y} & \frac{cy_1 - cy_2}{T_y}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_y$$` is a vertical shift between the cameras and `$$cy_1=cy_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * As you can see, the first three columns of P1 and P2 will effectively be the new "rectified" camera
 * matrices. The matrices, together with R1 and R2 , can then be passed to #initUndistortRectifyMap to
 * initialize the rectification map for each camera.
 *
 * See below the screenshot from the stereo_calib.cpp sample. Some red horizontal lines pass through
 * the corresponding image regions. This means that the images are well rectified, which is what most
 * stereo correspondence algorithms rely on. The green rectangles are roi1 and roi2 . You see that
 * their interiors are all valid pixels.
 *
 * ![image](stereo_undistort)
 */
+ (void)stereoRectify:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 imageSize:(Size2i*)imageSize R:(Mat*)R T:(Mat*)T R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags NS_SWIFT_NAME(stereoRectify(cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:imageSize:R:T:R1:R2:P1:P2:Q:flags:));

/**
 * Computes rectification transforms for each head of a calibrated stereo camera.
 *
 * @param cameraMatrix1 First camera intrinsic matrix.
 * @param distCoeffs1 First camera distortion parameters.
 * @param cameraMatrix2 Second camera intrinsic matrix.
 * @param distCoeffs2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param T Translation vector from the coordinate system of the first camera to the second camera,
 * see *Ref:* stereoCalibrate.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera. This matrix
 * brings points given in the unrectified first camera's coordinate system to points in the rectified
 * first camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified first camera's coordinate system to the rectified first camera's coordinate system.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera. This matrix
 * brings points given in the unrectified second camera's coordinate system to points in the rectified
 * second camera's coordinate system. In more technical terms, it performs a change of basis from the
 * unrectified second camera's coordinate system to the rectified second camera's coordinate system.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified first camera's image.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera, i.e. it projects points given in the rectified first camera coordinate system into the
 * rectified second camera's image.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see *Ref:* reprojectImageTo3D).
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * scaling. Otherwise, the parameter should be between 0 and 1. alpha=0 means that the rectified
 * images are zoomed and shifted so that only valid pixels are visible (no black areas after
 * rectification). alpha=1 means that the rectified image is decimated and shifted so that all the
 * pixels from the original images from the cameras are retained in the rectified images (no source
 * image pixels are lost). Any intermediate value yields an intermediate result between
 * those two extreme cases.
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to a larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 * are valid. If alpha=0 , the ROIs cover the whole images. Otherwise, they are likely to be smaller
 * (see the picture below).
 *
 * The function computes the rotation matrices for each camera that (virtually) make both camera image
 * planes the same plane. Consequently, this makes all the epipolar lines parallel and thus simplifies
 * the dense stereo correspondence problem. The function takes the matrices computed by #stereoCalibrate
 * as input. As output, it provides two rotation matrices and also two projection matrices in the new
 * coordinates. The function distinguishes the following two cases:
 *
 * -   **Horizontal stereo**: the first and the second camera views are shifted relative to each other
 *     mainly along the x-axis (with possible small vertical shift). In the rectified images, the
 *     corresponding epipolar lines in the left and right cameras are horizontal and have the same
 *     y-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx_1 & 0 \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx_2 & T_x \cdot f \\
 *                         0 & f & cy & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix} ,$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx_1 \\
 *                         0 & 1 & 0 & -cy \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_x} & \frac{cx_1 - cx_2}{T_x}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_x$$` is a horizontal shift between the cameras and `$$cx_1=cx_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * -   **Vertical stereo**: the first and the second camera views are shifted relative to each other
 *     mainly in the vertical direction (and probably a bit in the horizontal direction too). The epipolar
 *     lines in the rectified images are vertical and have the same x-coordinate. P1 and P2 look like:
 *
 *     `$$\texttt{P1} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_1 & 0 \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix}$$`
 *
 *     `$$\texttt{P2} = \begin{bmatrix}
 *                         f & 0 & cx & 0 \\
 *                         0 & f & cy_2 & T_y \cdot f \\
 *                         0 & 0 & 1 & 0
 *                      \end{bmatrix},$$`
 *
 *     `$$\texttt{Q} = \begin{bmatrix}
 *                         1 & 0 & 0 & -cx \\
 *                         0 & 1 & 0 & -cy_1 \\
 *                         0 & 0 & 0 & f \\
 *                         0 & 0 & -\frac{1}{T_y} & \frac{cy_1 - cy_2}{T_y}
 *                     \end{bmatrix} $$`
 *
 *     where `$$T_y$$` is a vertical shift between the cameras and `$$cy_1=cy_2$$` if
 * Ref:* STEREO_ZERO_DISPARITY is set.
 *
 * As you can see, the first three columns of P1 and P2 will effectively be the new "rectified" camera
 * matrices. The matrices, together with R1 and R2 , can then be passed to #initUndistortRectifyMap to
 * initialize the rectification map for each camera.
 *
 * See below the screenshot from the stereo_calib.cpp sample. Some red horizontal lines pass through
 * the corresponding image regions. This means that the images are well rectified, which is what most
 * stereo correspondence algorithms rely on. The green rectangles are roi1 and roi2 . You see that
 * their interiors are all valid pixels.
 *
 * ![image](stereo_undistort)
 */
+ (void)stereoRectify:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 imageSize:(Size2i*)imageSize R:(Mat*)R T:(Mat*)T R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q NS_SWIFT_NAME(stereoRectify(cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:imageSize:R:T:R1:R2:P1:P2:Q:));


//
//  bool cv::stereoRectifyUncalibrated(Mat points1, Mat points2, Mat F, Size imgSize, Mat& H1, Mat& H2, double threshold = 5)
//
/**
 * Computes a rectification transform for an uncalibrated stereo camera.
 *
 * @param points1 Array of feature points in the first image.
 * @param points2 The corresponding points in the second image. The same formats as in
 * #findFundamentalMat are supported.
 * @param F Input fundamental matrix. It can be computed from the same set of point pairs using
 * #findFundamentalMat .
 * @param imgSize Size of the image.
 * @param H1 Output rectification homography matrix for the first image.
 * @param H2 Output rectification homography matrix for the second image.
 * @param threshold Optional threshold used to filter out the outliers. If the parameter is greater
 * than zero, all the point pairs that do not comply with the epipolar geometry (that is, the points
 * for which `$$|\texttt{points2[i]}^T \cdot \texttt{F} \cdot \texttt{points1[i]}|>\texttt{threshold}$$` )
 * are rejected prior to computing the homographies. Otherwise, all the points are considered inliers.
 *
 * The function computes the rectification transformations without knowing intrinsic parameters of the
 * cameras and their relative position in the space, which explains the suffix "uncalibrated". Another
 * related difference from ``Stereo/stereoRectify`` is that the function outputs not the rectification
 * transformations in the object (3D) space, but the planar perspective transformations encoded by the
 * homography matrices H1 and H2 . The function implements the algorithm *Cite:* Hartley99 .
 *
 * Note:*
 *    While the algorithm does not need to know the intrinsic parameters of the cameras, it heavily
 *     depends on the epipolar geometry. Therefore, if the camera lenses have a significant distortion,
 *     it would be better to correct it before computing the fundamental matrix and calling this
 *     function. For example, distortion coefficients can be estimated for each head of stereo camera
 *     separately by using #calibrateCamera . Then, the images can be corrected using #undistort , or
 *     just the point coordinates can be corrected with #undistortPoints .
 */
+ (BOOL)stereoRectifyUncalibrated:(Mat*)points1 points2:(Mat*)points2 F:(Mat*)F imgSize:(Size2i*)imgSize H1:(Mat*)H1 H2:(Mat*)H2 threshold:(double)threshold NS_SWIFT_NAME(stereoRectifyUncalibrated(points1:points2:F:imgSize:H1:H2:threshold:));

/**
 * Computes a rectification transform for an uncalibrated stereo camera.
 *
 * @param points1 Array of feature points in the first image.
 * @param points2 The corresponding points in the second image. The same formats as in
 * #findFundamentalMat are supported.
 * @param F Input fundamental matrix. It can be computed from the same set of point pairs using
 * #findFundamentalMat .
 * @param imgSize Size of the image.
 * @param H1 Output rectification homography matrix for the first image.
 * @param H2 Output rectification homography matrix for the second image.
 * than zero, all the point pairs that do not comply with the epipolar geometry (that is, the points
 * for which `$$|\texttt{points2[i]}^T \cdot \texttt{F} \cdot \texttt{points1[i]}|>\texttt{threshold}$$` )
 * are rejected prior to computing the homographies. Otherwise, all the points are considered inliers.
 *
 * The function computes the rectification transformations without knowing intrinsic parameters of the
 * cameras and their relative position in the space, which explains the suffix "uncalibrated". Another
 * related difference from ``Stereo/stereoRectify`` is that the function outputs not the rectification
 * transformations in the object (3D) space, but the planar perspective transformations encoded by the
 * homography matrices H1 and H2 . The function implements the algorithm *Cite:* Hartley99 .
 *
 * Note:*
 *    While the algorithm does not need to know the intrinsic parameters of the cameras, it heavily
 *     depends on the epipolar geometry. Therefore, if the camera lenses have a significant distortion,
 *     it would be better to correct it before computing the fundamental matrix and calling this
 *     function. For example, distortion coefficients can be estimated for each head of stereo camera
 *     separately by using #calibrateCamera . Then, the images can be corrected using #undistort , or
 *     just the point coordinates can be corrected with #undistortPoints .
 */
+ (BOOL)stereoRectifyUncalibrated:(Mat*)points1 points2:(Mat*)points2 F:(Mat*)F imgSize:(Size2i*)imgSize H1:(Mat*)H1 H2:(Mat*)H2 NS_SWIFT_NAME(stereoRectifyUncalibrated(points1:points2:F:imgSize:H1:H2:));


//
//  void cv::fisheye::stereoRectify(Mat K1, Mat D1, Mat K2, Mat D2, Size imageSize, Mat R, Mat tvec, Mat& R1, Mat& R2, Mat& P1, Mat& P2, Mat& Q, int flags, Size newImageSize = Size(), double balance = 0.0, double fov_scale = 1.0)
//
/**
 * Stereo rectification for fisheye camera model
 *
 * @param K1 First camera intrinsic matrix.
 * @param D1 First camera distortion parameters.
 * @param K2 Second camera intrinsic matrix.
 * @param D2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix between the coordinate systems of the first and the second
 * cameras.
 * @param tvec Translation vector between coordinate systems of the cameras.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see reprojectImageTo3D ).
 * @param flags Operation flags that may be zero or *Ref:* cv::CALIB_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param newImageSize New image resolution after rectification. The same size should be passed to
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * @param balance Sets the new focal length in range between the min focal length and the max focal
 * length. Balance is in range of [0, 1].
 * @param fov_scale Divisor for new focal length.
 */
+ (void)fisheye_stereoRectify:(Mat*)K1 D1:(Mat*)D1 K2:(Mat*)K2 D2:(Mat*)D2 imageSize:(Size2i*)imageSize R:(Mat*)R tvec:(Mat*)tvec R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags newImageSize:(Size2i*)newImageSize balance:(double)balance fov_scale:(double)fov_scale NS_SWIFT_NAME(fisheye_stereoRectify(K1:D1:K2:D2:imageSize:R:tvec:R1:R2:P1:P2:Q:flags:newImageSize:balance:fov_scale:));

/**
 * Stereo rectification for fisheye camera model
 *
 * @param K1 First camera intrinsic matrix.
 * @param D1 First camera distortion parameters.
 * @param K2 Second camera intrinsic matrix.
 * @param D2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix between the coordinate systems of the first and the second
 * cameras.
 * @param tvec Translation vector between coordinate systems of the cameras.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see reprojectImageTo3D ).
 * @param flags Operation flags that may be zero or *Ref:* cv::CALIB_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param newImageSize New image resolution after rectification. The same size should be passed to
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * @param balance Sets the new focal length in range between the min focal length and the max focal
 * length. Balance is in range of [0, 1].
 */
+ (void)fisheye_stereoRectify:(Mat*)K1 D1:(Mat*)D1 K2:(Mat*)K2 D2:(Mat*)D2 imageSize:(Size2i*)imageSize R:(Mat*)R tvec:(Mat*)tvec R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags newImageSize:(Size2i*)newImageSize balance:(double)balance NS_SWIFT_NAME(fisheye_stereoRectify(K1:D1:K2:D2:imageSize:R:tvec:R1:R2:P1:P2:Q:flags:newImageSize:balance:));

/**
 * Stereo rectification for fisheye camera model
 *
 * @param K1 First camera intrinsic matrix.
 * @param D1 First camera distortion parameters.
 * @param K2 Second camera intrinsic matrix.
 * @param D2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix between the coordinate systems of the first and the second
 * cameras.
 * @param tvec Translation vector between coordinate systems of the cameras.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see reprojectImageTo3D ).
 * @param flags Operation flags that may be zero or *Ref:* cv::CALIB_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * @param newImageSize New image resolution after rectification. The same size should be passed to
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * length. Balance is in range of [0, 1].
 */
+ (void)fisheye_stereoRectify:(Mat*)K1 D1:(Mat*)D1 K2:(Mat*)K2 D2:(Mat*)D2 imageSize:(Size2i*)imageSize R:(Mat*)R tvec:(Mat*)tvec R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags newImageSize:(Size2i*)newImageSize NS_SWIFT_NAME(fisheye_stereoRectify(K1:D1:K2:D2:imageSize:R:tvec:R1:R2:P1:P2:Q:flags:newImageSize:));

/**
 * Stereo rectification for fisheye camera model
 *
 * @param K1 First camera intrinsic matrix.
 * @param D1 First camera distortion parameters.
 * @param K2 Second camera intrinsic matrix.
 * @param D2 Second camera distortion parameters.
 * @param imageSize Size of the image used for stereo calibration.
 * @param R Rotation matrix between the coordinate systems of the first and the second
 * cameras.
 * @param tvec Translation vector between coordinate systems of the cameras.
 * @param R1 Output 3x3 rectification transform (rotation matrix) for the first camera.
 * @param R2 Output 3x3 rectification transform (rotation matrix) for the second camera.
 * @param P1 Output 3x4 projection matrix in the new (rectified) coordinate systems for the first
 * camera.
 * @param P2 Output 3x4 projection matrix in the new (rectified) coordinate systems for the second
 * camera.
 * @param Q Output `$$4 \times 4$$` disparity-to-depth mapping matrix (see reprojectImageTo3D ).
 * @param flags Operation flags that may be zero or *Ref:* cv::CALIB_ZERO_DISPARITY . If the flag is set,
 * the function makes the principal points of each camera have the same pixel coordinates in the
 * rectified views. And if the flag is not set, the function may still shift the images in the
 * horizontal or vertical direction (depending on the orientation of epipolar lines) to maximize the
 * useful image area.
 * #initUndistortRectifyMap (see the stereo_calib.cpp sample in OpenCV samples directory). When (0,0)
 * is passed (default), it is set to the original imageSize . Setting it to larger value can help you
 * preserve details in the original image, especially when there is a big radial distortion.
 * length. Balance is in range of [0, 1].
 */
+ (void)fisheye_stereoRectify:(Mat*)K1 D1:(Mat*)D1 K2:(Mat*)K2 D2:(Mat*)D2 imageSize:(Size2i*)imageSize R:(Mat*)R tvec:(Mat*)tvec R1:(Mat*)R1 R2:(Mat*)R2 P1:(Mat*)P1 P2:(Mat*)P2 Q:(Mat*)Q flags:(int)flags NS_SWIFT_NAME(fisheye_stereoRectify(K1:D1:K2:D2:imageSize:R:tvec:R1:R2:P1:P2:Q:flags:));


//
//  void cv::filterSpeckles(Mat& img, double newVal, int maxSpeckleSize, double maxDiff, Mat& buf = Mat())
//
/**
 * Filters off small noise blobs (speckles) in the disparity map
 *
 * @param img The input 16-bit signed disparity image
 * @param newVal The disparity value used to paint-off the speckles
 * @param maxSpeckleSize The maximum speckle size to consider it a speckle. Larger blobs are not
 * affected by the algorithm
 * @param maxDiff Maximum difference between neighbor disparity pixels to put them into the same
 * blob. Note that since StereoBM, StereoSGBM and may be other algorithms return a fixed-point
 * disparity map, where disparity values are multiplied by 16, this scale factor should be taken into
 * account when specifying this parameter value.
 * @param buf The optional temporary buffer to avoid memory allocation within the function.
 */
+ (void)filterSpeckles:(Mat*)img newVal:(double)newVal maxSpeckleSize:(int)maxSpeckleSize maxDiff:(double)maxDiff buf:(Mat*)buf NS_SWIFT_NAME(filterSpeckles(img:newVal:maxSpeckleSize:maxDiff:buf:));

/**
 * Filters off small noise blobs (speckles) in the disparity map
 *
 * @param img The input 16-bit signed disparity image
 * @param newVal The disparity value used to paint-off the speckles
 * @param maxSpeckleSize The maximum speckle size to consider it a speckle. Larger blobs are not
 * affected by the algorithm
 * @param maxDiff Maximum difference between neighbor disparity pixels to put them into the same
 * blob. Note that since StereoBM, StereoSGBM and may be other algorithms return a fixed-point
 * disparity map, where disparity values are multiplied by 16, this scale factor should be taken into
 * account when specifying this parameter value.
 */
+ (void)filterSpeckles:(Mat*)img newVal:(double)newVal maxSpeckleSize:(int)maxSpeckleSize maxDiff:(double)maxDiff NS_SWIFT_NAME(filterSpeckles(img:newVal:maxSpeckleSize:maxDiff:));


//
//  Rect cv::getValidDisparityROI(Rect roi1, Rect roi2, int minDisparity, int numberOfDisparities, int blockSize)
//
+ (Rect2i*)getValidDisparityROI:(Rect2i*)roi1 roi2:(Rect2i*)roi2 minDisparity:(int)minDisparity numberOfDisparities:(int)numberOfDisparities blockSize:(int)blockSize NS_SWIFT_NAME(getValidDisparityROI(roi1:roi2:minDisparity:numberOfDisparities:blockSize:));


//
//  void cv::validateDisparity(Mat& disparity, Mat cost, int minDisparity, int numberOfDisparities, int disp12MaxDisp = 1)
//
+ (void)validateDisparity:(Mat*)disparity cost:(Mat*)cost minDisparity:(int)minDisparity numberOfDisparities:(int)numberOfDisparities disp12MaxDisp:(int)disp12MaxDisp NS_SWIFT_NAME(validateDisparity(disparity:cost:minDisparity:numberOfDisparities:disp12MaxDisp:));

+ (void)validateDisparity:(Mat*)disparity cost:(Mat*)cost minDisparity:(int)minDisparity numberOfDisparities:(int)numberOfDisparities NS_SWIFT_NAME(validateDisparity(disparity:cost:minDisparity:numberOfDisparities:));


//
//  void cv::reprojectImageTo3D(Mat disparity, Mat& _3dImage, Mat Q, bool handleMissingValues = false, int ddepth = -1)
//
/**
 * Reprojects a disparity image to 3D space.
 *
 * @param disparity Input single-channel 8-bit unsigned, 16-bit signed, 32-bit signed or 32-bit
 * floating-point disparity image. The values of 8-bit / 16-bit signed formats are assumed to have no
 * fractional bits. If the disparity is 16-bit signed format, as computed by *Ref:* StereoBM or
 * Ref:* StereoSGBM and maybe other algorithms, it should be divided by 16 (and scaled to float) before
 * being used here.
 * @param _3dImage Output 3-channel floating-point image of the same size as disparity. Each element of
 * _3dImage(x,y) contains 3D coordinates of the point (x,y) computed from the disparity map. If one
 * uses Q obtained by *Ref:* stereoRectify, then the returned points are represented in the first
 * camera's rectified coordinate system.
 * @param Q `$$4 \times 4$$` perspective transformation matrix that can be obtained with
 * Ref:* stereoRectify.
 * @param handleMissingValues Indicates, whether the function should handle missing values (i.e.
 * points where the disparity was not computed). If handleMissingValues=true, then pixels with the
 * minimal disparity that corresponds to the outliers (see StereoMatcher::compute ) are transformed
 * to 3D points with a very large Z value (currently set to 10000).
 * @param ddepth The optional output array depth. If it is -1, the output image will have CV_32F
 * depth. ddepth can also be set to CV_16S, CV_32S or CV_32F.
 *
 * The function transforms a single-channel disparity map to a 3-channel image representing a 3D
 * surface. That is, for each pixel (x,y) and the corresponding disparity d=disparity(x,y) , it
 * computes:
 *
 * `$$\begin{bmatrix}
 * X \\
 * Y \\
 * Z \\
 * W
 * \end{bmatrix} = Q \begin{bmatrix}
 * x \\
 * y \\
 * \texttt{disparity} (x,y) \\
 * 1
 * \end{bmatrix}.$$`
 *
 * @sa
 *    To reproject a sparse set of points {(x,y,d),...} to 3D space, use perspectiveTransform.
 */
+ (void)reprojectImageTo3D:(Mat*)disparity _3dImage:(Mat*)_3dImage Q:(Mat*)Q handleMissingValues:(BOOL)handleMissingValues ddepth:(int)ddepth NS_SWIFT_NAME(reprojectImageTo3D(disparity:_3dImage:Q:handleMissingValues:ddepth:));

/**
 * Reprojects a disparity image to 3D space.
 *
 * @param disparity Input single-channel 8-bit unsigned, 16-bit signed, 32-bit signed or 32-bit
 * floating-point disparity image. The values of 8-bit / 16-bit signed formats are assumed to have no
 * fractional bits. If the disparity is 16-bit signed format, as computed by *Ref:* StereoBM or
 * Ref:* StereoSGBM and maybe other algorithms, it should be divided by 16 (and scaled to float) before
 * being used here.
 * @param _3dImage Output 3-channel floating-point image of the same size as disparity. Each element of
 * _3dImage(x,y) contains 3D coordinates of the point (x,y) computed from the disparity map. If one
 * uses Q obtained by *Ref:* stereoRectify, then the returned points are represented in the first
 * camera's rectified coordinate system.
 * @param Q `$$4 \times 4$$` perspective transformation matrix that can be obtained with
 * Ref:* stereoRectify.
 * @param handleMissingValues Indicates, whether the function should handle missing values (i.e.
 * points where the disparity was not computed). If handleMissingValues=true, then pixels with the
 * minimal disparity that corresponds to the outliers (see StereoMatcher::compute ) are transformed
 * to 3D points with a very large Z value (currently set to 10000).
 * depth. ddepth can also be set to CV_16S, CV_32S or CV_32F.
 *
 * The function transforms a single-channel disparity map to a 3-channel image representing a 3D
 * surface. That is, for each pixel (x,y) and the corresponding disparity d=disparity(x,y) , it
 * computes:
 *
 * `$$\begin{bmatrix}
 * X \\
 * Y \\
 * Z \\
 * W
 * \end{bmatrix} = Q \begin{bmatrix}
 * x \\
 * y \\
 * \texttt{disparity} (x,y) \\
 * 1
 * \end{bmatrix}.$$`
 *
 * @sa
 *    To reproject a sparse set of points {(x,y,d),...} to 3D space, use perspectiveTransform.
 */
+ (void)reprojectImageTo3D:(Mat*)disparity _3dImage:(Mat*)_3dImage Q:(Mat*)Q handleMissingValues:(BOOL)handleMissingValues NS_SWIFT_NAME(reprojectImageTo3D(disparity:_3dImage:Q:handleMissingValues:));

/**
 * Reprojects a disparity image to 3D space.
 *
 * @param disparity Input single-channel 8-bit unsigned, 16-bit signed, 32-bit signed or 32-bit
 * floating-point disparity image. The values of 8-bit / 16-bit signed formats are assumed to have no
 * fractional bits. If the disparity is 16-bit signed format, as computed by *Ref:* StereoBM or
 * Ref:* StereoSGBM and maybe other algorithms, it should be divided by 16 (and scaled to float) before
 * being used here.
 * @param _3dImage Output 3-channel floating-point image of the same size as disparity. Each element of
 * _3dImage(x,y) contains 3D coordinates of the point (x,y) computed from the disparity map. If one
 * uses Q obtained by *Ref:* stereoRectify, then the returned points are represented in the first
 * camera's rectified coordinate system.
 * @param Q `$$4 \times 4$$` perspective transformation matrix that can be obtained with
 * Ref:* stereoRectify.
 * points where the disparity was not computed). If handleMissingValues=true, then pixels with the
 * minimal disparity that corresponds to the outliers (see StereoMatcher::compute ) are transformed
 * to 3D points with a very large Z value (currently set to 10000).
 * depth. ddepth can also be set to CV_16S, CV_32S or CV_32F.
 *
 * The function transforms a single-channel disparity map to a 3-channel image representing a 3D
 * surface. That is, for each pixel (x,y) and the corresponding disparity d=disparity(x,y) , it
 * computes:
 *
 * `$$\begin{bmatrix}
 * X \\
 * Y \\
 * Z \\
 * W
 * \end{bmatrix} = Q \begin{bmatrix}
 * x \\
 * y \\
 * \texttt{disparity} (x,y) \\
 * 1
 * \end{bmatrix}.$$`
 *
 * @sa
 *    To reproject a sparse set of points {(x,y,d),...} to 3D space, use perspectiveTransform.
 */
+ (void)reprojectImageTo3D:(Mat*)disparity _3dImage:(Mat*)_3dImage Q:(Mat*)Q NS_SWIFT_NAME(reprojectImageTo3D(disparity:_3dImage:Q:));



@end

NS_ASSUME_NONNULL_END


