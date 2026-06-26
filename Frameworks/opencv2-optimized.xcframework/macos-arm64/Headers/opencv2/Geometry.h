//
// This file is auto-generated. Please don't modify it!
//
#pragma once

#ifdef __cplusplus
//#import "opencv.hpp"
#import "opencv2/geometry.hpp"
#else
#define CV_EXPORTS
#endif

#import <Foundation/Foundation.h>

@class Double2;
@class Double3;
@class Int4;
@class IntVector;
@class Mat;
@class Moments;
@class Point2d;
@class Point2f;
@class Point2i;
@class Rect2i;
@class RotatedRect;
@class Size2i;
@class TermCriteria;
@class UsacParams;


// C++: enum DistanceTypes (cv.DistanceTypes)
typedef NS_ENUM(int, DistanceTypes) {
    DIST_USER = -1,
    DIST_L1 = 1,
    DIST_L2 = 2,
    DIST_C = 3,
    DIST_L12 = 4,
    DIST_FAIR = 5,
    DIST_WELSCH = 6,
    DIST_HUBER = 7
};


// C++: enum LocalOptimMethod (cv.LocalOptimMethod)
typedef NS_ENUM(int, LocalOptimMethod) {
    LOCAL_OPTIM_NULL = 0,
    LOCAL_OPTIM_INNER_LO = 1,
    LOCAL_OPTIM_INNER_AND_ITER_LO = 2,
    LOCAL_OPTIM_GC = 3,
    LOCAL_OPTIM_SIGMA = 4
};


// C++: enum MSTAlgorithm (cv.MSTAlgorithm)
typedef NS_ENUM(int, MSTAlgorithm) {
    MST_PRIM = 0,
    MST_KRUSKAL = 1
};


// C++: enum MatrixType (cv.MatrixType)
typedef NS_ENUM(int, MatrixType) {
    MatrixType_AUTO NS_SWIFT_NAME(AUTO) = 0,
    MatrixType_DENSE NS_SWIFT_NAME(DENSE) = 1,
    MatrixType_SPARSE NS_SWIFT_NAME(SPARSE) = 2
};


// C++: enum NeighborSearchMethod (cv.NeighborSearchMethod)
typedef NS_ENUM(int, NeighborSearchMethod) {
    NEIGH_FLANN_KNN = 0,
    NEIGH_GRID = 1,
    NEIGH_FLANN_RADIUS = 2
};


// C++: enum PolishingMethod (cv.PolishingMethod)
typedef NS_ENUM(int, PolishingMethod) {
    NONE_POLISHER = 0,
    LSQ_POLISHER = 1,
    MAGSAC = 2,
    COV_POLISHER = 3
};


// C++: enum RectanglesIntersectTypes (cv.RectanglesIntersectTypes)
typedef NS_ENUM(int, RectanglesIntersectTypes) {
    INTERSECT_NONE = 0,
    INTERSECT_PARTIAL = 1,
    INTERSECT_FULL = 2
};


// C++: enum SacMethod (cv.SacMethod)
typedef NS_ENUM(int, SacMethod) {
    SAC_METHOD_RANSAC = 0
};


// C++: enum SacModelType (cv.SacModelType)
typedef NS_ENUM(int, SacModelType) {
    SAC_MODEL_PLANE = 0,
    SAC_MODEL_SPHERE = 1
};


// C++: enum SamplingMethod (cv.SamplingMethod)
typedef NS_ENUM(int, SamplingMethod) {
    SAMPLING_UNIFORM = 0,
    SAMPLING_PROGRESSIVE_NAPSAC = 1,
    SAMPLING_NAPSAC = 2,
    SAMPLING_PROSAC = 3
};


// C++: enum ScoreMethod (cv.ScoreMethod)
typedef NS_ENUM(int, ScoreMethod) {
    SCORE_METHOD_RANSAC = 0,
    SCORE_METHOD_MSAC = 1,
    SCORE_METHOD_MAGSAC = 2,
    SCORE_METHOD_LMEDS = 3
};


// C++: enum SolvePnPMethod (cv.SolvePnPMethod)
typedef NS_ENUM(int, SolvePnPMethod) {
    SOLVEPNP_ITERATIVE = 0,
    SOLVEPNP_EPNP = 1,
    SOLVEPNP_P3P = 2,
    SOLVEPNP_AP3P = 3,
    SOLVEPNP_IPPE = 4,
    SOLVEPNP_IPPE_SQUARE = 5,
    SOLVEPNP_SQPNP = 6,
    SOLVEPNP_MAX_COUNT = 6+1
};


// C++: enum VariableType (cv.VariableType)
typedef NS_ENUM(int, VariableType) {
    VariableType_LINEAR NS_SWIFT_NAME(LINEAR) = 0,
    VariableType_SO3 NS_SWIFT_NAME(SO3) = 1,
    VariableType_SE3 NS_SWIFT_NAME(SE3) = 2
};



NS_ASSUME_NONNULL_BEGIN

// C++: class Geometry
/**
 * The Geometry module
 *
 * Member classes: `MSTEdge`, `Subdiv2D`, `UsacParams`
 *
 * Member enums: `SacMethod`, `SacModelType`, `MSTAlgorithm`, `RectanglesIntersectTypes`, `DistanceTypes`, `SolvePnPMethod`, `SamplingMethod`, `LocalOptimMethod`, `ScoreMethod`, `NeighborSearchMethod`, `PolishingMethod`, `MatrixType`, `VariableType`
 */
CV_EXPORTS @interface Geometry : NSObject

#pragma mark - Class Constants


@property (class, readonly) int LMEDS NS_SWIFT_NAME(LMEDS);
@property (class, readonly) int RANSAC NS_SWIFT_NAME(RANSAC);
@property (class, readonly) int RHO NS_SWIFT_NAME(RHO);
@property (class, readonly) int USAC_DEFAULT NS_SWIFT_NAME(USAC_DEFAULT);
@property (class, readonly) int USAC_PARALLEL NS_SWIFT_NAME(USAC_PARALLEL);
@property (class, readonly) int USAC_FM_8PTS NS_SWIFT_NAME(USAC_FM_8PTS);
@property (class, readonly) int USAC_FAST NS_SWIFT_NAME(USAC_FAST);
@property (class, readonly) int USAC_ACCURATE NS_SWIFT_NAME(USAC_ACCURATE);
@property (class, readonly) int USAC_PROSAC NS_SWIFT_NAME(USAC_PROSAC);
@property (class, readonly) int USAC_MAGSAC NS_SWIFT_NAME(USAC_MAGSAC);
@property (class, readonly) int FM_7POINT NS_SWIFT_NAME(FM_7POINT);
@property (class, readonly) int FM_8POINT NS_SWIFT_NAME(FM_8POINT);
@property (class, readonly) int FM_LMEDS NS_SWIFT_NAME(FM_LMEDS);
@property (class, readonly) int FM_RANSAC NS_SWIFT_NAME(FM_RANSAC);

#pragma mark - Methods


//
//  bool cv::buildMST(int numNodes, vector_MSTEdge inputEdges, vector_MSTEdge& resultingEdges, MSTAlgorithm algorithm, int root = 0)
//
// Unknown type 'vector_MSTEdge' (I), skipping the function


//
//  void cv::approxPolyDP(vector_Point2f curve, vector_Point2f& approxCurve, double epsilon, bool closed)
//
/**
 * Approximates a polygonal curve(s) with the specified precision.
 *
 *  T he function cv::approxPolyDP approximates a curve or a p*olygon with another curve/polygon with less
 *  vertices so that the distance between them is less or equal to the specified precision. It uses the
 *  Douglas-Peucker algorithm <https://en.wikipedia.org/wiki/Ramer-Douglas-Peucker_algorithm>
 *
 * @param curve Input vector of a 2D point stored in std::vector or Mat
 * @param approxCurve Result of the approximation. The type should match the type of the input curve.
 * @param epsilon Parameter specifying the approximation accuracy. This is the maximum distance
 *  between the original curve and its approximation.
 * @param closed If true, the approximated curve is closed (its first and last vertices are
 *  connected). Otherwise, it is not closed.
 */
+ (void)approxPolyDP:(NSArray<Point2f*>*)curve approxCurve:(NSMutableArray<Point2f*>*)approxCurve epsilon:(double)epsilon closed:(BOOL)closed NS_SWIFT_NAME(approxPolyDP(curve:approxCurve:epsilon:closed:));


//
//  void cv::approxPolyN(Mat curve, Mat& approxCurve, int nsides, float epsilon_percentage = -1.0, bool ensure_convex = true)
//
/**
 * Approximates a polygon with a convex hull with a specified accuracy and number of sides.
 *
 *  T he cv::approxPolyN function approximates a polygon with *a convex hull
 *  so that the difference between the contour area of the original contour and the new polygon is minimal.
 *  It uses a greedy algorithm for contracting two vertices into one in such a way that the additional area is minimal.
 *  Straight lines formed by each edge of the convex contour are drawn and the areas of the resulting triangles are considered.
 *  Each vertex will lie either on the original contour or outside it.
 *
 *  The algorithm based on the paper *Cite:* LowIlie2003 .
 *
 * @param curve Input vector of a 2D points stored in std::vector or Mat, points must be float or integer.
 * @param approxCurve Result of the approximation. The type is vector of a 2D point (Point2f or Point) in std::vector or Mat.
 * @param nsides The parameter defines the number of sides of the result polygon.
 * @param epsilon_percentage defines the percentage of the maximum of additional area.
 *  If it equals -1, it is not used. Otherwise algorithm stops if additional area is greater than contourArea(_curve) * percentage.
 *  If additional area exceeds the limit, algorithm returns as many vertices as there were at the moment the limit was exceeded.
 * @param ensure_convex If it is true, algorithm creates a convex hull of input contour. Otherwise input vector should be convex.
 */
+ (void)approxPolyN:(Mat*)curve approxCurve:(Mat*)approxCurve nsides:(int)nsides epsilon_percentage:(float)epsilon_percentage ensure_convex:(BOOL)ensure_convex NS_SWIFT_NAME(approxPolyN(curve:approxCurve:nsides:epsilon_percentage:ensure_convex:));

/**
 * Approximates a polygon with a convex hull with a specified accuracy and number of sides.
 *
 *  T he cv::approxPolyN function approximates a polygon with *a convex hull
 *  so that the difference between the contour area of the original contour and the new polygon is minimal.
 *  It uses a greedy algorithm for contracting two vertices into one in such a way that the additional area is minimal.
 *  Straight lines formed by each edge of the convex contour are drawn and the areas of the resulting triangles are considered.
 *  Each vertex will lie either on the original contour or outside it.
 *
 *  The algorithm based on the paper *Cite:* LowIlie2003 .
 *
 * @param curve Input vector of a 2D points stored in std::vector or Mat, points must be float or integer.
 * @param approxCurve Result of the approximation. The type is vector of a 2D point (Point2f or Point) in std::vector or Mat.
 * @param nsides The parameter defines the number of sides of the result polygon.
 * @param epsilon_percentage defines the percentage of the maximum of additional area.
 *  If it equals -1, it is not used. Otherwise algorithm stops if additional area is greater than contourArea(_curve) * percentage.
 *  If additional area exceeds the limit, algorithm returns as many vertices as there were at the moment the limit was exceeded.
 */
+ (void)approxPolyN:(Mat*)curve approxCurve:(Mat*)approxCurve nsides:(int)nsides epsilon_percentage:(float)epsilon_percentage NS_SWIFT_NAME(approxPolyN(curve:approxCurve:nsides:epsilon_percentage:));

/**
 * Approximates a polygon with a convex hull with a specified accuracy and number of sides.
 *
 *  T he cv::approxPolyN function approximates a polygon with *a convex hull
 *  so that the difference between the contour area of the original contour and the new polygon is minimal.
 *  It uses a greedy algorithm for contracting two vertices into one in such a way that the additional area is minimal.
 *  Straight lines formed by each edge of the convex contour are drawn and the areas of the resulting triangles are considered.
 *  Each vertex will lie either on the original contour or outside it.
 *
 *  The algorithm based on the paper *Cite:* LowIlie2003 .
 *
 * @param curve Input vector of a 2D points stored in std::vector or Mat, points must be float or integer.
 * @param approxCurve Result of the approximation. The type is vector of a 2D point (Point2f or Point) in std::vector or Mat.
 * @param nsides The parameter defines the number of sides of the result polygon.
 *  If it equals -1, it is not used. Otherwise algorithm stops if additional area is greater than contourArea(_curve) * percentage.
 *  If additional area exceeds the limit, algorithm returns as many vertices as there were at the moment the limit was exceeded.
 */
+ (void)approxPolyN:(Mat*)curve approxCurve:(Mat*)approxCurve nsides:(int)nsides NS_SWIFT_NAME(approxPolyN(curve:approxCurve:nsides:));


//
//  RotatedRect cv::minAreaRect(vector_Point2f points)
//
/**
 * Finds a rotated rectangle of the minimum area enclosing the input 2D point set.
 *
 * The function calculates and returns the minimum-area bounding rectangle (possibly rotated) for a
 * specified point set. The angle of rotation represents the angle between the line connecting the starting
 * and ending points (based on the clockwise order with greatest index for the corner with greatest `$$y$$`)
 * and the horizontal axis. This angle always falls between `$$[-90, 0)$$` because, if the object
 * rotates more than a rect angle, the next edge is used to measure the angle. The starting and ending points change
 * as the object rotates.Developer should keep in mind that the returned RotatedRect can contain negative
 * indices when data is close to the containing Mat element boundary.
 *
 * @param points Input vector of 2D points, stored in std::vector\<\> or Mat
 */
+ (RotatedRect*)minAreaRect:(NSArray<Point2f*>*)points NS_SWIFT_NAME(minAreaRect(points:));


//
//  void cv::boxPoints(RotatedRect box, Mat& points)
//
/**
 * Finds the four vertices of a rotated rect. Useful to draw the rotated rectangle.
 *
 * The function finds the four vertices of a rotated rectangle. The four vertices are returned
 * in clockwise order starting from the point with greatest `$$y$$`. If two points have the
 * same `$$y$$` coordinate the rightmost is the starting point. This function is useful to draw the
 * rectangle. In C++, instead of using this function, you can directly use RotatedRect::points method. Please
 * visit the *Ref:* tutorial_bounding_rotated_ellipses "tutorial on Creating Bounding rotated boxes and ellipses
 * for contours" for more information.
 *
 * @param box The input rotated rectangle. It may be the output of *Ref:* minAreaRect.
 * @param points The output array of four vertices of rectangles.
 */
+ (void)boxPoints:(RotatedRect*)box points:(Mat*)points NS_SWIFT_NAME(boxPoints(box:points:));


//
//  void cv::minEnclosingCircle(vector_Point2f points, Point2f& center, float& radius)
//
/**
 * Finds a circle of the minimum area enclosing a 2D point set.
 *
 * The function finds the minimal enclosing circle of a 2D point set using an iterative algorithm.
 *
 * @param points Input vector of 2D points, stored in std::vector\<\> or Mat
 * @param center Output center of the circle.
 * @param radius Output radius of the circle.
 */
+ (void)minEnclosingCircle:(NSArray<Point2f*>*)points center:(Point2f*)center radius:(float*)radius NS_SWIFT_NAME(minEnclosingCircle(points:center:radius:));


//
//  double cv::minEnclosingTriangle(Mat points, Mat& triangle)
//
/**
 * Finds a triangle of minimum area enclosing a 2D point set and returns its area.
 *
 * The function finds a triangle of minimum area enclosing the given set of 2D points and returns its
 * area. The output for a given 2D point set is shown in the image below. 2D points are depicted in
 * red* and the enclosing triangle in *yellow*.
 *
 * ![Sample output of the minimum enclosing triangle function](minenclosingtriangle)
 *
 * The implementation of the algorithm is based on O'Rourke's *Cite:* ORourke86 and Klee and Laskowski's
 * *Cite:* KleeLaskowski85 papers. O'Rourke provides a `$$\theta(n)$$` algorithm for finding the minimal
 * enclosing triangle of a 2D convex polygon with n vertices. Since the *minEnclosingTriangle* function
 * takes a 2D point set as input an additional preprocessing step of computing the convex hull of the
 * 2D point set is required. The complexity of the ``Geometry/convexHull`` function is `$$O(n log(n))$$` which is higher
 * than `$$\theta(n)$$`. Thus the overall complexity of the function is `$$O(n log(n))$$`.
 *
 * @param points Input vector of 2D points with depth CV_32S or CV_32F, stored in std::vector\<\> or Mat
 * @param triangle Output vector of three 2D points defining the vertices of the triangle. The depth
 * of the OutputArray must be CV_32F.
 */
+ (double)minEnclosingTriangle:(Mat*)points triangle:(Mat*)triangle NS_SWIFT_NAME(minEnclosingTriangle(points:triangle:));


//
//  double cv::minEnclosingConvexPolygon(Mat points, Mat& polygon, int k)
//
/**
 * Finds a convex polygon of minimum area enclosing a 2D point set and returns its area.
 *
 * This function takes a given set of 2D points and finds the enclosing polygon with k vertices and minimal
 * area. It takes the set of points and the parameter k as input and returns the area of the minimal
 * enclosing polygon.
 *
 * The Implementation is based on a paper by Aggarwal, Chang and Yap *Cite:* Aggarwal1985. They
 * provide a `$$\theta(n²log(n)log(k))$$` algorithm for finding the minimal convex polygon with k
 * vertices enclosing a 2D convex polygon with n vertices (k < n). Since the *minEnclosingConvexPolygon*
 * function takes a 2D point set as input, an additional preprocessing step of computing the convex hull
 * of the 2D point set is required. The complexity of the ``Geometry/convexHull`` function is `$$O(n log(n))$$` which
 * is lower than `$$\theta(n²log(n)log(k))$$`. Thus the overall complexity of the function is
 * `$$O(n²log(n)log(k))$$`.
 *
 * @param points   Input vector of 2D points, stored in std::vector\<\> or Mat
 * @param polygon  Output vector of 2D points defining the vertices of the enclosing polygon
 * @param k        Number of vertices of the output polygon
 */
+ (double)minEnclosingConvexPolygon:(Mat*)points polygon:(Mat*)polygon k:(int)k NS_SWIFT_NAME(minEnclosingConvexPolygon(points:polygon:k:));


//
//  Moments cv::moments(Mat array, bool binaryImage = false)
//
/**
 * Calculates all of the moments up to the third order of a polygon or rasterized shape.
 *
 * The function computes moments, up to the 3rd order, of a vector shape or a rasterized shape. The
 * results are returned in the structure cv::Moments.
 *
 * @param array Single channel raster image (CV_8U, CV_16U, CV_16S, CV_32F, CV_64F) or an array (
 * `$$1 \times N$$` or `$$N \times 1$$` ) of 2D points (Point or Point2f).
 * @param binaryImage If it is true, all non-zero image pixels are treated as 1's. The parameter is
 * used for images only.
 * @return moments.
 *
 * *Note:* Only applicable to contour moments calculations from Python bindings: Note that the numpy
 * type for the input array should be either np.int32 or np.float32.
 *
 * *Note:* For contour-based moments, the zeroth-order moment \c m00 represents
 * the contour area.
 *
 * If the input contour is degenerate (for example, a single point or all points
 * are collinear), the area is zero and therefore \c m00 == 0.
 *
 * In this case, the centroid coordinates (\c m10/m00, \c m01/m00) are undefined
 * and must be handled explicitly by the caller.
 *
 * A common workaround is to compute the center using cv::boundingRect() or by
 * averaging the input points.
 *
 * - SeeAlso ``contourArea:oriented:``, ``arcLength:closed:``
 */
+ (Moments*)moments:(Mat*)array binaryImage:(BOOL)binaryImage NS_SWIFT_NAME(moments(array:binaryImage:));

/**
 * Calculates all of the moments up to the third order of a polygon or rasterized shape.
 *
 * The function computes moments, up to the 3rd order, of a vector shape or a rasterized shape. The
 * results are returned in the structure cv::Moments.
 *
 * @param array Single channel raster image (CV_8U, CV_16U, CV_16S, CV_32F, CV_64F) or an array (
 * `$$1 \times N$$` or `$$N \times 1$$` ) of 2D points (Point or Point2f).
 * used for images only.
 * @return moments.
 *
 * *Note:* Only applicable to contour moments calculations from Python bindings: Note that the numpy
 * type for the input array should be either np.int32 or np.float32.
 *
 * *Note:* For contour-based moments, the zeroth-order moment \c m00 represents
 * the contour area.
 *
 * If the input contour is degenerate (for example, a single point or all points
 * are collinear), the area is zero and therefore \c m00 == 0.
 *
 * In this case, the centroid coordinates (\c m10/m00, \c m01/m00) are undefined
 * and must be handled explicitly by the caller.
 *
 * A common workaround is to compute the center using cv::boundingRect() or by
 * averaging the input points.
 *
 * - SeeAlso ``contourArea:oriented:``, ``arcLength:closed:``
 */
+ (Moments*)moments:(Mat*)array NS_SWIFT_NAME(moments(array:));


//
//  void cv::HuMoments(Moments m, Mat& hu)
//
+ (void)HuMoments:(Moments*)m hu:(Mat*)hu NS_SWIFT_NAME(HuMoments(m:hu:));


//
//  double cv::matchShapes(Mat contour1, Mat contour2, ShapeMatchModes method, double parameter)
//
// Unknown type 'ShapeMatchModes' (I), skipping the function


//
//  void cv::convexHull(vector_Point points, vector_int& hull, bool clockwise = false,  _hidden_  returnPoints = true)
//
/**
 * Finds the convex hull of a point set.
 *
 * The function cv::convexHull finds the convex hull of a 2D point set using the Sklansky's algorithm *Cite:* Sklansky82
 * that has *O(N logN)* complexity in the current implementation.
 *
 * @param points Input 2D point set, stored in std::vector or Mat.
 * @param hull Output convex hull. It is either an integer vector of indices or vector of points. In
 * the first case, the hull elements are 0-based indices of the convex hull points in the original
 * array (since the set of convex hull points is a subset of the original point set). In the second
 * case, hull elements are the convex hull points themselves.
 * @param clockwise Orientation flag. If it is true, the output convex hull is oriented clockwise.
 * Otherwise, it is oriented counter-clockwise. The assumed coordinate system has its X axis pointing
 * to the right, and its Y axis pointing upwards.
 * @param returnPoints Operation flag. In case of a matrix, when the flag is true, the function
 * returns convex hull points. Otherwise, it returns indices of the convex hull points. When the
 * output array is std::vector, the flag is ignored, and the output depends on the type of the
 * vector: std::vector\<int\> implies returnPoints=false, std::vector\<Point\> implies
 * returnPoints=true.
 *
 * *Note:* `points` and `hull` should be different arrays, inplace processing isn't supported.
 *
 * Check *Ref:* tutorial_hull "the corresponding tutorial" for more details.
 *
 * useful links:
 *
 * https://www.learnopencv.com/convex-hull-using-opencv-in-python-and-c/
 */
+ (void)convexHull:(NSArray<Point2i*>*)points hull:(IntVector*)hull clockwise:(BOOL)clockwise NS_SWIFT_NAME(convexHull(points:hull:clockwise:));

/**
 * Finds the convex hull of a point set.
 *
 * The function cv::convexHull finds the convex hull of a 2D point set using the Sklansky's algorithm *Cite:* Sklansky82
 * that has *O(N logN)* complexity in the current implementation.
 *
 * @param points Input 2D point set, stored in std::vector or Mat.
 * @param hull Output convex hull. It is either an integer vector of indices or vector of points. In
 * the first case, the hull elements are 0-based indices of the convex hull points in the original
 * array (since the set of convex hull points is a subset of the original point set). In the second
 * case, hull elements are the convex hull points themselves.
 * Otherwise, it is oriented counter-clockwise. The assumed coordinate system has its X axis pointing
 * to the right, and its Y axis pointing upwards.
 * returns convex hull points. Otherwise, it returns indices of the convex hull points. When the
 * output array is std::vector, the flag is ignored, and the output depends on the type of the
 * vector: std::vector\<int\> implies returnPoints=false, std::vector\<Point\> implies
 * returnPoints=true.
 *
 * *Note:* `points` and `hull` should be different arrays, inplace processing isn't supported.
 *
 * Check *Ref:* tutorial_hull "the corresponding tutorial" for more details.
 *
 * useful links:
 *
 * https://www.learnopencv.com/convex-hull-using-opencv-in-python-and-c/
 */
+ (void)convexHull:(NSArray<Point2i*>*)points hull:(IntVector*)hull NS_SWIFT_NAME(convexHull(points:hull:));


//
//  void cv::convexityDefects(vector_Point contour, vector_int convexhull, vector_Vec4i& convexityDefects)
//
/**
 * Finds the convexity defects of a contour.
 *
 * The figure below displays convexity defects of a hand contour:
 *
 * ![image](defects)
 *
 * @param contour Input contour.
 * @param convexhull Convex hull obtained using convexHull that should contain indices of the contour
 * points that make the hull.
 * @param convexityDefects The output vector of convexity defects. In C++ and the new Python/Java
 * interface each convexity defect is represented as 4-element integer vector (a.k.a. #Vec4i):
 * (start_index, end_index, farthest_pt_index, fixpt_depth), where indices are 0-based indices
 * in the original contour of the convexity defect beginning, end and the farthest point, and
 * fixpt_depth is fixed-point approximation (with 8 fractional bits) of the distance between the
 * farthest contour point and the hull. That is, to get the floating-point value of the depth will be
 * fixpt_depth/256.0.
 */
+ (void)convexityDefects:(NSArray<Point2i*>*)contour convexhull:(IntVector*)convexhull convexityDefects:(NSMutableArray<Int4*>*)convexityDefects NS_SWIFT_NAME(convexityDefects(contour:convexhull:convexityDefects:));


//
//  bool cv::isContourConvex(vector_Point contour)
//
/**
 * Tests a contour convexity.
 *
 * The function tests whether the input contour is convex or not. The contour must be simple, that is,
 * without self-intersections. Otherwise, the function output is undefined.
 *
 * @param contour Input vector of 2D points, stored in std::vector\<\> or Mat
 */
+ (BOOL)isContourConvex:(NSArray<Point2i*>*)contour NS_SWIFT_NAME(isContourConvex(contour:));


//
//  float cv::intersectConvexConvex(Mat p1, Mat p2, Mat& p12, bool handleNested = true)
//
/**
 * Finds intersection of two convex polygons
 *
 * @param p1 First polygon
 * @param p2 Second polygon
 * @param p12 Output polygon describing the intersecting area
 * @param handleNested When true, an intersection is found if one of the polygons is fully enclosed in the other.
 * When false, no intersection is found. If the polygons share a side or the vertex of one polygon lies on an edge
 * of the other, they are not considered nested and an intersection will be found regardless of the value of handleNested.
 *
 * @return Area of intersecting polygon. May be negative, if algorithm has not converged, e.g. non-convex input.
 *
 * *Note:* intersectConvexConvex doesn't confirm that both polygons are convex and will return invalid results if they aren't.
 */
+ (float)intersectConvexConvex:(Mat*)p1 p2:(Mat*)p2 p12:(Mat*)p12 handleNested:(BOOL)handleNested NS_SWIFT_NAME(intersectConvexConvex(p1:p2:p12:handleNested:));

/**
 * Finds intersection of two convex polygons
 *
 * @param p1 First polygon
 * @param p2 Second polygon
 * @param p12 Output polygon describing the intersecting area
 * When false, no intersection is found. If the polygons share a side or the vertex of one polygon lies on an edge
 * of the other, they are not considered nested and an intersection will be found regardless of the value of handleNested.
 *
 * @return Area of intersecting polygon. May be negative, if algorithm has not converged, e.g. non-convex input.
 *
 * *Note:* intersectConvexConvex doesn't confirm that both polygons are convex and will return invalid results if they aren't.
 */
+ (float)intersectConvexConvex:(Mat*)p1 p2:(Mat*)p2 p12:(Mat*)p12 NS_SWIFT_NAME(intersectConvexConvex(p1:p2:p12:));


//
//  RotatedRect cv::fitEllipse(vector_Point2f points)
//
/**
 * Fits an ellipse around a set of 2D points.
 *
 * The function calculates the ellipse that fits (in a least-squares sense) a set of 2D points best of
 * all. It returns the rotated rectangle in which the ellipse is inscribed. The first algorithm described by *Cite:* Fitzgibbon95
 * is used. Developer should keep in mind that it is possible that the returned
 * ellipse/rotatedRect data contains negative indices, due to the data points being close to the
 * border of the containing Mat element.
 *
 * @param points Input 2D point set, stored in std::vector\<\> or Mat
 *
 * *Note:* Input point types are *Ref:* Point2i or *Ref:* Point2f and at least 5 points are required.
 * *Note:* *Ref:* getClosestEllipsePoints function can be used to compute the ellipse fitting error.
 */
+ (RotatedRect*)fitEllipse:(NSArray<Point2f*>*)points NS_SWIFT_NAME(fitEllipse(points:));


//
//  RotatedRect cv::fitEllipseAMS(Mat points)
//
/**
 * Fits an ellipse around a set of 2D points.
 *
 * The function calculates the ellipse that fits a set of 2D points.
 * It returns the rotated rectangle in which the ellipse is inscribed.
 * The Approximate Mean Square (AMS) proposed by *Cite:* Taubin1991 is used.
 *
 * For an ellipse, this basis set is `$$ \chi= \left(x^2, x y, y^2, x, y, 1\right) $$`,
 * which is a set of six free coefficients `$$ A^T=\left\{A_{\text{xx}},A_{\text{xy}},A_{\text{yy}},A_x,A_y,A_0\right\} $$`.
 * However, to specify an ellipse, all that is needed is five numbers; the major and minor axes lengths `$$ (a,b) $$`,
 * the position `$$ (x_0,y_0) $$`, and the orientation `$$ \theta $$`. This is because the basis set includes lines,
 * quadratics, parabolic and hyperbolic functions as well as elliptical functions as possible fits.
 * If the fit is found to be a parabolic or hyperbolic function then the standard ``Geometry/fitEllipse`` method is used.
 * The AMS method restricts the fit to parabolic, hyperbolic and elliptical curves
 * by imposing the condition that `$$ A^T ( D_x^T D_x  +   D_y^T D_y) A = 1 $$` where
 * the matrices `$$ Dx $$` and `$$ Dy $$` are the partial derivatives of the design matrix `$$ D $$` with
 * respect to x and y. The matrices are formed row by row applying the following to
 * each of the points in the set:
 * `$$\begin{aligned}
 * D(i,:)&=\left\{x_i^2, x_i y_i, y_i^2, x_i, y_i, 1\right\} &
 * D_x(i,:)&=\left\{2 x_i,y_i,0,1,0,0\right\} &
 * D_y(i,:)&=\left\{0,x_i,2 y_i,0,1,0\right\}
 * \end{aligned}$$`
 * The AMS method minimizes the cost function
 * `$$\begin{aligned}
 * \epsilon ^2=\frac{ A^T D^T D A }{ A^T (D_x^T D_x +  D_y^T D_y) A^T }
 * \end{aligned}$$`
 *
 * The minimum cost is found by solving the generalized eigenvalue problem.
 *
 * `$$\begin{aligned}
 * D^T D A = \lambda  \left( D_x^T D_x +  D_y^T D_y\right) A
 * \end{aligned}$$`
 *
 * @param points Input 2D point set, stored in std::vector\<\> or Mat
 *
 * *Note:* Input point types are *Ref:* Point2i or *Ref:* Point2f and at least 5 points are required.
 * *Note:* *Ref:* getClosestEllipsePoints function can be used to compute the ellipse fitting error.
 */
+ (RotatedRect*)fitEllipseAMS:(Mat*)points NS_SWIFT_NAME(fitEllipseAMS(points:));


//
//  RotatedRect cv::fitEllipseDirect(Mat points)
//
/**
 * Fits an ellipse around a set of 2D points.
 *
 * The function calculates the ellipse that fits a set of 2D points.
 * It returns the rotated rectangle in which the ellipse is inscribed.
 * The Direct least square (Direct) method by *Cite:* oy1998NumericallySD is used.
 *
 * For an ellipse, this basis set is `$$ \chi= \left(x^2, x y, y^2, x, y, 1\right) $$`,
 * which is a set of six free coefficients `$$ A^T=\left\{A_{\text{xx}},A_{\text{xy}},A_{\text{yy}},A_x,A_y,A_0\right\} $$`.
 * However, to specify an ellipse, all that is needed is five numbers; the major and minor axes lengths `$$ (a,b) $$`,
 * the position `$$ (x_0,y_0) $$`, and the orientation `$$ \theta $$`. This is because the basis set includes lines,
 * quadratics, parabolic and hyperbolic functions as well as elliptical functions as possible fits.
 * The Direct method confines the fit to ellipses by ensuring that `$$ 4 A_{xx} A_{yy}- A_{xy}^2 > 0 $$`.
 * The condition imposed is that `$$ 4 A_{xx} A_{yy}- A_{xy}^2=1 $$` which satisfies the inequality
 * and as the coefficients can be arbitrarily scaled is not overly restrictive.
 *
 * `$$\begin{aligned}
 * \epsilon ^2= A^T D^T D A \quad \text{with} \quad A^T C A =1 \quad \text{and} \quad C=\left(\begin{matrix}
 * 0 & 0  & 2  & 0  & 0  &  0  \\
 * 0 & -1  & 0  & 0  & 0  &  0 \\
 * 2 & 0  & 0  & 0  & 0  &  0 \\
 * 0 & 0  & 0  & 0  & 0  &  0 \\
 * 0 & 0  & 0  & 0  & 0  &  0 \\
 * 0 & 0  & 0  & 0  & 0  &  0
 * \end{matrix} \right)
 * \end{aligned}$$`
 *
 * The minimum cost is found by solving the generalized eigenvalue problem.
 *
 * `$$\begin{aligned}
 * D^T D A = \lambda  \left( C\right) A
 * \end{aligned}$$`
 *
 * The system produces only one positive eigenvalue `$$ \lambda$$` which is chosen as the solution
 * with its eigenvector `$$\mathbf{u}$$`. These are used to find the coefficients
 *
 * `$$\begin{aligned}
 * A = \sqrt{\frac{1}{\mathbf{u}^T C \mathbf{u}}}  \mathbf{u}
 * \end{aligned}$$`
 * The scaling factor guarantees that  `$$A^T C A =1$$`.
 *
 * @param points Input 2D point set, stored in std::vector\<\> or Mat
 *
 * *Note:* Input point types are *Ref:* Point2i or *Ref:* Point2f and at least 5 points are required.
 * *Note:* *Ref:* getClosestEllipsePoints function can be used to compute the ellipse fitting error.
 */
+ (RotatedRect*)fitEllipseDirect:(Mat*)points NS_SWIFT_NAME(fitEllipseDirect(points:));


//
//  void cv::getClosestEllipsePoints(RotatedRect ellipse_params, Mat points, Mat& closest_pts)
//
/**
 * Compute for each 2d point the nearest 2d point located on a given ellipse.
 *
 * The function computes the nearest 2d location on a given ellipse for a vector of 2d points and is based on *Cite:* Chatfield2017 code.
 * This function can be used to compute for instance the ellipse fitting error.
 *
 * @param ellipse_params Ellipse parameters
 * @param points Input 2d points
 * @param closest_pts For each 2d point, their corresponding closest 2d point located on a given ellipse
 *
 * *Note:* Input point types are *Ref:* Point2i or *Ref:* Point2f
 * - SeeAlso ``fitEllipse:``, ``fitEllipseAMS:``, ``fitEllipseDirect:``
 */
+ (void)getClosestEllipsePoints:(RotatedRect*)ellipse_params points:(Mat*)points closest_pts:(Mat*)closest_pts NS_SWIFT_NAME(getClosestEllipsePoints(ellipse_params:points:closest_pts:));


//
//  void cv::fitLine(Mat points, Mat& line, DistanceTypes distType, double param, double reps, double aeps)
//
/**
 * Fits a line to a 2D or 3D point set.
 *
 * The function fitLine fits a line to a 2D or 3D point set by minimizing `$$\sum_i \rho(r_i)$$` where
 * `$$r_i$$` is a distance between the `$$i^{th}$$` point, the line and `$$\rho(r)$$` is a distance function, one
 * of the following:
 * -  DIST_L2
 * `$$\rho (r) = r^2/2  \quad \text{(the simplest and the fastest least-squares method)}$$`
 * - DIST_L1
 * `$$\rho (r) = r$$`
 * - DIST_L12
 * `$$\rho (r) = 2  \cdot ( \sqrt{1 + \frac{r^2}{2}} - 1)$$`
 * - DIST_FAIR
 * `$$\rho \left (r \right ) = C^2  \cdot \left (  \frac{r}{C} -  \log{\left(1 + \frac{r}{C}\right)} \right )  \quad \text{where} \quad C=1.3998$$`
 * - DIST_WELSCH
 * `$$\rho \left (r \right ) =  \frac{C^2}{2} \cdot \left ( 1 -  \exp{\left(-\left(\frac{r}{C}\right)^2\right)} \right )  \quad \text{where} \quad C=2.9846$$`
 * - DIST_HUBER
 * `$$\newcommand{\fork}[4]{ \left\{ \begin{array}{l l} #1 & \text{#2}\\\\ #3 & \text{#4}\\\\ \end{array} \right.} \rho (r) =  \fork{r^2/2}{if \(r < C\)}{C \cdot (r-C/2)}{otherwise} \quad \text{where} \quad C=1.345$$`
 *
 * The algorithm is based on the M-estimator ( <https://en.wikipedia.org/wiki/M-estimator> ) technique
 * that iteratively fits the line using the weighted least-squares algorithm. After each iteration the
 * weights `$$w_i$$` are adjusted to be inversely proportional to `$$\rho(r_i)$$` .
 *
 * @param points Input vector of 2D or 3D points, stored in std::vector\<\> or Mat.
 * @param line Output line parameters. In case of 2D fitting, it should be a vector of 4 elements
 * (like Vec4f) - (vx, vy, x0, y0), where (vx, vy) is a normalized vector collinear to the line and
 * (x0, y0) is a point on the line. In case of 3D fitting, it should be a vector of 6 elements (like
 * Vec6f) - (vx, vy, vz, x0, y0, z0), where (vx, vy, vz) is a normalized vector collinear to the line
 * and (x0, y0, z0) is a point on the line.
 * @param distType Distance used by the M-estimator, see ``DistanceTypes``
 * @param param Numerical parameter ( C ) for some types of distances. If it is 0, an optimal value
 * is chosen.
 * @param reps Sufficient accuracy for the radius (distance between the coordinate origin and the line).
 * @param aeps Sufficient accuracy for the angle. 0.01 would be a good default value for reps and aeps.
 */
+ (void)fitLine:(Mat*)points line:(Mat*)line distType:(DistanceTypes)distType param:(double)param reps:(double)reps aeps:(double)aeps NS_SWIFT_NAME(fitLine(points:line:distType:param:reps:aeps:));


//
//  double cv::pointPolygonTest(vector_Point2f contour, Point2f pt, bool measureDist)
//
/**
 * Performs a point-in-contour test.
 *
 * The function determines whether the point is inside a contour, outside, or lies on an edge (or
 * coincides with a vertex). It returns positive (inside), negative (outside), or zero (on an edge)
 * value, correspondingly. When measureDist=false , the return value is +1, -1, and 0, respectively.
 * Otherwise, the return value is a signed distance between the point and the nearest contour edge.
 *
 * See below a sample output of the function where each image pixel is tested against the contour:
 *
 * ![sample output](pointpolygon)
 *
 * @param contour Input contour.
 * @param pt Point tested against the contour.
 * @param measureDist If true, the function estimates the signed distance from the point to the
 * nearest contour edge. Otherwise, the function only checks if the point is inside a contour or not.
 */
+ (double)pointPolygonTest:(NSArray<Point2f*>*)contour pt:(Point2f*)pt measureDist:(BOOL)measureDist NS_SWIFT_NAME(pointPolygonTest(contour:pt:measureDist:));


//
//  int cv::rotatedRectangleIntersection(RotatedRect rect1, RotatedRect rect2, Mat& intersectingRegion)
//
/**
 * Finds out if there is any intersection between two rotated rectangles.
 *
 * If there is then the vertices of the intersecting region are returned as well.
 *
 * Below are some examples of intersection configurations. The hatched pattern indicates the
 * intersecting region and the red vertices are returned by the function.
 *
 * ![intersection examples](intersection)
 *
 * @param rect1 First rectangle
 * @param rect2 Second rectangle
 * @param intersectingRegion The output array of the vertices of the intersecting region. It returns
 * at most 8 vertices. Stored as std::vector\<cv::Point2f\> or cv::Mat as Mx1 of type CV_32FC2.
 * @return One of ``RectanglesIntersectTypes``
 */
+ (int)rotatedRectangleIntersection:(RotatedRect*)rect1 rect2:(RotatedRect*)rect2 intersectingRegion:(Mat*)intersectingRegion NS_SWIFT_NAME(rotatedRectangleIntersection(rect1:rect2:intersectingRegion:));


//
//  double cv::arcLength(vector_Point2f curve, bool closed)
//
/**
 * Calculates a contour perimeter or a curve length.
 *
 * The function computes a curve length or a closed contour perimeter.
 *
 * @param curve Input vector of 2D points, stored in std::vector or Mat.
 * @param closed Flag indicating whether the curve is closed or not.
 */
+ (double)arcLength:(NSArray<Point2f*>*)curve closed:(BOOL)closed NS_SWIFT_NAME(arcLength(curve:closed:));


//
//  double cv::contourArea(Mat contour, bool oriented = false)
//
/**
 * Calculates a contour area.
 *
 * The function computes a contour area. Similarly to moments , the area is computed using the Green
 * formula. Thus, the returned area and the number of non-zero pixels, if you draw the contour using
 * #drawContours or #fillPoly , can be different. Also, the function will most certainly give a wrong
 * results for contours with self-intersections.
 *
 * Example:
 *
 * vector<Point> contour;
 * contour.push_back(Point2f(0, 0));
 * contour.push_back(Point2f(10, 0));
 * contour.push_back(Point2f(10, 10));
 * contour.push_back(Point2f(5, 4));
 *
 * double area0 = contourArea(contour);
 * vector<Point> approx;
 * approxPolyDP(contour, approx, 5, true);
 * double area1 = contourArea(approx);
 *
 * cout << "area0 =" << area0 << endl <<
 * "area1 =" << area1 << endl <<
 * "approx poly vertices" << approx.size() << endl;
 *
 * @param contour Input vector of 2D points (contour vertices), stored in std::vector or Mat.
 * @param oriented Oriented area flag. If it is true, the function returns a signed area value,
 * depending on the contour orientation (clockwise or counter-clockwise). Using this feature you can
 * determine orientation of a contour by taking the sign of an area. By default, the parameter is
 * false, which means that the absolute value is returned.
 */
+ (double)contourArea:(Mat*)contour oriented:(BOOL)oriented NS_SWIFT_NAME(contourArea(contour:oriented:));

/**
 * Calculates a contour area.
 *
 * The function computes a contour area. Similarly to moments , the area is computed using the Green
 * formula. Thus, the returned area and the number of non-zero pixels, if you draw the contour using
 * #drawContours or #fillPoly , can be different. Also, the function will most certainly give a wrong
 * results for contours with self-intersections.
 *
 * Example:
 *
 * vector<Point> contour;
 * contour.push_back(Point2f(0, 0));
 * contour.push_back(Point2f(10, 0));
 * contour.push_back(Point2f(10, 10));
 * contour.push_back(Point2f(5, 4));
 *
 * double area0 = contourArea(contour);
 * vector<Point> approx;
 * approxPolyDP(contour, approx, 5, true);
 * double area1 = contourArea(approx);
 *
 * cout << "area0 =" << area0 << endl <<
 * "area1 =" << area1 << endl <<
 * "approx poly vertices" << approx.size() << endl;
 *
 * @param contour Input vector of 2D points (contour vertices), stored in std::vector or Mat.
 * depending on the contour orientation (clockwise or counter-clockwise). Using this feature you can
 * determine orientation of a contour by taking the sign of an area. By default, the parameter is
 * false, which means that the absolute value is returned.
 */
+ (double)contourArea:(Mat*)contour NS_SWIFT_NAME(contourArea(contour:));


//
//  Rect cv::boundingRect(Mat array)
//
/**
 * Calculates the up-right bounding rectangle of a point set or non-zero pixels of gray-scale image.
 *
 * The function calculates and returns the minimal up-right bounding rectangle for the specified point set or
 * non-zero pixels of gray-scale image.
 *
 * @param array Input gray-scale image or 2D point set, stored in std::vector or Mat.
 */
+ (Rect2i*)boundingRect:(Mat*)array NS_SWIFT_NAME(boundingRect(array:));


//
//  Mat cv::getRotationMatrix2D(Point2f center, double angle, double scale)
//
/**
 * Calculates an affine matrix of 2D rotation.
 *
 * The function calculates the following matrix:
 *
 * `$$\begin{bmatrix} \alpha &  \beta & (1- \alpha )  \cdot \texttt{center.x} -  \beta \cdot \texttt{center.y} \\ - \beta &  \alpha &  \beta \cdot \texttt{center.x} + (1- \alpha )  \cdot \texttt{center.y} \end{bmatrix}$$`
 *
 * where
 *
 * `$$\begin{array}{l} \alpha =  \texttt{scale} \cdot \cos \texttt{angle} , \\ \beta =  \texttt{scale} \cdot \sin \texttt{angle} \end{array}$$`
 *
 * The transformation maps the rotation center to itself. If this is not the target, adjust the shift.
 *
 * @param center Center of the rotation in the source image.
 * @param angle Rotation angle in degrees. Positive values mean counter-clockwise rotation (the
 * coordinate origin is assumed to be the top-left corner).
 * @param scale Isotropic scale factor.
 *
 * - SeeAlso ``getAffineTransform:dst:``, warpAffine, transform
 */
+ (Mat*)getRotationMatrix2D:(Point2f*)center angle:(double)angle scale:(double)scale NS_SWIFT_NAME(getRotationMatrix2D(center:angle:scale:));


//
//  void cv::invertAffineTransform(Mat M, Mat& iM)
//
/**
 * Inverts an affine transformation.
 *
 * The function computes an inverse affine transformation represented by `$$2 \times 3$$` matrix M:
 *
 * `$$\begin{bmatrix} a_{11} & a_{12} & b_1  \\ a_{21} & a_{22} & b_2 \end{bmatrix}$$`
 *
 * The result is also a `$$2 \times 3$$` matrix of the same type as M.
 *
 * @param M Original affine transformation.
 * @param iM Output reverse affine transformation.
 */
+ (void)invertAffineTransform:(Mat*)M iM:(Mat*)iM NS_SWIFT_NAME(invertAffineTransform(M:iM:));


//
//  Mat cv::getPerspectiveTransform(Mat src, Mat dst, int solveMethod = DECOMP_LU)
//
/**
 * Calculates a perspective transform from four pairs of the corresponding points.
 *
 * The function calculates the `$$3 \times 3$$` matrix of a perspective transform so that:
 *
 * `$$\begin{bmatrix} t_i x'_i \\ t_i y'_i \\ t_i \end{bmatrix} = \texttt{map\_matrix} \cdot \begin{bmatrix} x_i \\ y_i \\ 1 \end{bmatrix}$$`
 *
 * where
 *
 * `$$dst(i)=(x'_i,y'_i), src(i)=(x_i, y_i), i=0,1,2,3$$`
 *
 * @param src Coordinates of quadrangle vertices in the source image.
 * @param dst Coordinates of the corresponding quadrangle vertices in the destination image.
 * @param solveMethod method passed to cv::solve (``DecompTypes``)
 *
 * - SeeAlso ``findHomography:dstPoints:method:ransacReprojThreshold:mask:maxIters:confidence:``, warpPerspective, perspectiveTransform
 */
+ (Mat*)getPerspectiveTransform:(Mat*)src dst:(Mat*)dst solveMethod:(int)solveMethod NS_SWIFT_NAME(getPerspectiveTransform(src:dst:solveMethod:));

/**
 * Calculates a perspective transform from four pairs of the corresponding points.
 *
 * The function calculates the `$$3 \times 3$$` matrix of a perspective transform so that:
 *
 * `$$\begin{bmatrix} t_i x'_i \\ t_i y'_i \\ t_i \end{bmatrix} = \texttt{map\_matrix} \cdot \begin{bmatrix} x_i \\ y_i \\ 1 \end{bmatrix}$$`
 *
 * where
 *
 * `$$dst(i)=(x'_i,y'_i), src(i)=(x_i, y_i), i=0,1,2,3$$`
 *
 * @param src Coordinates of quadrangle vertices in the source image.
 * @param dst Coordinates of the corresponding quadrangle vertices in the destination image.
 *
 * - SeeAlso ``findHomography:dstPoints:method:ransacReprojThreshold:mask:maxIters:confidence:``, warpPerspective, perspectiveTransform
 */
+ (Mat*)getPerspectiveTransform:(Mat*)src dst:(Mat*)dst NS_SWIFT_NAME(getPerspectiveTransform(src:dst:));


//
//  Mat cv::getAffineTransform(vector_Point2f src, vector_Point2f dst)
//
+ (Mat*)getAffineTransform:(NSArray<Point2f*>*)src dst:(NSArray<Point2f*>*)dst NS_SWIFT_NAME(getAffineTransform(src:dst:));


//
//  void cv::Rodrigues(Mat src, Mat& dst, Mat& jacobian = Mat())
//
/**
 * Converts a rotation matrix to a rotation vector or vice versa.
 *
 * @param src Input rotation vector (3x1 or 1x3) or rotation matrix (3x3).
 * @param dst Output rotation matrix (3x3) or rotation vector (3x1 or 1x3), respectively.
 * @param jacobian Optional output Jacobian matrix, 3x9 or 9x3, which is a matrix of partial
 * derivatives of the output array components with respect to the input array components.
 *
 * `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \begin{array}{l} \theta \leftarrow norm(r) \\ r  \leftarrow r/ \theta \\ R =  \cos(\theta) I + (1- \cos{\theta} ) r r^T +  \sin(\theta) \vecthreethree{0}{-r_z}{r_y}{r_z}{0}{-r_x}{-r_y}{r_x}{0} \end{array}$$`
 *
 * Inverse transformation can be also done easily, since
 *
 * `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \sin ( \theta ) \vecthreethree{0}{-r_z}{r_y}{r_z}{0}{-r_x}{-r_y}{r_x}{0} = \frac{R - R^T}{2}$$`
 *
 * A rotation vector is a convenient and most compact representation of a rotation matrix (since any
 * rotation matrix has just 3 degrees of freedom). The representation is used in the global 3D geometry
 * optimization procedures like *Ref:* calibrateCamera, *Ref:* stereoCalibrate, or *Ref:* solvePnP .
 *
 * Note:* More information about the computation of the derivative of a 3D rotation matrix with respect to its exponential coordinate
 * can be found in:
 *     - A Compact Formula for the Derivative of a 3-D Rotation in Exponential Coordinates, Guillermo Gallego, Anthony J. Yezzi *Cite:* Gallego2014ACF
 *
 * Note:* Useful information on SE(3) and Lie Groups can be found in:
 *     - A tutorial on SE(3) transformation parameterizations and on-manifold optimization, Jose-Luis Blanco *Cite:* blanco2010tutorial
 *     - Lie Groups for 2D and 3D Transformation, Ethan Eade *Cite:* Eade17
 *     - A micro Lie theory for state estimation in robotics, Joan Solà, Jérémie Deray, Dinesh Atchuthan *Cite:* Sol2018AML
 */
+ (void)Rodrigues:(Mat*)src dst:(Mat*)dst jacobian:(Mat*)jacobian NS_SWIFT_NAME(Rodrigues(src:dst:jacobian:));

/**
 * Converts a rotation matrix to a rotation vector or vice versa.
 *
 * @param src Input rotation vector (3x1 or 1x3) or rotation matrix (3x3).
 * @param dst Output rotation matrix (3x3) or rotation vector (3x1 or 1x3), respectively.
 * derivatives of the output array components with respect to the input array components.
 *
 * `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \begin{array}{l} \theta \leftarrow norm(r) \\ r  \leftarrow r/ \theta \\ R =  \cos(\theta) I + (1- \cos{\theta} ) r r^T +  \sin(\theta) \vecthreethree{0}{-r_z}{r_y}{r_z}{0}{-r_x}{-r_y}{r_x}{0} \end{array}$$`
 *
 * Inverse transformation can be also done easily, since
 *
 * `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \sin ( \theta ) \vecthreethree{0}{-r_z}{r_y}{r_z}{0}{-r_x}{-r_y}{r_x}{0} = \frac{R - R^T}{2}$$`
 *
 * A rotation vector is a convenient and most compact representation of a rotation matrix (since any
 * rotation matrix has just 3 degrees of freedom). The representation is used in the global 3D geometry
 * optimization procedures like *Ref:* calibrateCamera, *Ref:* stereoCalibrate, or *Ref:* solvePnP .
 *
 * Note:* More information about the computation of the derivative of a 3D rotation matrix with respect to its exponential coordinate
 * can be found in:
 *     - A Compact Formula for the Derivative of a 3-D Rotation in Exponential Coordinates, Guillermo Gallego, Anthony J. Yezzi *Cite:* Gallego2014ACF
 *
 * Note:* Useful information on SE(3) and Lie Groups can be found in:
 *     - A tutorial on SE(3) transformation parameterizations and on-manifold optimization, Jose-Luis Blanco *Cite:* blanco2010tutorial
 *     - Lie Groups for 2D and 3D Transformation, Ethan Eade *Cite:* Eade17
 *     - A micro Lie theory for state estimation in robotics, Joan Solà, Jérémie Deray, Dinesh Atchuthan *Cite:* Sol2018AML
 */
+ (void)Rodrigues:(Mat*)src dst:(Mat*)dst NS_SWIFT_NAME(Rodrigues(src:dst:));


//
//  Mat cv::findHomography(Mat srcPoints, Mat dstPoints, int method = 0, double ransacReprojThreshold = 3, Mat& mask = Mat(), int maxIters = 2000, double confidence = 0.995)
//
/**
 * Finds a perspective transformation between two planes.
 *
 * @param srcPoints Coordinates of the points in the original plane, a matrix of the type CV_32FC2
 * or vector\<Point2f\> .
 * @param dstPoints Coordinates of the points in the target plane, a matrix of the type CV_32FC2 or
 * a vector\<Point2f\> .
 * @param method Method used to compute a homography matrix. The following methods are possible:
 * -   **0** - a regular method using all the points, i.e., the least squares method
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * -   *Ref:* RHO - PROSAC-based robust method
 * @param ransacReprojThreshold Maximum allowed reprojection error to treat a point pair as an inlier
 * (used in the RANSAC and RHO methods only). That is, if
 * `$$\| \texttt{dstPoints} _i -  \texttt{convertPointsHomogeneous} ( \texttt{H} \cdot \texttt{srcPoints} _i) \|_2  >  \texttt{ransacReprojThreshold}$$`
 * then the point `$$i$$` is considered as an outlier. If srcPoints and dstPoints are measured in pixels,
 * it usually makes sense to set this parameter somewhere in the range of 1 to 10.
 * @param mask Optional output mask set by a robust method ( RANSAC or LMeDS ). Note that the input
 * mask values are ignored.
 * @param maxIters The maximum number of RANSAC iterations.
 * @param confidence Confidence level, between 0 and 1.
 *
 * The function finds and returns the perspective transformation `$$H$$` between the source and the
 * destination planes:
 *
 * `$$s_i  \vecthree{x'_i}{y'_i}{1} \sim H  \vecthree{x_i}{y_i}{1}$$`
 *
 * so that the back-projection error
 *
 * `$$\sum _i \left ( x'_i- \frac{h_{11} x_i + h_{12} y_i + h_{13}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2+ \left ( y'_i- \frac{h_{21} x_i + h_{22} y_i + h_{23}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2$$`
 *
 * is minimized. If the parameter method is set to the default value 0, the function uses all the point
 * pairs to compute an initial homography estimate with a simple least-squares scheme.
 *
 * However, if not all of the point pairs ( `$$srcPoints_i$$`, `$$dstPoints_i$$` ) fit the rigid perspective
 * transformation (that is, there are some outliers), this initial estimate will be poor. In this case,
 * you can use one of the three robust methods. The methods RANSAC, LMeDS and RHO try many different
 * random subsets of the corresponding point pairs (of four pairs each, collinear pairs are discarded), estimate the homography matrix
 * using this subset and a simple least-squares algorithm, and then compute the quality/goodness of the
 * computed homography (which is the number of inliers for RANSAC or the least median re-projection error for
 * LMeDS). The best subset is then used to produce the initial estimate of the homography matrix and
 * the mask of inliers/outliers.
 *
 * Regardless of the method, robust or not, the computed homography matrix is refined further (using
 * inliers only in case of a robust method) with the Levenberg-Marquardt method to reduce the
 * re-projection error even more.
 *
 * The methods RANSAC and RHO can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers. Finally, if there are no outliers and the
 * noise is rather small, use the default method (method=0).
 *
 * The function is used to find initial intrinsic and extrinsic matrices. Homography matrix is
 * determined up to a scale. If `$$h_{33}$$` is non-zero, the matrix is normalized so that `$$h_{33}=1$$`.
 * Note:* Whenever an `$$H$$` matrix cannot be estimated, an empty one will be returned.
 *
 * @sa
 * getAffineTransform, estimateAffine2D, estimateAffinePartial2D, getPerspectiveTransform, warpPerspective,
 * perspectiveTransform
 */
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold mask:(Mat*)mask maxIters:(int)maxIters confidence:(double)confidence NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:method:ransacReprojThreshold:mask:maxIters:confidence:));

/**
 * Finds a perspective transformation between two planes.
 *
 * @param srcPoints Coordinates of the points in the original plane, a matrix of the type CV_32FC2
 * or vector\<Point2f\> .
 * @param dstPoints Coordinates of the points in the target plane, a matrix of the type CV_32FC2 or
 * a vector\<Point2f\> .
 * @param method Method used to compute a homography matrix. The following methods are possible:
 * -   **0** - a regular method using all the points, i.e., the least squares method
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * -   *Ref:* RHO - PROSAC-based robust method
 * @param ransacReprojThreshold Maximum allowed reprojection error to treat a point pair as an inlier
 * (used in the RANSAC and RHO methods only). That is, if
 * `$$\| \texttt{dstPoints} _i -  \texttt{convertPointsHomogeneous} ( \texttt{H} \cdot \texttt{srcPoints} _i) \|_2  >  \texttt{ransacReprojThreshold}$$`
 * then the point `$$i$$` is considered as an outlier. If srcPoints and dstPoints are measured in pixels,
 * it usually makes sense to set this parameter somewhere in the range of 1 to 10.
 * @param mask Optional output mask set by a robust method ( RANSAC or LMeDS ). Note that the input
 * mask values are ignored.
 * @param maxIters The maximum number of RANSAC iterations.
 *
 * The function finds and returns the perspective transformation `$$H$$` between the source and the
 * destination planes:
 *
 * `$$s_i  \vecthree{x'_i}{y'_i}{1} \sim H  \vecthree{x_i}{y_i}{1}$$`
 *
 * so that the back-projection error
 *
 * `$$\sum _i \left ( x'_i- \frac{h_{11} x_i + h_{12} y_i + h_{13}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2+ \left ( y'_i- \frac{h_{21} x_i + h_{22} y_i + h_{23}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2$$`
 *
 * is minimized. If the parameter method is set to the default value 0, the function uses all the point
 * pairs to compute an initial homography estimate with a simple least-squares scheme.
 *
 * However, if not all of the point pairs ( `$$srcPoints_i$$`, `$$dstPoints_i$$` ) fit the rigid perspective
 * transformation (that is, there are some outliers), this initial estimate will be poor. In this case,
 * you can use one of the three robust methods. The methods RANSAC, LMeDS and RHO try many different
 * random subsets of the corresponding point pairs (of four pairs each, collinear pairs are discarded), estimate the homography matrix
 * using this subset and a simple least-squares algorithm, and then compute the quality/goodness of the
 * computed homography (which is the number of inliers for RANSAC or the least median re-projection error for
 * LMeDS). The best subset is then used to produce the initial estimate of the homography matrix and
 * the mask of inliers/outliers.
 *
 * Regardless of the method, robust or not, the computed homography matrix is refined further (using
 * inliers only in case of a robust method) with the Levenberg-Marquardt method to reduce the
 * re-projection error even more.
 *
 * The methods RANSAC and RHO can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers. Finally, if there are no outliers and the
 * noise is rather small, use the default method (method=0).
 *
 * The function is used to find initial intrinsic and extrinsic matrices. Homography matrix is
 * determined up to a scale. If `$$h_{33}$$` is non-zero, the matrix is normalized so that `$$h_{33}=1$$`.
 * Note:* Whenever an `$$H$$` matrix cannot be estimated, an empty one will be returned.
 *
 * @sa
 * getAffineTransform, estimateAffine2D, estimateAffinePartial2D, getPerspectiveTransform, warpPerspective,
 * perspectiveTransform
 */
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold mask:(Mat*)mask maxIters:(int)maxIters NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:method:ransacReprojThreshold:mask:maxIters:));

/**
 * Finds a perspective transformation between two planes.
 *
 * @param srcPoints Coordinates of the points in the original plane, a matrix of the type CV_32FC2
 * or vector\<Point2f\> .
 * @param dstPoints Coordinates of the points in the target plane, a matrix of the type CV_32FC2 or
 * a vector\<Point2f\> .
 * @param method Method used to compute a homography matrix. The following methods are possible:
 * -   **0** - a regular method using all the points, i.e., the least squares method
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * -   *Ref:* RHO - PROSAC-based robust method
 * @param ransacReprojThreshold Maximum allowed reprojection error to treat a point pair as an inlier
 * (used in the RANSAC and RHO methods only). That is, if
 * `$$\| \texttt{dstPoints} _i -  \texttt{convertPointsHomogeneous} ( \texttt{H} \cdot \texttt{srcPoints} _i) \|_2  >  \texttt{ransacReprojThreshold}$$`
 * then the point `$$i$$` is considered as an outlier. If srcPoints and dstPoints are measured in pixels,
 * it usually makes sense to set this parameter somewhere in the range of 1 to 10.
 * @param mask Optional output mask set by a robust method ( RANSAC or LMeDS ). Note that the input
 * mask values are ignored.
 *
 * The function finds and returns the perspective transformation `$$H$$` between the source and the
 * destination planes:
 *
 * `$$s_i  \vecthree{x'_i}{y'_i}{1} \sim H  \vecthree{x_i}{y_i}{1}$$`
 *
 * so that the back-projection error
 *
 * `$$\sum _i \left ( x'_i- \frac{h_{11} x_i + h_{12} y_i + h_{13}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2+ \left ( y'_i- \frac{h_{21} x_i + h_{22} y_i + h_{23}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2$$`
 *
 * is minimized. If the parameter method is set to the default value 0, the function uses all the point
 * pairs to compute an initial homography estimate with a simple least-squares scheme.
 *
 * However, if not all of the point pairs ( `$$srcPoints_i$$`, `$$dstPoints_i$$` ) fit the rigid perspective
 * transformation (that is, there are some outliers), this initial estimate will be poor. In this case,
 * you can use one of the three robust methods. The methods RANSAC, LMeDS and RHO try many different
 * random subsets of the corresponding point pairs (of four pairs each, collinear pairs are discarded), estimate the homography matrix
 * using this subset and a simple least-squares algorithm, and then compute the quality/goodness of the
 * computed homography (which is the number of inliers for RANSAC or the least median re-projection error for
 * LMeDS). The best subset is then used to produce the initial estimate of the homography matrix and
 * the mask of inliers/outliers.
 *
 * Regardless of the method, robust or not, the computed homography matrix is refined further (using
 * inliers only in case of a robust method) with the Levenberg-Marquardt method to reduce the
 * re-projection error even more.
 *
 * The methods RANSAC and RHO can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers. Finally, if there are no outliers and the
 * noise is rather small, use the default method (method=0).
 *
 * The function is used to find initial intrinsic and extrinsic matrices. Homography matrix is
 * determined up to a scale. If `$$h_{33}$$` is non-zero, the matrix is normalized so that `$$h_{33}=1$$`.
 * Note:* Whenever an `$$H$$` matrix cannot be estimated, an empty one will be returned.
 *
 * @sa
 * getAffineTransform, estimateAffine2D, estimateAffinePartial2D, getPerspectiveTransform, warpPerspective,
 * perspectiveTransform
 */
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold mask:(Mat*)mask NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:method:ransacReprojThreshold:mask:));

/**
 * Finds a perspective transformation between two planes.
 *
 * @param srcPoints Coordinates of the points in the original plane, a matrix of the type CV_32FC2
 * or vector\<Point2f\> .
 * @param dstPoints Coordinates of the points in the target plane, a matrix of the type CV_32FC2 or
 * a vector\<Point2f\> .
 * @param method Method used to compute a homography matrix. The following methods are possible:
 * -   **0** - a regular method using all the points, i.e., the least squares method
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * -   *Ref:* RHO - PROSAC-based robust method
 * @param ransacReprojThreshold Maximum allowed reprojection error to treat a point pair as an inlier
 * (used in the RANSAC and RHO methods only). That is, if
 * `$$\| \texttt{dstPoints} _i -  \texttt{convertPointsHomogeneous} ( \texttt{H} \cdot \texttt{srcPoints} _i) \|_2  >  \texttt{ransacReprojThreshold}$$`
 * then the point `$$i$$` is considered as an outlier. If srcPoints and dstPoints are measured in pixels,
 * it usually makes sense to set this parameter somewhere in the range of 1 to 10.
 * mask values are ignored.
 *
 * The function finds and returns the perspective transformation `$$H$$` between the source and the
 * destination planes:
 *
 * `$$s_i  \vecthree{x'_i}{y'_i}{1} \sim H  \vecthree{x_i}{y_i}{1}$$`
 *
 * so that the back-projection error
 *
 * `$$\sum _i \left ( x'_i- \frac{h_{11} x_i + h_{12} y_i + h_{13}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2+ \left ( y'_i- \frac{h_{21} x_i + h_{22} y_i + h_{23}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2$$`
 *
 * is minimized. If the parameter method is set to the default value 0, the function uses all the point
 * pairs to compute an initial homography estimate with a simple least-squares scheme.
 *
 * However, if not all of the point pairs ( `$$srcPoints_i$$`, `$$dstPoints_i$$` ) fit the rigid perspective
 * transformation (that is, there are some outliers), this initial estimate will be poor. In this case,
 * you can use one of the three robust methods. The methods RANSAC, LMeDS and RHO try many different
 * random subsets of the corresponding point pairs (of four pairs each, collinear pairs are discarded), estimate the homography matrix
 * using this subset and a simple least-squares algorithm, and then compute the quality/goodness of the
 * computed homography (which is the number of inliers for RANSAC or the least median re-projection error for
 * LMeDS). The best subset is then used to produce the initial estimate of the homography matrix and
 * the mask of inliers/outliers.
 *
 * Regardless of the method, robust or not, the computed homography matrix is refined further (using
 * inliers only in case of a robust method) with the Levenberg-Marquardt method to reduce the
 * re-projection error even more.
 *
 * The methods RANSAC and RHO can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers. Finally, if there are no outliers and the
 * noise is rather small, use the default method (method=0).
 *
 * The function is used to find initial intrinsic and extrinsic matrices. Homography matrix is
 * determined up to a scale. If `$$h_{33}$$` is non-zero, the matrix is normalized so that `$$h_{33}=1$$`.
 * Note:* Whenever an `$$H$$` matrix cannot be estimated, an empty one will be returned.
 *
 * @sa
 * getAffineTransform, estimateAffine2D, estimateAffinePartial2D, getPerspectiveTransform, warpPerspective,
 * perspectiveTransform
 */
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:method:ransacReprojThreshold:));

/**
 * Finds a perspective transformation between two planes.
 *
 * @param srcPoints Coordinates of the points in the original plane, a matrix of the type CV_32FC2
 * or vector\<Point2f\> .
 * @param dstPoints Coordinates of the points in the target plane, a matrix of the type CV_32FC2 or
 * a vector\<Point2f\> .
 * @param method Method used to compute a homography matrix. The following methods are possible:
 * -   **0** - a regular method using all the points, i.e., the least squares method
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * -   *Ref:* RHO - PROSAC-based robust method
 * (used in the RANSAC and RHO methods only). That is, if
 * `$$\| \texttt{dstPoints} _i -  \texttt{convertPointsHomogeneous} ( \texttt{H} \cdot \texttt{srcPoints} _i) \|_2  >  \texttt{ransacReprojThreshold}$$`
 * then the point `$$i$$` is considered as an outlier. If srcPoints and dstPoints are measured in pixels,
 * it usually makes sense to set this parameter somewhere in the range of 1 to 10.
 * mask values are ignored.
 *
 * The function finds and returns the perspective transformation `$$H$$` between the source and the
 * destination planes:
 *
 * `$$s_i  \vecthree{x'_i}{y'_i}{1} \sim H  \vecthree{x_i}{y_i}{1}$$`
 *
 * so that the back-projection error
 *
 * `$$\sum _i \left ( x'_i- \frac{h_{11} x_i + h_{12} y_i + h_{13}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2+ \left ( y'_i- \frac{h_{21} x_i + h_{22} y_i + h_{23}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2$$`
 *
 * is minimized. If the parameter method is set to the default value 0, the function uses all the point
 * pairs to compute an initial homography estimate with a simple least-squares scheme.
 *
 * However, if not all of the point pairs ( `$$srcPoints_i$$`, `$$dstPoints_i$$` ) fit the rigid perspective
 * transformation (that is, there are some outliers), this initial estimate will be poor. In this case,
 * you can use one of the three robust methods. The methods RANSAC, LMeDS and RHO try many different
 * random subsets of the corresponding point pairs (of four pairs each, collinear pairs are discarded), estimate the homography matrix
 * using this subset and a simple least-squares algorithm, and then compute the quality/goodness of the
 * computed homography (which is the number of inliers for RANSAC or the least median re-projection error for
 * LMeDS). The best subset is then used to produce the initial estimate of the homography matrix and
 * the mask of inliers/outliers.
 *
 * Regardless of the method, robust or not, the computed homography matrix is refined further (using
 * inliers only in case of a robust method) with the Levenberg-Marquardt method to reduce the
 * re-projection error even more.
 *
 * The methods RANSAC and RHO can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers. Finally, if there are no outliers and the
 * noise is rather small, use the default method (method=0).
 *
 * The function is used to find initial intrinsic and extrinsic matrices. Homography matrix is
 * determined up to a scale. If `$$h_{33}$$` is non-zero, the matrix is normalized so that `$$h_{33}=1$$`.
 * Note:* Whenever an `$$H$$` matrix cannot be estimated, an empty one will be returned.
 *
 * @sa
 * getAffineTransform, estimateAffine2D, estimateAffinePartial2D, getPerspectiveTransform, warpPerspective,
 * perspectiveTransform
 */
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints method:(int)method NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:method:));

/**
 * Finds a perspective transformation between two planes.
 *
 * @param srcPoints Coordinates of the points in the original plane, a matrix of the type CV_32FC2
 * or vector\<Point2f\> .
 * @param dstPoints Coordinates of the points in the target plane, a matrix of the type CV_32FC2 or
 * a vector\<Point2f\> .
 * -   **0** - a regular method using all the points, i.e., the least squares method
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * -   *Ref:* RHO - PROSAC-based robust method
 * (used in the RANSAC and RHO methods only). That is, if
 * `$$\| \texttt{dstPoints} _i -  \texttt{convertPointsHomogeneous} ( \texttt{H} \cdot \texttt{srcPoints} _i) \|_2  >  \texttt{ransacReprojThreshold}$$`
 * then the point `$$i$$` is considered as an outlier. If srcPoints and dstPoints are measured in pixels,
 * it usually makes sense to set this parameter somewhere in the range of 1 to 10.
 * mask values are ignored.
 *
 * The function finds and returns the perspective transformation `$$H$$` between the source and the
 * destination planes:
 *
 * `$$s_i  \vecthree{x'_i}{y'_i}{1} \sim H  \vecthree{x_i}{y_i}{1}$$`
 *
 * so that the back-projection error
 *
 * `$$\sum _i \left ( x'_i- \frac{h_{11} x_i + h_{12} y_i + h_{13}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2+ \left ( y'_i- \frac{h_{21} x_i + h_{22} y_i + h_{23}}{h_{31} x_i + h_{32} y_i + h_{33}} \right )^2$$`
 *
 * is minimized. If the parameter method is set to the default value 0, the function uses all the point
 * pairs to compute an initial homography estimate with a simple least-squares scheme.
 *
 * However, if not all of the point pairs ( `$$srcPoints_i$$`, `$$dstPoints_i$$` ) fit the rigid perspective
 * transformation (that is, there are some outliers), this initial estimate will be poor. In this case,
 * you can use one of the three robust methods. The methods RANSAC, LMeDS and RHO try many different
 * random subsets of the corresponding point pairs (of four pairs each, collinear pairs are discarded), estimate the homography matrix
 * using this subset and a simple least-squares algorithm, and then compute the quality/goodness of the
 * computed homography (which is the number of inliers for RANSAC or the least median re-projection error for
 * LMeDS). The best subset is then used to produce the initial estimate of the homography matrix and
 * the mask of inliers/outliers.
 *
 * Regardless of the method, robust or not, the computed homography matrix is refined further (using
 * inliers only in case of a robust method) with the Levenberg-Marquardt method to reduce the
 * re-projection error even more.
 *
 * The methods RANSAC and RHO can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers. Finally, if there are no outliers and the
 * noise is rather small, use the default method (method=0).
 *
 * The function is used to find initial intrinsic and extrinsic matrices. Homography matrix is
 * determined up to a scale. If `$$h_{33}$$` is non-zero, the matrix is normalized so that `$$h_{33}=1$$`.
 * Note:* Whenever an `$$H$$` matrix cannot be estimated, an empty one will be returned.
 *
 * @sa
 * getAffineTransform, estimateAffine2D, estimateAffinePartial2D, getPerspectiveTransform, warpPerspective,
 * perspectiveTransform
 */
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:));


//
//  Mat cv::findHomography(Mat srcPoints, Mat dstPoints, Mat& mask, UsacParams params)
//
+ (Mat*)findHomography:(Mat*)srcPoints dstPoints:(Mat*)dstPoints mask:(Mat*)mask params:(UsacParams*)params NS_SWIFT_NAME(findHomography(srcPoints:dstPoints:mask:params:));


//
//  Vec3d cv::RQDecomp3x3(Mat src, Mat& mtxR, Mat& mtxQ, Mat& Qx = Mat(), Mat& Qy = Mat(), Mat& Qz = Mat())
//
/**
 * Computes an RQ decomposition of 3x3 matrices.
 *
 * @param src 3x3 input matrix.
 * @param mtxR Output 3x3 upper-triangular matrix.
 * @param mtxQ Output 3x3 orthogonal matrix.
 * @param Qx Optional output 3x3 rotation matrix around x-axis.
 * @param Qy Optional output 3x3 rotation matrix around y-axis.
 * @param Qz Optional output 3x3 rotation matrix around z-axis.
 *
 * The function computes a RQ decomposition using the given rotations. This function is used in
 * ``Geometry/decomposeProjectionMatrix`` to decompose the left 3x3 submatrix of a projection matrix into a camera
 * and a rotation matrix.
 *
 * It optionally returns three rotation matrices, one for each axis, and the three Euler angles in
 * degrees (as the return value) that could be used in OpenGL. Note, there is always more than one
 * sequence of rotations about the three principal axes that results in the same orientation of an
 * object, e.g. see *Cite:* Slabaugh . Returned three rotation matrices and corresponding three Euler angles
 * are only one of the possible solutions.
 */
+ (Double3*)RQDecomp3x3:(Mat*)src mtxR:(Mat*)mtxR mtxQ:(Mat*)mtxQ Qx:(Mat*)Qx Qy:(Mat*)Qy Qz:(Mat*)Qz NS_SWIFT_NAME(RQDecomp3x3(src:mtxR:mtxQ:Qx:Qy:Qz:));

/**
 * Computes an RQ decomposition of 3x3 matrices.
 *
 * @param src 3x3 input matrix.
 * @param mtxR Output 3x3 upper-triangular matrix.
 * @param mtxQ Output 3x3 orthogonal matrix.
 * @param Qx Optional output 3x3 rotation matrix around x-axis.
 * @param Qy Optional output 3x3 rotation matrix around y-axis.
 *
 * The function computes a RQ decomposition using the given rotations. This function is used in
 * ``Geometry/decomposeProjectionMatrix`` to decompose the left 3x3 submatrix of a projection matrix into a camera
 * and a rotation matrix.
 *
 * It optionally returns three rotation matrices, one for each axis, and the three Euler angles in
 * degrees (as the return value) that could be used in OpenGL. Note, there is always more than one
 * sequence of rotations about the three principal axes that results in the same orientation of an
 * object, e.g. see *Cite:* Slabaugh . Returned three rotation matrices and corresponding three Euler angles
 * are only one of the possible solutions.
 */
+ (Double3*)RQDecomp3x3:(Mat*)src mtxR:(Mat*)mtxR mtxQ:(Mat*)mtxQ Qx:(Mat*)Qx Qy:(Mat*)Qy NS_SWIFT_NAME(RQDecomp3x3(src:mtxR:mtxQ:Qx:Qy:));

/**
 * Computes an RQ decomposition of 3x3 matrices.
 *
 * @param src 3x3 input matrix.
 * @param mtxR Output 3x3 upper-triangular matrix.
 * @param mtxQ Output 3x3 orthogonal matrix.
 * @param Qx Optional output 3x3 rotation matrix around x-axis.
 *
 * The function computes a RQ decomposition using the given rotations. This function is used in
 * ``Geometry/decomposeProjectionMatrix`` to decompose the left 3x3 submatrix of a projection matrix into a camera
 * and a rotation matrix.
 *
 * It optionally returns three rotation matrices, one for each axis, and the three Euler angles in
 * degrees (as the return value) that could be used in OpenGL. Note, there is always more than one
 * sequence of rotations about the three principal axes that results in the same orientation of an
 * object, e.g. see *Cite:* Slabaugh . Returned three rotation matrices and corresponding three Euler angles
 * are only one of the possible solutions.
 */
+ (Double3*)RQDecomp3x3:(Mat*)src mtxR:(Mat*)mtxR mtxQ:(Mat*)mtxQ Qx:(Mat*)Qx NS_SWIFT_NAME(RQDecomp3x3(src:mtxR:mtxQ:Qx:));

/**
 * Computes an RQ decomposition of 3x3 matrices.
 *
 * @param src 3x3 input matrix.
 * @param mtxR Output 3x3 upper-triangular matrix.
 * @param mtxQ Output 3x3 orthogonal matrix.
 *
 * The function computes a RQ decomposition using the given rotations. This function is used in
 * ``Geometry/decomposeProjectionMatrix`` to decompose the left 3x3 submatrix of a projection matrix into a camera
 * and a rotation matrix.
 *
 * It optionally returns three rotation matrices, one for each axis, and the three Euler angles in
 * degrees (as the return value) that could be used in OpenGL. Note, there is always more than one
 * sequence of rotations about the three principal axes that results in the same orientation of an
 * object, e.g. see *Cite:* Slabaugh . Returned three rotation matrices and corresponding three Euler angles
 * are only one of the possible solutions.
 */
+ (Double3*)RQDecomp3x3:(Mat*)src mtxR:(Mat*)mtxR mtxQ:(Mat*)mtxQ NS_SWIFT_NAME(RQDecomp3x3(src:mtxR:mtxQ:));


//
//  void cv::decomposeProjectionMatrix(Mat projMatrix, Mat& cameraMatrix, Mat& rotMatrix, Mat& transVect, Mat& rotMatrixX = Mat(), Mat& rotMatrixY = Mat(), Mat& rotMatrixZ = Mat(), Mat& eulerAngles = Mat())
//
/**
 * Decomposes a projection matrix into a rotation matrix and a camera intrinsic matrix.
 *
 * @param projMatrix 3x4 input projection matrix P.
 * @param cameraMatrix Output 3x3 camera intrinsic matrix `$$\cameramatrix{A}$$`.
 * @param rotMatrix Output 3x3 external rotation matrix R.
 * @param transVect Output 4x1 translation vector T.
 * @param rotMatrixX Optional 3x3 rotation matrix around x-axis.
 * @param rotMatrixY Optional 3x3 rotation matrix around y-axis.
 * @param rotMatrixZ Optional 3x3 rotation matrix around z-axis.
 * @param eulerAngles Optional three-element vector containing three Euler angles of rotation in
 * degrees.
 *
 * The function computes a decomposition of a projection matrix into a calibration and a rotation
 * matrix and the position of a camera.
 *
 * It optionally returns three rotation matrices, one for each axis, and three Euler angles that could
 * be used in OpenGL. Note, there is always more than one sequence of rotations about the three
 * principal axes that results in the same orientation of an object, e.g. see *Cite:* Slabaugh . Returned
 * three rotation matrices and corresponding three Euler angles are only one of the possible solutions.
 *
 * The function is based on ``Geometry/RQDecomp3x3`` .
 */
+ (void)decomposeProjectionMatrix:(Mat*)projMatrix cameraMatrix:(Mat*)cameraMatrix rotMatrix:(Mat*)rotMatrix transVect:(Mat*)transVect rotMatrixX:(Mat*)rotMatrixX rotMatrixY:(Mat*)rotMatrixY rotMatrixZ:(Mat*)rotMatrixZ eulerAngles:(Mat*)eulerAngles NS_SWIFT_NAME(decomposeProjectionMatrix(projMatrix:cameraMatrix:rotMatrix:transVect:rotMatrixX:rotMatrixY:rotMatrixZ:eulerAngles:));

/**
 * Decomposes a projection matrix into a rotation matrix and a camera intrinsic matrix.
 *
 * @param projMatrix 3x4 input projection matrix P.
 * @param cameraMatrix Output 3x3 camera intrinsic matrix `$$\cameramatrix{A}$$`.
 * @param rotMatrix Output 3x3 external rotation matrix R.
 * @param transVect Output 4x1 translation vector T.
 * @param rotMatrixX Optional 3x3 rotation matrix around x-axis.
 * @param rotMatrixY Optional 3x3 rotation matrix around y-axis.
 * @param rotMatrixZ Optional 3x3 rotation matrix around z-axis.
 * degrees.
 *
 * The function computes a decomposition of a projection matrix into a calibration and a rotation
 * matrix and the position of a camera.
 *
 * It optionally returns three rotation matrices, one for each axis, and three Euler angles that could
 * be used in OpenGL. Note, there is always more than one sequence of rotations about the three
 * principal axes that results in the same orientation of an object, e.g. see *Cite:* Slabaugh . Returned
 * three rotation matrices and corresponding three Euler angles are only one of the possible solutions.
 *
 * The function is based on ``Geometry/RQDecomp3x3`` .
 */
+ (void)decomposeProjectionMatrix:(Mat*)projMatrix cameraMatrix:(Mat*)cameraMatrix rotMatrix:(Mat*)rotMatrix transVect:(Mat*)transVect rotMatrixX:(Mat*)rotMatrixX rotMatrixY:(Mat*)rotMatrixY rotMatrixZ:(Mat*)rotMatrixZ NS_SWIFT_NAME(decomposeProjectionMatrix(projMatrix:cameraMatrix:rotMatrix:transVect:rotMatrixX:rotMatrixY:rotMatrixZ:));

/**
 * Decomposes a projection matrix into a rotation matrix and a camera intrinsic matrix.
 *
 * @param projMatrix 3x4 input projection matrix P.
 * @param cameraMatrix Output 3x3 camera intrinsic matrix `$$\cameramatrix{A}$$`.
 * @param rotMatrix Output 3x3 external rotation matrix R.
 * @param transVect Output 4x1 translation vector T.
 * @param rotMatrixX Optional 3x3 rotation matrix around x-axis.
 * @param rotMatrixY Optional 3x3 rotation matrix around y-axis.
 * degrees.
 *
 * The function computes a decomposition of a projection matrix into a calibration and a rotation
 * matrix and the position of a camera.
 *
 * It optionally returns three rotation matrices, one for each axis, and three Euler angles that could
 * be used in OpenGL. Note, there is always more than one sequence of rotations about the three
 * principal axes that results in the same orientation of an object, e.g. see *Cite:* Slabaugh . Returned
 * three rotation matrices and corresponding three Euler angles are only one of the possible solutions.
 *
 * The function is based on ``Geometry/RQDecomp3x3`` .
 */
+ (void)decomposeProjectionMatrix:(Mat*)projMatrix cameraMatrix:(Mat*)cameraMatrix rotMatrix:(Mat*)rotMatrix transVect:(Mat*)transVect rotMatrixX:(Mat*)rotMatrixX rotMatrixY:(Mat*)rotMatrixY NS_SWIFT_NAME(decomposeProjectionMatrix(projMatrix:cameraMatrix:rotMatrix:transVect:rotMatrixX:rotMatrixY:));

/**
 * Decomposes a projection matrix into a rotation matrix and a camera intrinsic matrix.
 *
 * @param projMatrix 3x4 input projection matrix P.
 * @param cameraMatrix Output 3x3 camera intrinsic matrix `$$\cameramatrix{A}$$`.
 * @param rotMatrix Output 3x3 external rotation matrix R.
 * @param transVect Output 4x1 translation vector T.
 * @param rotMatrixX Optional 3x3 rotation matrix around x-axis.
 * degrees.
 *
 * The function computes a decomposition of a projection matrix into a calibration and a rotation
 * matrix and the position of a camera.
 *
 * It optionally returns three rotation matrices, one for each axis, and three Euler angles that could
 * be used in OpenGL. Note, there is always more than one sequence of rotations about the three
 * principal axes that results in the same orientation of an object, e.g. see *Cite:* Slabaugh . Returned
 * three rotation matrices and corresponding three Euler angles are only one of the possible solutions.
 *
 * The function is based on ``Geometry/RQDecomp3x3`` .
 */
+ (void)decomposeProjectionMatrix:(Mat*)projMatrix cameraMatrix:(Mat*)cameraMatrix rotMatrix:(Mat*)rotMatrix transVect:(Mat*)transVect rotMatrixX:(Mat*)rotMatrixX NS_SWIFT_NAME(decomposeProjectionMatrix(projMatrix:cameraMatrix:rotMatrix:transVect:rotMatrixX:));

/**
 * Decomposes a projection matrix into a rotation matrix and a camera intrinsic matrix.
 *
 * @param projMatrix 3x4 input projection matrix P.
 * @param cameraMatrix Output 3x3 camera intrinsic matrix `$$\cameramatrix{A}$$`.
 * @param rotMatrix Output 3x3 external rotation matrix R.
 * @param transVect Output 4x1 translation vector T.
 * degrees.
 *
 * The function computes a decomposition of a projection matrix into a calibration and a rotation
 * matrix and the position of a camera.
 *
 * It optionally returns three rotation matrices, one for each axis, and three Euler angles that could
 * be used in OpenGL. Note, there is always more than one sequence of rotations about the three
 * principal axes that results in the same orientation of an object, e.g. see *Cite:* Slabaugh . Returned
 * three rotation matrices and corresponding three Euler angles are only one of the possible solutions.
 *
 * The function is based on ``Geometry/RQDecomp3x3`` .
 */
+ (void)decomposeProjectionMatrix:(Mat*)projMatrix cameraMatrix:(Mat*)cameraMatrix rotMatrix:(Mat*)rotMatrix transVect:(Mat*)transVect NS_SWIFT_NAME(decomposeProjectionMatrix(projMatrix:cameraMatrix:rotMatrix:transVect:));


//
//  void cv::matMulDeriv(Mat A, Mat B, Mat& dABdA, Mat& dABdB)
//
/**
 * Computes partial derivatives of the matrix product for each multiplied matrix.
 *
 * @param A First multiplied matrix.
 * @param B Second multiplied matrix.
 * @param dABdA First output derivative matrix d(A\*B)/dA of size
 * `$$\texttt{A.rows*B.cols} \times {A.rows*A.cols}$$` .
 * @param dABdB Second output derivative matrix d(A\*B)/dB of size
 * `$$\texttt{A.rows*B.cols} \times {B.rows*B.cols}$$` .
 *
 * The function computes partial derivatives of the elements of the matrix product `$$A*B$$` with regard to
 * the elements of each of the two input matrices. The function is used to compute the Jacobian
 * matrices in #stereoCalibrate but can also be used in any other similar optimization function.
 */
+ (void)matMulDeriv:(Mat*)A B:(Mat*)B dABdA:(Mat*)dABdA dABdB:(Mat*)dABdB NS_SWIFT_NAME(matMulDeriv(A:B:dABdA:dABdB:));


//
//  void cv::composeRT(Mat rvec1, Mat tvec1, Mat rvec2, Mat tvec2, Mat& rvec3, Mat& tvec3, Mat& dr3dr1 = Mat(), Mat& dr3dt1 = Mat(), Mat& dr3dr2 = Mat(), Mat& dr3dt2 = Mat(), Mat& dt3dr1 = Mat(), Mat& dt3dt1 = Mat(), Mat& dt3dr2 = Mat(), Mat& dt3dt2 = Mat())
//
/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 * @param dr3dr2 Optional output derivative of rvec3 with regard to rvec2
 * @param dr3dt2 Optional output derivative of rvec3 with regard to tvec2
 * @param dt3dr1 Optional output derivative of tvec3 with regard to rvec1
 * @param dt3dt1 Optional output derivative of tvec3 with regard to tvec1
 * @param dt3dr2 Optional output derivative of tvec3 with regard to rvec2
 * @param dt3dt2 Optional output derivative of tvec3 with regard to tvec2
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 dr3dr2:(Mat*)dr3dr2 dr3dt2:(Mat*)dr3dt2 dt3dr1:(Mat*)dt3dr1 dt3dt1:(Mat*)dt3dt1 dt3dr2:(Mat*)dt3dr2 dt3dt2:(Mat*)dt3dt2 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:dr3dr2:dr3dt2:dt3dr1:dt3dt1:dt3dr2:dt3dt2:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 * @param dr3dr2 Optional output derivative of rvec3 with regard to rvec2
 * @param dr3dt2 Optional output derivative of rvec3 with regard to tvec2
 * @param dt3dr1 Optional output derivative of tvec3 with regard to rvec1
 * @param dt3dt1 Optional output derivative of tvec3 with regard to tvec1
 * @param dt3dr2 Optional output derivative of tvec3 with regard to rvec2
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 dr3dr2:(Mat*)dr3dr2 dr3dt2:(Mat*)dr3dt2 dt3dr1:(Mat*)dt3dr1 dt3dt1:(Mat*)dt3dt1 dt3dr2:(Mat*)dt3dr2 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:dr3dr2:dr3dt2:dt3dr1:dt3dt1:dt3dr2:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 * @param dr3dr2 Optional output derivative of rvec3 with regard to rvec2
 * @param dr3dt2 Optional output derivative of rvec3 with regard to tvec2
 * @param dt3dr1 Optional output derivative of tvec3 with regard to rvec1
 * @param dt3dt1 Optional output derivative of tvec3 with regard to tvec1
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 dr3dr2:(Mat*)dr3dr2 dr3dt2:(Mat*)dr3dt2 dt3dr1:(Mat*)dt3dr1 dt3dt1:(Mat*)dt3dt1 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:dr3dr2:dr3dt2:dt3dr1:dt3dt1:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 * @param dr3dr2 Optional output derivative of rvec3 with regard to rvec2
 * @param dr3dt2 Optional output derivative of rvec3 with regard to tvec2
 * @param dt3dr1 Optional output derivative of tvec3 with regard to rvec1
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 dr3dr2:(Mat*)dr3dr2 dr3dt2:(Mat*)dr3dt2 dt3dr1:(Mat*)dt3dr1 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:dr3dr2:dr3dt2:dt3dr1:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 * @param dr3dr2 Optional output derivative of rvec3 with regard to rvec2
 * @param dr3dt2 Optional output derivative of rvec3 with regard to tvec2
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 dr3dr2:(Mat*)dr3dr2 dr3dt2:(Mat*)dr3dt2 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:dr3dr2:dr3dt2:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 * @param dr3dr2 Optional output derivative of rvec3 with regard to rvec2
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 dr3dr2:(Mat*)dr3dr2 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:dr3dr2:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 * @param dr3dt1 Optional output derivative of rvec3 with regard to tvec1
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 dr3dt1:(Mat*)dr3dt1 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:dr3dt1:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 * @param dr3dr1 Optional output derivative of rvec3 with regard to rvec1
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 dr3dr1:(Mat*)dr3dr1 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:dr3dr1:));

/**
 * Combines two rotation-and-shift transformations.
 *
 * @param rvec1 First rotation vector.
 * @param tvec1 First translation vector.
 * @param rvec2 Second rotation vector.
 * @param tvec2 Second translation vector.
 * @param rvec3 Output rotation vector of the superposition.
 * @param tvec3 Output translation vector of the superposition.
 *
 * The functions compute:
 *
 * `$$\begin{array}{l} \texttt{rvec3} =  \mathrm{rodrigues} ^{-1} \left ( \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \mathrm{rodrigues} ( \texttt{rvec1} ) \right )  \\ \texttt{tvec3} =  \mathrm{rodrigues} ( \texttt{rvec2} )  \cdot \texttt{tvec1} +  \texttt{tvec2} \end{array} ,$$`
 *
 * where `$$\mathrm{rodrigues}$$` denotes a rotation vector to a rotation matrix transformation, and
 * `$$\mathrm{rodrigues}^{-1}$$` denotes the inverse transformation. See ``Geometry/Rodrigues`` for details.
 *
 * Also, the functions can compute the derivatives of the output vectors with regards to the input
 * vectors (see ``Geometry/matMulDeriv`` ). The functions are used inside #stereoCalibrate but can also be used in
 * your own code where Levenberg-Marquardt or another gradient-based solver is used to optimize a
 * function that contains a matrix multiplication.
 */
+ (void)composeRT:(Mat*)rvec1 tvec1:(Mat*)tvec1 rvec2:(Mat*)rvec2 tvec2:(Mat*)tvec2 rvec3:(Mat*)rvec3 tvec3:(Mat*)tvec3 NS_SWIFT_NAME(composeRT(rvec1:tvec1:rvec2:tvec2:rvec3:tvec3:));


//
//  void cv::projectPoints(Mat objectPoints, Mat rvec, Mat tvec, Mat cameraMatrix, Mat distCoeffs, Mat& imagePoints, Mat& jacobian = Mat(), double aspectRatio = 0)
//
/**
 * Projects 3D points to an image plane.
 *
 * The function computes the 2D projections of 3D points to the image plane, given intrinsic and
 * extrinsic camera parameters. Optionally, the function computes Jacobians -matrices of partial
 * derivatives of image points coordinates (as functions of all the input parameters) with respect to
 * the particular parameters, intrinsic and/or extrinsic. The Jacobians are used during the global
 * optimization in *Ref:* calibrateCamera, *Ref:* solvePnP, and *Ref:* stereoCalibrate. The function itself
 * can also be used to compute a re-projection error, given the current intrinsic and extrinsic
 * parameters.
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`objectPoints`)**: 3D points in the **world coordinate frame**.
 * - **Output (`imagePoints`)**: 2D projections in **pixel coordinates** of the image plane, with distortion applied.
 *   The coordinates `$$(u, v)$$` are measured in pixels from the top-left corner of the image.
 *
 * The transformation chain is: World coordinates → Camera coordinates (via rvec/tvec) → Normalized camera coordinates
 * → Distortion applied → Pixel coordinates (via cameraMatrix).
 *
 * @param objectPoints Array of object points expressed wrt. the world coordinate frame. A 3xN/Nx3
 * 1-channel or 1xN/Nx1 3-channel (or vector\<Point3f\> ), where N is the number of points in the view.
 * @param rvec The rotation vector (*Ref:* Rodrigues) that, together with tvec, performs a change of
 * basis from world to camera coordinate system, see *Ref:* calibrateCamera for details.
 * @param tvec The translation vector, see parameter description above.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$` . If the vector is empty, the zero distortion coefficients are assumed.
 * @param imagePoints Output array of image points in **pixel coordinates**, 1xN/Nx1 2-channel, or
 * vector\<Point2f\> .
 * @param jacobian Optional output 2Nx(10+\<numDistCoeffs\>) jacobian matrix of derivatives of image
 * points with respect to components of the rotation vector, translation vector, focal lengths,
 * coordinates of the principal point and the distortion coefficients. In the old interface different
 * components of the jacobian are returned via different output parameters.
 * @param aspectRatio Optional "fixed aspect ratio" parameter. If the parameter is not 0, the
 * function assumes that the aspect ratio (`$$f_x / f_y$$`) is fixed and correspondingly adjusts the
 * jacobian matrix.
 *
 * Note:* By setting rvec = tvec = `$$[0, 0, 0]$$`, or by setting cameraMatrix to a 3x3 identity matrix,
 * or by passing zero distortion coefficients, one can get various useful partial cases of the
 * function. This means, one can compute the distorted coordinates for a sparse set of points or apply
 * a perspective transformation (and also compute the derivatives) in the ideal zero-distortion setup.
 */
+ (void)projectPoints:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints jacobian:(Mat*)jacobian aspectRatio:(double)aspectRatio NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:jacobian:aspectRatio:));

/**
 * Projects 3D points to an image plane.
 *
 * The function computes the 2D projections of 3D points to the image plane, given intrinsic and
 * extrinsic camera parameters. Optionally, the function computes Jacobians -matrices of partial
 * derivatives of image points coordinates (as functions of all the input parameters) with respect to
 * the particular parameters, intrinsic and/or extrinsic. The Jacobians are used during the global
 * optimization in *Ref:* calibrateCamera, *Ref:* solvePnP, and *Ref:* stereoCalibrate. The function itself
 * can also be used to compute a re-projection error, given the current intrinsic and extrinsic
 * parameters.
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`objectPoints`)**: 3D points in the **world coordinate frame**.
 * - **Output (`imagePoints`)**: 2D projections in **pixel coordinates** of the image plane, with distortion applied.
 *   The coordinates `$$(u, v)$$` are measured in pixels from the top-left corner of the image.
 *
 * The transformation chain is: World coordinates → Camera coordinates (via rvec/tvec) → Normalized camera coordinates
 * → Distortion applied → Pixel coordinates (via cameraMatrix).
 *
 * @param objectPoints Array of object points expressed wrt. the world coordinate frame. A 3xN/Nx3
 * 1-channel or 1xN/Nx1 3-channel (or vector\<Point3f\> ), where N is the number of points in the view.
 * @param rvec The rotation vector (*Ref:* Rodrigues) that, together with tvec, performs a change of
 * basis from world to camera coordinate system, see *Ref:* calibrateCamera for details.
 * @param tvec The translation vector, see parameter description above.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$` . If the vector is empty, the zero distortion coefficients are assumed.
 * @param imagePoints Output array of image points in **pixel coordinates**, 1xN/Nx1 2-channel, or
 * vector\<Point2f\> .
 * @param jacobian Optional output 2Nx(10+\<numDistCoeffs\>) jacobian matrix of derivatives of image
 * points with respect to components of the rotation vector, translation vector, focal lengths,
 * coordinates of the principal point and the distortion coefficients. In the old interface different
 * components of the jacobian are returned via different output parameters.
 * function assumes that the aspect ratio (`$$f_x / f_y$$`) is fixed and correspondingly adjusts the
 * jacobian matrix.
 *
 * Note:* By setting rvec = tvec = `$$[0, 0, 0]$$`, or by setting cameraMatrix to a 3x3 identity matrix,
 * or by passing zero distortion coefficients, one can get various useful partial cases of the
 * function. This means, one can compute the distorted coordinates for a sparse set of points or apply
 * a perspective transformation (and also compute the derivatives) in the ideal zero-distortion setup.
 */
+ (void)projectPoints:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints jacobian:(Mat*)jacobian NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:jacobian:));

/**
 * Projects 3D points to an image plane.
 *
 * The function computes the 2D projections of 3D points to the image plane, given intrinsic and
 * extrinsic camera parameters. Optionally, the function computes Jacobians -matrices of partial
 * derivatives of image points coordinates (as functions of all the input parameters) with respect to
 * the particular parameters, intrinsic and/or extrinsic. The Jacobians are used during the global
 * optimization in *Ref:* calibrateCamera, *Ref:* solvePnP, and *Ref:* stereoCalibrate. The function itself
 * can also be used to compute a re-projection error, given the current intrinsic and extrinsic
 * parameters.
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`objectPoints`)**: 3D points in the **world coordinate frame**.
 * - **Output (`imagePoints`)**: 2D projections in **pixel coordinates** of the image plane, with distortion applied.
 *   The coordinates `$$(u, v)$$` are measured in pixels from the top-left corner of the image.
 *
 * The transformation chain is: World coordinates → Camera coordinates (via rvec/tvec) → Normalized camera coordinates
 * → Distortion applied → Pixel coordinates (via cameraMatrix).
 *
 * @param objectPoints Array of object points expressed wrt. the world coordinate frame. A 3xN/Nx3
 * 1-channel or 1xN/Nx1 3-channel (or vector\<Point3f\> ), where N is the number of points in the view.
 * @param rvec The rotation vector (*Ref:* Rodrigues) that, together with tvec, performs a change of
 * basis from world to camera coordinate system, see *Ref:* calibrateCamera for details.
 * @param tvec The translation vector, see parameter description above.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$` . If the vector is empty, the zero distortion coefficients are assumed.
 * @param imagePoints Output array of image points in **pixel coordinates**, 1xN/Nx1 2-channel, or
 * vector\<Point2f\> .
 * points with respect to components of the rotation vector, translation vector, focal lengths,
 * coordinates of the principal point and the distortion coefficients. In the old interface different
 * components of the jacobian are returned via different output parameters.
 * function assumes that the aspect ratio (`$$f_x / f_y$$`) is fixed and correspondingly adjusts the
 * jacobian matrix.
 *
 * Note:* By setting rvec = tvec = `$$[0, 0, 0]$$`, or by setting cameraMatrix to a 3x3 identity matrix,
 * or by passing zero distortion coefficients, one can get various useful partial cases of the
 * function. This means, one can compute the distorted coordinates for a sparse set of points or apply
 * a perspective transformation (and also compute the derivatives) in the ideal zero-distortion setup.
 */
+ (void)projectPoints:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:));


//
//  void cv::projectPoints(Mat objectPoints, Mat rvec, Mat tvec, Mat cameraMatrix, Mat distCoeffs, Mat& imagePoints, Mat& dpdr, Mat& dpdt, Mat& dpdf = Mat(), Mat& dpdc = Mat(), Mat& dpdk = Mat(), Mat& dpdo = Mat(), double aspectRatio = 0.)
//
+ (void)projectPointsSepJ:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints dpdr:(Mat*)dpdr dpdt:(Mat*)dpdt dpdf:(Mat*)dpdf dpdc:(Mat*)dpdc dpdk:(Mat*)dpdk dpdo:(Mat*)dpdo aspectRatio:(double)aspectRatio NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:dpdr:dpdt:dpdf:dpdc:dpdk:dpdo:aspectRatio:));

+ (void)projectPointsSepJ:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints dpdr:(Mat*)dpdr dpdt:(Mat*)dpdt dpdf:(Mat*)dpdf dpdc:(Mat*)dpdc dpdk:(Mat*)dpdk dpdo:(Mat*)dpdo NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:dpdr:dpdt:dpdf:dpdc:dpdk:dpdo:));

+ (void)projectPointsSepJ:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints dpdr:(Mat*)dpdr dpdt:(Mat*)dpdt dpdf:(Mat*)dpdf dpdc:(Mat*)dpdc dpdk:(Mat*)dpdk NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:dpdr:dpdt:dpdf:dpdc:dpdk:));

+ (void)projectPointsSepJ:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints dpdr:(Mat*)dpdr dpdt:(Mat*)dpdt dpdf:(Mat*)dpdf dpdc:(Mat*)dpdc NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:dpdr:dpdt:dpdf:dpdc:));

+ (void)projectPointsSepJ:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints dpdr:(Mat*)dpdr dpdt:(Mat*)dpdt dpdf:(Mat*)dpdf NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:dpdr:dpdt:dpdf:));

+ (void)projectPointsSepJ:(Mat*)objectPoints rvec:(Mat*)rvec tvec:(Mat*)tvec cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imagePoints:(Mat*)imagePoints dpdr:(Mat*)dpdr dpdt:(Mat*)dpdt NS_SWIFT_NAME(projectPoints(objectPoints:rvec:tvec:cameraMatrix:distCoeffs:imagePoints:dpdr:dpdt:));


//
//  bool cv::solvePnP(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, bool useExtrinsicGuess = false, int flags = SOLVEPNP_ITERATIVE)
//
/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences:
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 *
 * More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge. The function returns true if some solution is found. User code is responsible for
 *        solution quality assessment.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *     -  With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (BOOL)solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags NS_SWIFT_NAME(solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:flags:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences:
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 *
 * More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge. The function returns true if some solution is found. User code is responsible for
 *        solution quality assessment.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *     -  With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (BOOL)solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess NS_SWIFT_NAME(solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences:
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 *
 * More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge. The function returns true if some solution is found. User code is responsible for
 *        solution quality assessment.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *     -  With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (BOOL)solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:));


//
//  bool cv::solvePnPRansac(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, bool useExtrinsicGuess = false, int iterationsCount = 100, float reprojectionError = 8.0, double confidence = 0.99, Mat& inliers = Mat(), int flags = SOLVEPNP_ITERATIVE)
//
/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for *Ref:* SOLVEPNP_ITERATIVE. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 * @param inliers Output vector that contains indices of inliers in objectPoints and imagePoints .
 * @param flags Method for solving a PnP problem (see *Ref:* solvePnP ).
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence inliers:(Mat*)inliers flags:(int)flags NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:inliers:flags:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for *Ref:* SOLVEPNP_ITERATIVE. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 * @param inliers Output vector that contains indices of inliers in objectPoints and imagePoints .
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence inliers:(Mat*)inliers NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:inliers:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for *Ref:* SOLVEPNP_ITERATIVE. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for *Ref:* SOLVEPNP_ITERATIVE. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for *Ref:* SOLVEPNP_ITERATIVE. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for *Ref:* SOLVEPNP_ITERATIVE. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences using the RANSAC scheme to deal with bad matches.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 *
 * The function estimates an object pose given a set of object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients. This function finds such
 * a pose that minimizes reprojection error, that is, the sum of squared distances between the observed
 * projections imagePoints and the projected (using *Ref:* projectPoints ) objectPoints. The use of RANSAC
 * makes the function resistant to outliers.
 *
 * Note:*
 *    -   An example of how to use solvePnPRansac for object detection can be found at
 * Ref:* tutorial_real_time_pose
 *    -   The default method used to estimate the camera pose for the Minimal Sample Sets step
 *        is ``SolvePnPMethod/SOLVEPNP_EPNP``. Exceptions are:
 *          - if you choose ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``, these methods will be used.
 *          - if the number of input points is equal to 4, ``SolvePnPMethod/SOLVEPNP_P3P`` is used.
 *    -   The method used to estimate the camera pose using all the inliers is defined by the
 *        flags parameters unless it is equal to ``SolvePnPMethod/SOLVEPNP_P3P`` or ``SolvePnPMethod/SOLVEPNP_AP3P``. In this case,
 *        the method ``SolvePnPMethod/SOLVEPNP_EPNP`` will be used instead.
 */
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:));


//
//  bool cv::solvePnPRansac(Mat objectPoints, Mat imagePoints, Mat& cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, Mat& inliers, UsacParams params = UsacParams())
//
+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec inliers:(Mat*)inliers params:(UsacParams*)params NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:inliers:params:));

+ (BOOL)solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec inliers:(Mat*)inliers NS_SWIFT_NAME(solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:inliers:));


//
//  int cv::solveP3P(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, vector_Mat& rvecs, vector_Mat& tvecs, int flags)
//
/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from **3** 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, 3x3 1-channel or
 * 1x3/3x1 3-channel. vector\<Point3f\> can be also passed here.
 * @param imagePoints Array of corresponding image points, 3x2 1-channel or 1x3/3x1 2-channel.
 *  vector\<Point2f\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system. A P3P problem has up to 4 solutions.
 * @param tvecs Output translation vectors.
 * @param flags Method for solving a P3P problem:
 * -   *Ref:* SOLVEPNP_P3P Method is based on the paper of Ding, Y., Yang, J., Larsson, V., Olsson, C., & Åstrom, K.
 * "Revisiting the P3P Problem" (*Cite:* ding2023revisiting).
 * -   *Ref:* SOLVEPNP_AP3P Method is based on the paper of T. Ke and S. Roumeliotis.
 * "An Efficient Algebraic Solution to the Perspective-Three-Point Problem" (*Cite:* Ke17).
 *
 * The function estimates the object pose given 3 object points, their corresponding image
 * projections, as well as the camera intrinsic matrix and the distortion coefficients.
 *
 * Note:*
 * The solutions are sorted by reprojection errors (lowest to highest).
 */
+ (int)solveP3P:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs flags:(int)flags NS_SWIFT_NAME(solveP3P(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:flags:));


//
//  void cv::solvePnPRefineLM(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, TermCriteria criteria = TermCriteria(TermCriteria::EPS + TermCriteria::COUNT, 20, FLT_EPSILON))
//
/**
 * Refine a pose (the translation and the rotation that transform a 3D point expressed in the object coordinate frame
 * to the camera coordinate frame) from a 3D-2D point correspondences and starting from an initial solution.
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or 1xN/Nx1 3-channel,
 * where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Input/Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system. Input values are used as an initial solution.
 * @param tvec Input/Output translation vector. Input values are used as an initial solution.
 * @param criteria Criteria when to stop the Levenberg-Marquard iterative algorithm.
 *
 * The function refines the object pose given at least 3 object points, their corresponding image
 * projections, an initial solution for the rotation and translation vector,
 * as well as the camera intrinsic matrix and the distortion coefficients.
 * The function minimizes the projection error with respect to the rotation and the translation vectors, according
 * to a Levenberg-Marquardt iterative minimization *Cite:* Madsen04 *Cite:* Eade13 process.
 */
+ (void)solvePnPRefineLM:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec criteria:(TermCriteria*)criteria NS_SWIFT_NAME(solvePnPRefineLM(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:criteria:));

/**
 * Refine a pose (the translation and the rotation that transform a 3D point expressed in the object coordinate frame
 * to the camera coordinate frame) from a 3D-2D point correspondences and starting from an initial solution.
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or 1xN/Nx1 3-channel,
 * where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Input/Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system. Input values are used as an initial solution.
 * @param tvec Input/Output translation vector. Input values are used as an initial solution.
 *
 * The function refines the object pose given at least 3 object points, their corresponding image
 * projections, an initial solution for the rotation and translation vector,
 * as well as the camera intrinsic matrix and the distortion coefficients.
 * The function minimizes the projection error with respect to the rotation and the translation vectors, according
 * to a Levenberg-Marquardt iterative minimization *Cite:* Madsen04 *Cite:* Eade13 process.
 */
+ (void)solvePnPRefineLM:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(solvePnPRefineLM(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:));


//
//  void cv::solvePnPRefineVVS(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, TermCriteria criteria = TermCriteria(TermCriteria::EPS + TermCriteria::COUNT, 20, FLT_EPSILON), double VVSlambda = 1)
//
/**
 * Refine a pose (the translation and the rotation that transform a 3D point expressed in the object coordinate frame
 * to the camera coordinate frame) from a 3D-2D point correspondences and starting from an initial solution.
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or 1xN/Nx1 3-channel,
 * where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Input/Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system. Input values are used as an initial solution.
 * @param tvec Input/Output translation vector. Input values are used as an initial solution.
 * @param criteria Criteria when to stop the Levenberg-Marquard iterative algorithm.
 * @param VVSlambda Gain for the virtual visual servoing control law, equivalent to the `$$\alpha$$`
 * gain in the Damped Gauss-Newton formulation.
 *
 * The function refines the object pose given at least 3 object points, their corresponding image
 * projections, an initial solution for the rotation and translation vector,
 * as well as the camera intrinsic matrix and the distortion coefficients.
 * The function minimizes the projection error with respect to the rotation and the translation vectors, using a
 * virtual visual servoing (VVS) *Cite:* Chaumette06 *Cite:* Marchand16 scheme.
 */
+ (void)solvePnPRefineVVS:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec criteria:(TermCriteria*)criteria VVSlambda:(double)VVSlambda NS_SWIFT_NAME(solvePnPRefineVVS(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:criteria:VVSlambda:));

/**
 * Refine a pose (the translation and the rotation that transform a 3D point expressed in the object coordinate frame
 * to the camera coordinate frame) from a 3D-2D point correspondences and starting from an initial solution.
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or 1xN/Nx1 3-channel,
 * where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Input/Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system. Input values are used as an initial solution.
 * @param tvec Input/Output translation vector. Input values are used as an initial solution.
 * @param criteria Criteria when to stop the Levenberg-Marquard iterative algorithm.
 * gain in the Damped Gauss-Newton formulation.
 *
 * The function refines the object pose given at least 3 object points, their corresponding image
 * projections, an initial solution for the rotation and translation vector,
 * as well as the camera intrinsic matrix and the distortion coefficients.
 * The function minimizes the projection error with respect to the rotation and the translation vectors, using a
 * virtual visual servoing (VVS) *Cite:* Chaumette06 *Cite:* Marchand16 scheme.
 */
+ (void)solvePnPRefineVVS:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec criteria:(TermCriteria*)criteria NS_SWIFT_NAME(solvePnPRefineVVS(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:criteria:));

/**
 * Refine a pose (the translation and the rotation that transform a 3D point expressed in the object coordinate frame
 * to the camera coordinate frame) from a 3D-2D point correspondences and starting from an initial solution.
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or 1xN/Nx1 3-channel,
 * where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvec Input/Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system. Input values are used as an initial solution.
 * @param tvec Input/Output translation vector. Input values are used as an initial solution.
 * gain in the Damped Gauss-Newton formulation.
 *
 * The function refines the object pose given at least 3 object points, their corresponding image
 * projections, an initial solution for the rotation and translation vector,
 * as well as the camera intrinsic matrix and the distortion coefficients.
 * The function minimizes the projection error with respect to the rotation and the translation vectors, using a
 * virtual visual servoing (VVS) *Cite:* Chaumette06 *Cite:* Marchand16 scheme.
 */
+ (void)solvePnPRefineVVS:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(solvePnPRefineVVS(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:));


//
//  int cv::solvePnPGeneric(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, vector_Mat& rvecs, vector_Mat& tvecs, bool useExtrinsicGuess = false, int flags = SOLVEPNP_ITERATIVE, Mat rvec = Mat(), Mat tvec = Mat(), Mat& reprojectionError = Mat())
//
/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns a list of all the possible solutions (a solution is a <rotation vector, translation vector>
 * couple), depending on the number of input points and the chosen method:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): 3 or 4 input points. Number of returned solutions can be between 0 and 4 with 3 input points.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar. Returns 2 solutions.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4 and 2 solutions are returned. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * Only 1 solution is returned.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Vector of output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvecs Vector of output translation vectors.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * @param rvec Rotation vector used to initialize an iterative PnP refinement algorithm, when flag is *Ref:* SOLVEPNP_ITERATIVE
 * and useExtrinsicGuess is set to true.
 * @param tvec Translation vector used to initialize an iterative PnP refinement algorithm, when flag is *Ref:* SOLVEPNP_ITERATIVE
 * and useExtrinsicGuess is set to true.
 * @param reprojectionError Optional vector of reprojection error, that is the RMS error
 * (`$$ \text{RMSE} = \sqrt{\frac{\sum_{i}^{N} \left ( \hat{y_i} - y_i \right )^2}{N}} $$`) between the input image points
 * and the 3D object points projected with the estimated pose.
 *
 * More information is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *    -   With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (int)solvePnPGeneric:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags rvec:(Mat*)rvec tvec:(Mat*)tvec reprojectionError:(Mat*)reprojectionError NS_SWIFT_NAME(solvePnPGeneric(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:useExtrinsicGuess:flags:rvec:tvec:reprojectionError:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns a list of all the possible solutions (a solution is a <rotation vector, translation vector>
 * couple), depending on the number of input points and the chosen method:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): 3 or 4 input points. Number of returned solutions can be between 0 and 4 with 3 input points.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar. Returns 2 solutions.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4 and 2 solutions are returned. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * Only 1 solution is returned.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Vector of output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvecs Vector of output translation vectors.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * @param rvec Rotation vector used to initialize an iterative PnP refinement algorithm, when flag is *Ref:* SOLVEPNP_ITERATIVE
 * and useExtrinsicGuess is set to true.
 * @param tvec Translation vector used to initialize an iterative PnP refinement algorithm, when flag is *Ref:* SOLVEPNP_ITERATIVE
 * and useExtrinsicGuess is set to true.
 * (`$$ \text{RMSE} = \sqrt{\frac{\sum_{i}^{N} \left ( \hat{y_i} - y_i \right )^2}{N}} $$`) between the input image points
 * and the 3D object points projected with the estimated pose.
 *
 * More information is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *    -   With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (int)solvePnPGeneric:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(solvePnPGeneric(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:useExtrinsicGuess:flags:rvec:tvec:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns a list of all the possible solutions (a solution is a <rotation vector, translation vector>
 * couple), depending on the number of input points and the chosen method:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): 3 or 4 input points. Number of returned solutions can be between 0 and 4 with 3 input points.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar. Returns 2 solutions.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4 and 2 solutions are returned. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * Only 1 solution is returned.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Vector of output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvecs Vector of output translation vectors.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * @param rvec Rotation vector used to initialize an iterative PnP refinement algorithm, when flag is *Ref:* SOLVEPNP_ITERATIVE
 * and useExtrinsicGuess is set to true.
 * and useExtrinsicGuess is set to true.
 * (`$$ \text{RMSE} = \sqrt{\frac{\sum_{i}^{N} \left ( \hat{y_i} - y_i \right )^2}{N}} $$`) between the input image points
 * and the 3D object points projected with the estimated pose.
 *
 * More information is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *    -   With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (int)solvePnPGeneric:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags rvec:(Mat*)rvec NS_SWIFT_NAME(solvePnPGeneric(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:useExtrinsicGuess:flags:rvec:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns a list of all the possible solutions (a solution is a <rotation vector, translation vector>
 * couple), depending on the number of input points and the chosen method:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): 3 or 4 input points. Number of returned solutions can be between 0 and 4 with 3 input points.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar. Returns 2 solutions.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4 and 2 solutions are returned. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * Only 1 solution is returned.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Vector of output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvecs Vector of output translation vectors.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * and useExtrinsicGuess is set to true.
 * and useExtrinsicGuess is set to true.
 * (`$$ \text{RMSE} = \sqrt{\frac{\sum_{i}^{N} \left ( \hat{y_i} - y_i \right )^2}{N}} $$`) between the input image points
 * and the 3D object points projected with the estimated pose.
 *
 * More information is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *    -   With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (int)solvePnPGeneric:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags NS_SWIFT_NAME(solvePnPGeneric(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:useExtrinsicGuess:flags:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns a list of all the possible solutions (a solution is a <rotation vector, translation vector>
 * couple), depending on the number of input points and the chosen method:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): 3 or 4 input points. Number of returned solutions can be between 0 and 4 with 3 input points.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar. Returns 2 solutions.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4 and 2 solutions are returned. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * Only 1 solution is returned.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Vector of output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvecs Vector of output translation vectors.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * and useExtrinsicGuess is set to true.
 * and useExtrinsicGuess is set to true.
 * (`$$ \text{RMSE} = \sqrt{\frac{\sum_{i}^{N} \left ( \hat{y_i} - y_i \right )^2}{N}} $$`) between the input image points
 * and the 3D object points projected with the estimated pose.
 *
 * More information is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *    -   With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (int)solvePnPGeneric:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs useExtrinsicGuess:(BOOL)useExtrinsicGuess NS_SWIFT_NAME(solvePnPGeneric(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:useExtrinsicGuess:));

/**
 * Finds an object pose `$$ {}^{c}\mathbf{T}_o $$` from 3D-2D point correspondences.
 *
 * ![Perspective projection, from object to camera frame](pinhole_homogeneous_transformation){ width=50% }
 *
 * - SeeAlso *Ref:* calib3d_solvePnP
 *
 * This function returns a list of all the possible solutions (a solution is a <rotation vector, translation vector>
 * couple), depending on the number of input points and the chosen method:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): 3 or 4 input points. Number of returned solutions can be between 0 and 4 with 3 input points.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar. Returns 2 solutions.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4 and 2 solutions are returned. Object points must be defined in the following order:
 *   - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *   - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *   - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *   - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * Only 1 solution is returned.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param rvecs Vector of output rotation vectors (see *Ref:* Rodrigues ) that, together with tvecs, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvecs Vector of output translation vectors.
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * and useExtrinsicGuess is set to true.
 * and useExtrinsicGuess is set to true.
 * (`$$ \text{RMSE} = \sqrt{\frac{\sum_{i}^{N} \left ( \hat{y_i} - y_i \right )^2}{N}} $$`) between the input image points
 * and the 3D object points projected with the estimated pose.
 *
 * More information is described in *Ref:* calib3d_solvePnP
 *
 * Note:*
 *    -   An example of how to use solvePnP for planar augmented reality can be found at
 *         opencv_source_code/samples/python/plane_ar.py
 *    -   If you are using Python:
 *         - Numpy array slices won't work as input because solvePnP requires contiguous
 *         arrays (enforced by the assertion using cv::Mat::checkVector() around line 55 of
 *         modules/3d/src/solvepnp.cpp version 2.4.9)
 *         - The P3P algorithm requires image points to be in an array of shape (N,1,2) due
 *         to its calling of ``Geometry/undistortPoints`` (around line 75 of modules/3d/src/solvepnp.cpp version 2.4.9)
 *         which requires 2-channel information.
 *         - Thus, given some data D = np.array(...) where D.shape = (N,M), in order to use a subset of
 *         it as, e.g., imagePoints, one must effectively copy it into a new array: imagePoints =
 *         np.ascontiguousarray(D[:,:2]).reshape((N,1,2))
 *    -   The minimum number of points is 4 in the general case. In the case of *Ref:* SOLVEPNP_P3P and *Ref:* SOLVEPNP_AP3P
 *        methods, it is required to use exactly 4 points (the first 3 points are used to estimate all the solutions
 *        of the P3P problem, the last one is used to retain the best solution that minimizes the reprojection error).
 *    -   With *Ref:* SOLVEPNP_ITERATIVE method and `useExtrinsicGuess=true`, the minimum number of points is 3 (3 points
 *        are sufficient to compute a pose but there are up to 4 solutions). The initial solution should be close to the
 *        global solution to converge.
 *    -   With *Ref:* SOLVEPNP_IPPE input points must be >= 4 and object points must be coplanar.
 *    -   With *Ref:* SOLVEPNP_IPPE_SQUARE this is a special case suitable for marker pose estimation.
 *        Number of input points must be 4. Object points must be defined in the following order:
 *          - point 0: [-squareLength / 2,  squareLength / 2, 0]
 *          - point 1: [ squareLength / 2,  squareLength / 2, 0]
 *          - point 2: [ squareLength / 2, -squareLength / 2, 0]
 *          - point 3: [-squareLength / 2, -squareLength / 2, 0]
 *    -   With *Ref:* SOLVEPNP_SQPNP input points must be >= 3
 */
+ (int)solvePnPGeneric:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvecs:(NSMutableArray<Mat*>*)rvecs tvecs:(NSMutableArray<Mat*>*)tvecs NS_SWIFT_NAME(solvePnPGeneric(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvecs:tvecs:));


//
//  void cv::convertPointsToHomogeneous(Mat src, Mat& dst, int dtype = -1)
//
/**
 * Converts points from Euclidean to homogeneous space.
 *
 * @param src Input vector of N-dimensional points.
 * @param dst Output vector of N+1-dimensional points.
 * @param dtype The desired output array depth (either CV_32F or CV_64F are currently supported).
 *     If it's -1, then it's set automatically to CV_32F or CV_64F, depending on the input depth.
 *
 * The function converts points from Euclidean to homogeneous space by appending 1's to the tuple of
 * point coordinates. That is, each point (x1, x2, ..., xn) is converted to (x1, x2, ..., xn, 1).
 */
+ (void)convertPointsToHomogeneous:(Mat*)src dst:(Mat*)dst dtype:(int)dtype NS_SWIFT_NAME(convertPointsToHomogeneous(src:dst:dtype:));

/**
 * Converts points from Euclidean to homogeneous space.
 *
 * @param src Input vector of N-dimensional points.
 * @param dst Output vector of N+1-dimensional points.
 *     If it's -1, then it's set automatically to CV_32F or CV_64F, depending on the input depth.
 *
 * The function converts points from Euclidean to homogeneous space by appending 1's to the tuple of
 * point coordinates. That is, each point (x1, x2, ..., xn) is converted to (x1, x2, ..., xn, 1).
 */
+ (void)convertPointsToHomogeneous:(Mat*)src dst:(Mat*)dst NS_SWIFT_NAME(convertPointsToHomogeneous(src:dst:));


//
//  void cv::convertPointsFromHomogeneous(Mat src, Mat& dst, int dtype = -1)
//
/**
 * Converts points from homogeneous to Euclidean space.
 *
 * @param src Input vector of N-dimensional points.
 * @param dst Output vector of N-1-dimensional points.
 * @param dtype The desired output array depth (either CV_32F or CV_64F are currently supported).
 *     If it's -1, then it's set automatically to CV_32F or CV_64F, depending on the input depth.
 *
 * The function converts points homogeneous to Euclidean space using perspective projection. That is,
 * each point (x1, x2, ... x(n-1), xn) is converted to (x1/xn, x2/xn, ..., x(n-1)/xn). When xn=0, the
 * output point coordinates will be (0,0,0,...).
 */
+ (void)convertPointsFromHomogeneous:(Mat*)src dst:(Mat*)dst dtype:(int)dtype NS_SWIFT_NAME(convertPointsFromHomogeneous(src:dst:dtype:));

/**
 * Converts points from homogeneous to Euclidean space.
 *
 * @param src Input vector of N-dimensional points.
 * @param dst Output vector of N-1-dimensional points.
 *     If it's -1, then it's set automatically to CV_32F or CV_64F, depending on the input depth.
 *
 * The function converts points homogeneous to Euclidean space using perspective projection. That is,
 * each point (x1, x2, ... x(n-1), xn) is converted to (x1/xn, x2/xn, ..., x(n-1)/xn). When xn=0, the
 * output point coordinates will be (0,0,0,...).
 */
+ (void)convertPointsFromHomogeneous:(Mat*)src dst:(Mat*)dst NS_SWIFT_NAME(convertPointsFromHomogeneous(src:dst:));


//
//  Mat cv::findFundamentalMat(Mat points1, Mat points2, int method, double ransacReprojThreshold, double confidence, int maxIters, Mat& mask = Mat())
//
/**
 * Calculates a fundamental matrix from the corresponding points in two images.
 *
 * @param points1 Array of N points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* FM_7POINT for a 7-point algorithm. `$$N = 7$$`
 * -   *Ref:* FM_8POINT for an 8-point algorithm. `$$N \ge 8$$`
 * -   *Ref:* FM_RANSAC for the RANSAC algorithm. `$$N \ge 8$$`
 * -   *Ref:* FM_LMEDS for the LMedS algorithm. `$$N \ge 8$$`
 * @param ransacReprojThreshold Parameter used only for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param confidence Parameter used for the RANSAC and LMedS methods only. It specifies a desirable level
 * of confidence (probability) that the estimated matrix is correct.
 * @param mask optional output mask
 * @param maxIters The maximum number of robust method iterations.
 *
 * The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T F [p_1; 1] = 0$$`
 *
 * where `$$F$$` is a fundamental matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively.
 *
 * The function calculates the fundamental matrix using one of four methods listed above and returns
 * the found fundamental matrix. Normally just one matrix is found. But in case of the 7-point
 * algorithm, the function may return up to 3 solutions ( `$$9 \times 3$$` matrix that stores all 3
 * matrices sequentially).
 *
 * The calculated fundamental matrix may be passed further to ``Geometry/computeCorrespondEpilines`` that finds the
 * epipolar lines corresponding to the specified points. It can also be passed to
 * #stereoRectifyUncalibrated to compute the rectification transformation. :
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     Mat fundamental_matrix =
 *      findFundamentalMat(points1, points2, FM_RANSAC, 3, 0.99);
 *
 */
+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold confidence:(double)confidence maxIters:(int)maxIters mask:(Mat*)mask NS_SWIFT_NAME(findFundamentalMat(points1:points2:method:ransacReprojThreshold:confidence:maxIters:mask:));

/**
 * Calculates a fundamental matrix from the corresponding points in two images.
 *
 * @param points1 Array of N points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* FM_7POINT for a 7-point algorithm. `$$N = 7$$`
 * -   *Ref:* FM_8POINT for an 8-point algorithm. `$$N \ge 8$$`
 * -   *Ref:* FM_RANSAC for the RANSAC algorithm. `$$N \ge 8$$`
 * -   *Ref:* FM_LMEDS for the LMedS algorithm. `$$N \ge 8$$`
 * @param ransacReprojThreshold Parameter used only for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param confidence Parameter used for the RANSAC and LMedS methods only. It specifies a desirable level
 * of confidence (probability) that the estimated matrix is correct.
 * @param maxIters The maximum number of robust method iterations.
 *
 * The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T F [p_1; 1] = 0$$`
 *
 * where `$$F$$` is a fundamental matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively.
 *
 * The function calculates the fundamental matrix using one of four methods listed above and returns
 * the found fundamental matrix. Normally just one matrix is found. But in case of the 7-point
 * algorithm, the function may return up to 3 solutions ( `$$9 \times 3$$` matrix that stores all 3
 * matrices sequentially).
 *
 * The calculated fundamental matrix may be passed further to ``Geometry/computeCorrespondEpilines`` that finds the
 * epipolar lines corresponding to the specified points. It can also be passed to
 * #stereoRectifyUncalibrated to compute the rectification transformation. :
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     Mat fundamental_matrix =
 *      findFundamentalMat(points1, points2, FM_RANSAC, 3, 0.99);
 *
 */
+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold confidence:(double)confidence maxIters:(int)maxIters NS_SWIFT_NAME(findFundamentalMat(points1:points2:method:ransacReprojThreshold:confidence:maxIters:));


//
//  Mat cv::findFundamentalMat(Mat points1, Mat points2, int method = FM_RANSAC, double ransacReprojThreshold = 3., double confidence = 0.99, Mat& mask = Mat())
//
+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold confidence:(double)confidence mask:(Mat*)mask NS_SWIFT_NAME(findFundamentalMat(points1:points2:method:ransacReprojThreshold:confidence:mask:));

+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold confidence:(double)confidence NS_SWIFT_NAME(findFundamentalMat(points1:points2:method:ransacReprojThreshold:confidence:));

+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold NS_SWIFT_NAME(findFundamentalMat(points1:points2:method:ransacReprojThreshold:));

+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 method:(int)method NS_SWIFT_NAME(findFundamentalMat(points1:points2:method:));

+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 NS_SWIFT_NAME(findFundamentalMat(points1:points2:));


//
//  Mat cv::findFundamentalMat(Mat points1, Mat points2, Mat& mask, UsacParams params)
//
+ (Mat*)findFundamentalMat:(Mat*)points1 points2:(Mat*)points2 mask:(Mat*)mask params:(UsacParams*)params NS_SWIFT_NAME(findFundamentalMat(points1:points2:mask:params:));


//
//  Mat cv::findEssentialMat(Mat points1, Mat points2, Mat cameraMatrix, int method = RANSAC, double prob = 0.999, double threshold = 1.0, int maxIters = 1000, Mat& mask = Mat())
//
/**
 * Calculates an essential matrix from the corresponding points in two images.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix. If this assumption does not hold for your use case, use another
 * function overload or ``Geometry/undistortPoints`` with `P = cv::NoArray()` for both cameras to transform image
 * points to normalized image coordinates, which are valid for the identity camera intrinsic matrix.
 * When passing these coordinates, pass the identity matrix for this parameter.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param mask Output array of N elements, every element of which is set to 0 for outliers and to 1
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 * @param maxIters The maximum number of robust method iterations.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix method:(int)method prob:(double)prob threshold:(double)threshold maxIters:(int)maxIters mask:(Mat*)mask NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix:method:prob:threshold:maxIters:mask:));

/**
 * Calculates an essential matrix from the corresponding points in two images.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix. If this assumption does not hold for your use case, use another
 * function overload or ``Geometry/undistortPoints`` with `P = cv::NoArray()` for both cameras to transform image
 * points to normalized image coordinates, which are valid for the identity camera intrinsic matrix.
 * When passing these coordinates, pass the identity matrix for this parameter.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 * @param maxIters The maximum number of robust method iterations.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix method:(int)method prob:(double)prob threshold:(double)threshold maxIters:(int)maxIters NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix:method:prob:threshold:maxIters:));

/**
 * Calculates an essential matrix from the corresponding points in two images.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix. If this assumption does not hold for your use case, use another
 * function overload or ``Geometry/undistortPoints`` with `P = cv::NoArray()` for both cameras to transform image
 * points to normalized image coordinates, which are valid for the identity camera intrinsic matrix.
 * When passing these coordinates, pass the identity matrix for this parameter.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix method:(int)method prob:(double)prob threshold:(double)threshold NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix:method:prob:threshold:));

/**
 * Calculates an essential matrix from the corresponding points in two images.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix. If this assumption does not hold for your use case, use another
 * function overload or ``Geometry/undistortPoints`` with `P = cv::NoArray()` for both cameras to transform image
 * points to normalized image coordinates, which are valid for the identity camera intrinsic matrix.
 * When passing these coordinates, pass the identity matrix for this parameter.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix method:(int)method prob:(double)prob NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix:method:prob:));

/**
 * Calculates an essential matrix from the corresponding points in two images.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix. If this assumption does not hold for your use case, use another
 * function overload or ``Geometry/undistortPoints`` with `P = cv::NoArray()` for both cameras to transform image
 * points to normalized image coordinates, which are valid for the identity camera intrinsic matrix.
 * When passing these coordinates, pass the identity matrix for this parameter.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix method:(int)method NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix:method:));

/**
 * Calculates an essential matrix from the corresponding points in two images.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix. If this assumption does not hold for your use case, use another
 * function overload or ``Geometry/undistortPoints`` with `P = cv::NoArray()` for both cameras to transform image
 * points to normalized image coordinates, which are valid for the identity camera intrinsic matrix.
 * When passing these coordinates, pass the identity matrix for this parameter.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix:));


//
//  Mat cv::findEssentialMat(Mat points1, Mat points2, double focal = 1.0, Point2d pp = Point2d(0, 0), int method = RANSAC, double prob = 0.999, double threshold = 1.0, int maxIters = 1000, Mat& mask = Mat())
//
/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param mask Output array of N elements, every element of which is set to 0 for outliers and to 1
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 * @param maxIters The maximum number of robust method iterations.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal pp:(Point2d*)pp method:(int)method prob:(double)prob threshold:(double)threshold maxIters:(int)maxIters mask:(Mat*)mask NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:pp:method:prob:threshold:maxIters:mask:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 * @param maxIters The maximum number of robust method iterations.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal pp:(Point2d*)pp method:(int)method prob:(double)prob threshold:(double)threshold maxIters:(int)maxIters NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:pp:method:prob:threshold:maxIters:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal pp:(Point2d*)pp method:(int)method prob:(double)prob threshold:(double)threshold NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:pp:method:prob:threshold:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal pp:(Point2d*)pp method:(int)method prob:(double)prob NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:pp:method:prob:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * @param method Method for computing a fundamental matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal pp:(Point2d*)pp method:(int)method NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:pp:method:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal pp:(Point2d*)pp NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:pp:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param focal focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 focal:(double)focal NS_SWIFT_NAME(findEssentialMat(points1:points2:focal:));

/**
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * are feature points from cameras with same focal length and principal point.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * confidence (probability) that the estimated matrix is correct.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 NS_SWIFT_NAME(findEssentialMat(points1:points2:));


//
//  Mat cv::findEssentialMat(Mat points1, Mat points2, Mat cameraMatrix1, Mat distCoeffs1, Mat cameraMatrix2, Mat distCoeffs2, int method = RANSAC, double prob = 0.999, double threshold = 1.0, Mat& mask = Mat())
//
/**
 * Calculates an essential matrix from the corresponding points in two images from potentially two different cameras.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix1 Camera matrix for the first camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param cameraMatrix2 Camera matrix for the second camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs1 Input vector of distortion coefficients for the first camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param distCoeffs2 Input vector of distortion coefficients for the second camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param mask Output array of N elements, every element of which is set to 0 for outliers and to 1
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or  ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 method:(int)method prob:(double)prob threshold:(double)threshold mask:(Mat*)mask NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:method:prob:threshold:mask:));

/**
 * Calculates an essential matrix from the corresponding points in two images from potentially two different cameras.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix1 Camera matrix for the first camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param cameraMatrix2 Camera matrix for the second camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs1 Input vector of distortion coefficients for the first camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param distCoeffs2 Input vector of distortion coefficients for the second camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or  ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 method:(int)method prob:(double)prob threshold:(double)threshold NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:method:prob:threshold:));

/**
 * Calculates an essential matrix from the corresponding points in two images from potentially two different cameras.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix1 Camera matrix for the first camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param cameraMatrix2 Camera matrix for the second camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs1 Input vector of distortion coefficients for the first camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param distCoeffs2 Input vector of distortion coefficients for the second camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or  ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 method:(int)method prob:(double)prob NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:method:prob:));

/**
 * Calculates an essential matrix from the corresponding points in two images from potentially two different cameras.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix1 Camera matrix for the first camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param cameraMatrix2 Camera matrix for the second camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs1 Input vector of distortion coefficients for the first camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param distCoeffs2 Input vector of distortion coefficients for the second camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or  ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 method:(int)method NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:method:));

/**
 * Calculates an essential matrix from the corresponding points in two images from potentially two different cameras.
 *
 * @param points1 Array of N (N \>= 5) 2D points from the first image. The point coordinates should
 * be floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix1 Camera matrix for the first camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param cameraMatrix2 Camera matrix for the second camera `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } K = \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs1 Input vector of distortion coefficients for the first camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param distCoeffs2 Input vector of distortion coefficients for the second camera
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * for the other points. The array is computed only in the RANSAC and LMedS methods.
 *
 * This function estimates essential matrix based on the five-point algorithm solver in *Cite:* Nister03 .
 * Cite:* SteweniusCFS is also a related. The epipolar geometry is described by the following equation:
 *
 * `$$[p_2; 1]^T K^{-T} E K^{-1} [p_1; 1] = 0$$`
 *
 * where `$$E$$` is an essential matrix, `$$p_1$$` and `$$p_2$$` are corresponding points in the first and the
 * second images, respectively. The result of this function may be passed further to
 * ``Geometry/decomposeEssentialMat`` or  ``Geometry/recoverPose`` to recover the relative pose between cameras.
 */
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:));


//
//  Mat cv::findEssentialMat(Mat points1, Mat points2, Mat cameraMatrix1, Mat cameraMatrix2, Mat dist_coeff1, Mat dist_coeff2, Mat& mask, UsacParams params)
//
+ (Mat*)findEssentialMat:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 cameraMatrix2:(Mat*)cameraMatrix2 dist_coeff1:(Mat*)dist_coeff1 dist_coeff2:(Mat*)dist_coeff2 mask:(Mat*)mask params:(UsacParams*)params NS_SWIFT_NAME(findEssentialMat(points1:points2:cameraMatrix1:cameraMatrix2:dist_coeff1:dist_coeff2:mask:params:));


//
//  void cv::decomposeEssentialMat(Mat E, Mat& R1, Mat& R2, Mat& t)
//
/**
 * Decompose an essential matrix to possible rotations and translation.
 *
 * @param E The input essential matrix.
 * @param R1 One possible rotation matrix.
 * @param R2 Another possible rotation matrix.
 * @param t One possible translation.
 *
 * This function decomposes the essential matrix E using svd decomposition *Cite:* HartleyZ00. In
 * general, four possible poses exist for the decomposition of E. They are `$$[R_1, t]$$`,
 * `$$[R_1, -t]$$`, `$$[R_2, t]$$`, `$$[R_2, -t]$$`.
 *
 * If E gives the epipolar constraint `$$[p_2; 1]^T A^{-T} E A^{-1} [p_1; 1] = 0$$` between the image
 * points `$$p_1$$` in the first image and `$$p_2$$` in second image, then any of the tuples
 * `$$[R_1, t]$$`, `$$[R_1, -t]$$`, `$$[R_2, t]$$`, `$$[R_2, -t]$$` is a change of basis from the first
 * camera's coordinate system to the second camera's coordinate system. However, by decomposing E, one
 * can only get the direction of the translation. For this reason, the translation t is returned with
 * unit length.
 */
+ (void)decomposeEssentialMat:(Mat*)E R1:(Mat*)R1 R2:(Mat*)R2 t:(Mat*)t NS_SWIFT_NAME(decomposeEssentialMat(E:R1:R2:t:));


//
//  int cv::recoverPose(Mat points1, Mat points2, Mat cameraMatrix1, Mat distCoeffs1, Mat cameraMatrix2, Mat distCoeffs2, Mat& E, Mat& R, Mat& t, int method = cv::RANSAC, double prob = 0.999, double threshold = 1.0, Mat& mask = Mat())
//
/**
 * Recovers the relative camera rotation and the translation from corresponding points in two images from two different cameras, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix1 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs1 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param cameraMatrix2 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs2 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param E The output essential matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * @param mask Input/output mask for inliers in points1 and points2. If it is not empty, then it marks
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for findEssentialMat.:
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // Input: camera calibration of both cameras, for example using intrinsic chessboard calibration.
 *     Mat cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2;
 *
 *     // Output: Essential matrix, relative rotation and relative translation.
 *     Mat E, R, t, mask;
 *
 *     recoverPose(points1, points2, cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, E, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 E:(Mat*)E R:(Mat*)R t:(Mat*)t method:(int)method prob:(double)prob threshold:(double)threshold mask:(Mat*)mask NS_SWIFT_NAME(recoverPose(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:E:R:t:method:prob:threshold:mask:));

/**
 * Recovers the relative camera rotation and the translation from corresponding points in two images from two different cameras, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix1 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs1 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param cameraMatrix2 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs2 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param E The output essential matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * @param threshold Parameter used for RANSAC. It is the maximum distance from a point to an epipolar
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for findEssentialMat.:
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // Input: camera calibration of both cameras, for example using intrinsic chessboard calibration.
 *     Mat cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2;
 *
 *     // Output: Essential matrix, relative rotation and relative translation.
 *     Mat E, R, t, mask;
 *
 *     recoverPose(points1, points2, cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, E, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 E:(Mat*)E R:(Mat*)R t:(Mat*)t method:(int)method prob:(double)prob threshold:(double)threshold NS_SWIFT_NAME(recoverPose(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:E:R:t:method:prob:threshold:));

/**
 * Recovers the relative camera rotation and the translation from corresponding points in two images from two different cameras, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix1 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs1 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param cameraMatrix2 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs2 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param E The output essential matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * @param prob Parameter used for the RANSAC or LMedS methods only. It specifies a desirable level of
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for findEssentialMat.:
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // Input: camera calibration of both cameras, for example using intrinsic chessboard calibration.
 *     Mat cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2;
 *
 *     // Output: Essential matrix, relative rotation and relative translation.
 *     Mat E, R, t, mask;
 *
 *     recoverPose(points1, points2, cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, E, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 E:(Mat*)E R:(Mat*)R t:(Mat*)t method:(int)method prob:(double)prob NS_SWIFT_NAME(recoverPose(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:E:R:t:method:prob:));

/**
 * Recovers the relative camera rotation and the translation from corresponding points in two images from two different cameras, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix1 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs1 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param cameraMatrix2 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs2 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param E The output essential matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param method Method for computing an essential matrix.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for findEssentialMat.:
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // Input: camera calibration of both cameras, for example using intrinsic chessboard calibration.
 *     Mat cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2;
 *
 *     // Output: Essential matrix, relative rotation and relative translation.
 *     Mat E, R, t, mask;
 *
 *     recoverPose(points1, points2, cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, E, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 E:(Mat*)E R:(Mat*)R t:(Mat*)t method:(int)method NS_SWIFT_NAME(recoverPose(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:E:R:t:method:));

/**
 * Recovers the relative camera rotation and the translation from corresponding points in two images from two different cameras, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix1 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs1 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param cameraMatrix2 Input/output camera matrix for the first camera, the same as in
 * Ref:* calibrateCamera. Furthermore, for the stereo case, additional flags may be used, see below.
 * @param distCoeffs2 Input/output vector of distortion coefficients, the same as in
 * Ref:* calibrateCamera.
 * @param E The output essential matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * -   *Ref:* RANSAC for the RANSAC algorithm.
 * -   *Ref:* LMEDS for the LMedS algorithm.
 * confidence (probability) that the estimated matrix is correct.
 * line in pixels, beyond which the point is considered an outlier and is not used for computing the
 * final fundamental matrix. It can be set to something like 1-3, depending on the accuracy of the
 * point localization, image resolution, and the image noise.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for findEssentialMat.:
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // Input: camera calibration of both cameras, for example using intrinsic chessboard calibration.
 *     Mat cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2;
 *
 *     // Output: Essential matrix, relative rotation and relative translation.
 *     Mat E, R, t, mask;
 *
 *     recoverPose(points1, points2, cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, E, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)points1 points2:(Mat*)points2 cameraMatrix1:(Mat*)cameraMatrix1 distCoeffs1:(Mat*)distCoeffs1 cameraMatrix2:(Mat*)cameraMatrix2 distCoeffs2:(Mat*)distCoeffs2 E:(Mat*)E R:(Mat*)R t:(Mat*)t NS_SWIFT_NAME(recoverPose(points1:points2:cameraMatrix1:distCoeffs1:cameraMatrix2:distCoeffs2:E:R:t:));


//
//  int cv::recoverPose(Mat E, Mat points1, Mat points2, Mat cameraMatrix, Mat& R, Mat& t, Mat& mask = Mat())
//
/**
 * Recovers the relative camera rotation and the translation from an estimated essential
 * matrix and the corresponding points in two images, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param mask Input/output mask for inliers in points1 and points2. If it is not empty, then it marks
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for ``Geometry/findEssentialMat`` :
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // cametra matrix with both focal lengths = 1, and principal point = (0, 0)
 *     Mat cameraMatrix = Mat::eye(3, 3, CV_64F);
 *
 *     Mat E, R, t, mask;
 *
 *     E = findEssentialMat(points1, points2, cameraMatrix, RANSAC, 0.999, 1.0, mask);
 *     recoverPose(E, points1, points2, cameraMatrix, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix R:(Mat*)R t:(Mat*)t mask:(Mat*)mask NS_SWIFT_NAME(recoverPose(E:points1:points2:cameraMatrix:R:t:mask:));

/**
 * Recovers the relative camera rotation and the translation from an estimated essential
 * matrix and the corresponding points in two images, using chirality check. Returns the number of
 * inliers that pass the check.
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * described below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function decomposes an essential matrix using *Ref:* decomposeEssentialMat and then verifies
 * possible pose hypotheses by doing chirality check. The chirality check means that the
 * triangulated 3D points should have positive depth. Some details can be found in *Cite:* Nister03.
 *
 * This function can be used to process the output E and mask from *Ref:* findEssentialMat. In this
 * scenario, points1 and points2 are the same input for ``Geometry/findEssentialMat`` :
 *
 *     // Example. Estimation of fundamental matrix using the RANSAC algorithm
 *     int point_count = 100;
 *     vector<Point2f> points1(point_count);
 *     vector<Point2f> points2(point_count);
 *
 *     // initialize the points here ...
 *     for( int i = 0; i < point_count; i++ )
 *     {
 *         points1[i] = ...;
 *         points2[i] = ...;
 *     }
 *
 *     // cametra matrix with both focal lengths = 1, and principal point = (0, 0)
 *     Mat cameraMatrix = Mat::eye(3, 3, CV_64F);
 *
 *     Mat E, R, t, mask;
 *
 *     E = findEssentialMat(points1, points2, cameraMatrix, RANSAC, 0.999, 1.0, mask);
 *     recoverPose(E, points1, points2, cameraMatrix, R, t, mask);
 *
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix R:(Mat*)R t:(Mat*)t NS_SWIFT_NAME(recoverPose(E:points1:points2:cameraMatrix:R:t:));


//
//  int cv::recoverPose(Mat E, Mat points1, Mat points2, Mat& R, Mat& t, double focal = 1.0, Point2d pp = Point2d(0, 0), Mat& mask = Mat())
//
/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param focal Focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * @param mask Input/output mask for inliers in points1 and points2. If it is not empty, then it marks
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 R:(Mat*)R t:(Mat*)t focal:(double)focal pp:(Point2d*)pp mask:(Mat*)mask NS_SWIFT_NAME(recoverPose(E:points1:points2:R:t:focal:pp:mask:));

/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param focal Focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * @param pp principal point of the camera.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 R:(Mat*)R t:(Mat*)t focal:(double)focal pp:(Point2d*)pp NS_SWIFT_NAME(recoverPose(E:points1:points2:R:t:focal:pp:));

/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param focal Focal length of the camera. Note that this function assumes that points1 and points2
 * are feature points from cameras with same focal length and principal point.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 R:(Mat*)R t:(Mat*)t focal:(double)focal NS_SWIFT_NAME(recoverPose(E:points1:points2:R:t:focal:));

/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1 .
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * are feature points from cameras with same focal length and principal point.
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function differs from the one above that it computes camera intrinsic matrix from focal length and
 * principal point:
 *
 * `$$A =
 * \begin{bmatrix}
 * f & 0 & x_{pp}  \\
 * 0 & f & y_{pp}  \\
 * 0 & 0 & 1
 * \end{bmatrix}$$`
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 R:(Mat*)R t:(Mat*)t NS_SWIFT_NAME(recoverPose(E:points1:points2:R:t:));


//
//  int cv::recoverPose(Mat E, Mat points1, Mat points2, Mat cameraMatrix, Mat& R, Mat& t, double distanceThresh, Mat& mask = Mat(), Mat& triangulatedPoints = Mat())
//
/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param distanceThresh threshold distance which is used to filter out far away points (i.e. infinite
 * points).
 * @param mask Input/output mask for inliers in points1 and points2. If it is not empty, then it marks
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 * @param triangulatedPoints 3D points which were reconstructed by triangulation.
 *
 * This function differs from the one above that it outputs the triangulated 3D point that are used for
 * the chirality check.
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix R:(Mat*)R t:(Mat*)t distanceThresh:(double)distanceThresh mask:(Mat*)mask triangulatedPoints:(Mat*)triangulatedPoints NS_SWIFT_NAME(recoverPose(E:points1:points2:cameraMatrix:R:t:distanceThresh:mask:triangulatedPoints:));

/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param distanceThresh threshold distance which is used to filter out far away points (i.e. infinite
 * points).
 * @param mask Input/output mask for inliers in points1 and points2. If it is not empty, then it marks
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function differs from the one above that it outputs the triangulated 3D point that are used for
 * the chirality check.
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix R:(Mat*)R t:(Mat*)t distanceThresh:(double)distanceThresh mask:(Mat*)mask NS_SWIFT_NAME(recoverPose(E:points1:points2:cameraMatrix:R:t:distanceThresh:mask:));

/**
 *
 * @param E The input essential matrix.
 * @param points1 Array of N 2D points from the first image. The point coordinates should be
 * floating-point (single or double precision).
 * @param points2 Array of the second image points of the same size and format as points1.
 * @param cameraMatrix Camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * Note that this function assumes that points1 and points2 are feature points from cameras with the
 * same camera intrinsic matrix.
 * @param R Output rotation matrix. Together with the translation vector, this matrix makes up a tuple
 * that performs a change of basis from the first camera's coordinate system to the second camera's
 * coordinate system. Note that, in general, t can not be used for this tuple, see the parameter
 * description below.
 * @param t Output translation vector. This vector is obtained by *Ref:* decomposeEssentialMat and
 * therefore is only known up to scale, i.e. t is the direction of the translation vector and has unit
 * length.
 * @param distanceThresh threshold distance which is used to filter out far away points (i.e. infinite
 * points).
 * inliers in points1 and points2 for the given essential matrix E. Only these inliers will be used to
 * recover pose. In the output mask only inliers which pass the chirality check.
 *
 * This function differs from the one above that it outputs the triangulated 3D point that are used for
 * the chirality check.
 */
+ (int)recoverPose:(Mat*)E points1:(Mat*)points1 points2:(Mat*)points2 cameraMatrix:(Mat*)cameraMatrix R:(Mat*)R t:(Mat*)t distanceThresh:(double)distanceThresh NS_SWIFT_NAME(recoverPose(E:points1:points2:cameraMatrix:R:t:distanceThresh:));


//
//  void cv::computeCorrespondEpilines(Mat points, int whichImage, Mat F, Mat& lines)
//
/**
 * For points in an image of a stereo pair, computes the corresponding epilines in the other image.
 *
 * @param points Input points. `$$N \times 1$$` or `$$1 \times N$$` matrix of type CV_32FC2 or
 * vector\<Point2f\> .
 * @param whichImage Index of the image (1 or 2) that contains the points .
 * @param F Fundamental matrix that can be estimated using ``Geometry/findFundamentalMat`` or #stereoRectify .
 * @param lines Output vector of the epipolar lines corresponding to the points in the other image.
 * Each line `$$ax + by + c=0$$` is encoded by 3 numbers `$$(a, b, c)$$` .
 *
 * For every point in one of the two images of a stereo pair, the function finds the equation of the
 * corresponding epipolar line in the other image.
 *
 * From the fundamental matrix definition (see ``Geometry/findFundamentalMat`` ), line `$$l^{(2)}_i$$` in the second
 * image for the point `$$p^{(1)}_i$$` in the first image (when whichImage=1 ) is computed as:
 *
 * `$$l^{(2)}_i = F p^{(1)}_i$$`
 *
 * And vice versa, when whichImage=2, `$$l^{(1)}_i$$` is computed from `$$p^{(2)}_i$$` as:
 *
 * `$$l^{(1)}_i = F^T p^{(2)}_i$$`
 *
 * Line coefficients are defined up to a scale. They are normalized so that `$$a_i^2+b_i^2=1$$` .
 */
+ (void)computeCorrespondEpilines:(Mat*)points whichImage:(int)whichImage F:(Mat*)F lines:(Mat*)lines NS_SWIFT_NAME(computeCorrespondEpilines(points:whichImage:F:lines:));


//
//  void cv::triangulatePoints(Mat projMatr1, Mat projMatr2, Mat projPoints1, Mat projPoints2, Mat& points4D)
//
/**
 * This function reconstructs 3-dimensional points (in homogeneous coordinates) by using
 * their observations with a stereo camera.
 *
 * @param projMatr1 3x4 projection matrix of the first camera, i.e. this matrix projects 3D points
 * given in the world's coordinate system into the first image.
 * @param projMatr2 3x4 projection matrix of the second camera, i.e. this matrix projects 3D points
 * given in the world's coordinate system into the second image.
 * @param projPoints1 2xN array of feature points in the first image. In the case of the c++ version,
 * it can be also a vector of feature points or two-channel matrix of size 1xN or Nx1.
 * @param projPoints2 2xN array of corresponding points in the second image. In the case of the c++
 * version, it can be also a vector of feature points or two-channel matrix of size 1xN or Nx1.
 * @param points4D 4xN array of reconstructed points in homogeneous coordinates. These points are
 * returned in the world's coordinate system.
 *
 * Note:*
 *    Keep in mind that all input data should be of float type in order for this function to work.
 *
 * Note:*
 *    If the projection matrices from *Ref:* stereoRectify are used, then the returned points are
 *    represented in the first camera's rectified coordinate system.
 *
 * @sa
 *    reprojectImageTo3D
 */
+ (void)triangulatePoints:(Mat*)projMatr1 projMatr2:(Mat*)projMatr2 projPoints1:(Mat*)projPoints1 projPoints2:(Mat*)projPoints2 points4D:(Mat*)points4D NS_SWIFT_NAME(triangulatePoints(projMatr1:projMatr2:projPoints1:projPoints2:points4D:));


//
//  void cv::correctMatches(Mat F, Mat points1, Mat points2, Mat& newPoints1, Mat& newPoints2)
//
/**
 * Refines coordinates of corresponding points.
 *
 * @param F 3x3 fundamental matrix.
 * @param points1 1xN array containing the first set of points.
 * @param points2 1xN array containing the second set of points.
 * @param newPoints1 The optimized points1.
 * @param newPoints2 The optimized points2.
 *
 * The function implements the Optimal Triangulation Method (see Multiple View Geometry *Cite:* HartleyZ00 for details).
 * For each given point correspondence points1[i] \<-\> points2[i], and a fundamental matrix F, it
 * computes the corrected correspondences newPoints1[i] \<-\> newPoints2[i] that minimize the geometric
 * error `$$d(points1[i], newPoints1[i])^2 + d(points2[i],newPoints2[i])^2$$` (where `$$d(a,b)$$` is the
 * geometric distance between points `$$a$$` and `$$b$$` ) subject to the epipolar constraint
 * `$$newPoints2^T \cdot F \cdot newPoints1 = 0$$` .
 */
+ (void)correctMatches:(Mat*)F points1:(Mat*)points1 points2:(Mat*)points2 newPoints1:(Mat*)newPoints1 newPoints2:(Mat*)newPoints2 NS_SWIFT_NAME(correctMatches(F:points1:points2:newPoints1:newPoints2:));


//
//  double cv::sampsonDistance(Mat pt1, Mat pt2, Mat F)
//
/**
 * Calculates the Sampson Distance between two points.
 *
 * The function cv::sampsonDistance calculates and returns the first order approximation of the geometric error as:
 * `$$
 * sd( \texttt{pt1} , \texttt{pt2} )=
 * \frac{(\texttt{pt2}^t \cdot \texttt{F} \cdot \texttt{pt1})^2}
 * {((\texttt{F} \cdot \texttt{pt1})(0))^2 +
 * ((\texttt{F} \cdot \texttt{pt1})(1))^2 +
 * ((\texttt{F}^t \cdot \texttt{pt2})(0))^2 +
 * ((\texttt{F}^t \cdot \texttt{pt2})(1))^2}
 * $$`
 * The fundamental matrix may be calculated using the ``Geometry/findFundamentalMat`` function. See *Cite:* HartleyZ00 11.4.3 for details.
 * @param pt1 first homogeneous 2d point
 * @param pt2 second homogeneous 2d point
 * @param F fundamental matrix
 * @return The computed Sampson distance.
 */
+ (double)sampsonDistance:(Mat*)pt1 pt2:(Mat*)pt2 F:(Mat*)F NS_SWIFT_NAME(sampsonDistance(pt1:pt2:F:));


//
//  bool cv::estimateAffine3D(Mat src, Mat dst, Mat& out, Mat& inliers, double ransacThreshold = 3, double confidence = 0.99)
//
/**
 * Computes an optimal affine transformation between two 3D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * z\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12} & a_{13}\\
 * a_{21} & a_{22} & a_{23}\\
 * a_{31} & a_{32} & a_{33}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * Z\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * b_3\\
 * \end{bmatrix}
 * $$`
 *
 * @param src First input 3D point set containing `$$(X,Y,Z)$$`.
 * @param dst Second input 3D point set containing `$$(x,y,z)$$`.
 * @param out Output 3D affine transformation matrix `$$3 \times 4$$` of the form
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & a_{13} & b_1\\
 * a_{21} & a_{22} & a_{23} & b_2\\
 * a_{31} & a_{32} & a_{33} & b_3\\
 * \end{bmatrix}
 * $$`
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param ransacThreshold Maximum reprojection error in the RANSAC algorithm to consider a point as
 * an inlier.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 *
 * @return Whether a solution was found.
 *
 * The function estimates an optimal 3D affine transformation between two 3D point sets using the
 * RANSAC algorithm.
 */
+ (BOOL)estimateAffine3D:(Mat*)src dst:(Mat*)dst out:(Mat*)out inliers:(Mat*)inliers ransacThreshold:(double)ransacThreshold confidence:(double)confidence NS_SWIFT_NAME(estimateAffine3D(src:dst:out:inliers:ransacThreshold:confidence:));

/**
 * Computes an optimal affine transformation between two 3D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * z\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12} & a_{13}\\
 * a_{21} & a_{22} & a_{23}\\
 * a_{31} & a_{32} & a_{33}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * Z\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * b_3\\
 * \end{bmatrix}
 * $$`
 *
 * @param src First input 3D point set containing `$$(X,Y,Z)$$`.
 * @param dst Second input 3D point set containing `$$(x,y,z)$$`.
 * @param out Output 3D affine transformation matrix `$$3 \times 4$$` of the form
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & a_{13} & b_1\\
 * a_{21} & a_{22} & a_{23} & b_2\\
 * a_{31} & a_{32} & a_{33} & b_3\\
 * \end{bmatrix}
 * $$`
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param ransacThreshold Maximum reprojection error in the RANSAC algorithm to consider a point as
 * an inlier.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 *
 * @return Whether a solution was found.
 *
 * The function estimates an optimal 3D affine transformation between two 3D point sets using the
 * RANSAC algorithm.
 */
+ (BOOL)estimateAffine3D:(Mat*)src dst:(Mat*)dst out:(Mat*)out inliers:(Mat*)inliers ransacThreshold:(double)ransacThreshold NS_SWIFT_NAME(estimateAffine3D(src:dst:out:inliers:ransacThreshold:));

/**
 * Computes an optimal affine transformation between two 3D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * z\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12} & a_{13}\\
 * a_{21} & a_{22} & a_{23}\\
 * a_{31} & a_{32} & a_{33}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * Z\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * b_3\\
 * \end{bmatrix}
 * $$`
 *
 * @param src First input 3D point set containing `$$(X,Y,Z)$$`.
 * @param dst Second input 3D point set containing `$$(x,y,z)$$`.
 * @param out Output 3D affine transformation matrix `$$3 \times 4$$` of the form
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & a_{13} & b_1\\
 * a_{21} & a_{22} & a_{23} & b_2\\
 * a_{31} & a_{32} & a_{33} & b_3\\
 * \end{bmatrix}
 * $$`
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * an inlier.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 *
 * @return Whether a solution was found.
 *
 * The function estimates an optimal 3D affine transformation between two 3D point sets using the
 * RANSAC algorithm.
 */
+ (BOOL)estimateAffine3D:(Mat*)src dst:(Mat*)dst out:(Mat*)out inliers:(Mat*)inliers NS_SWIFT_NAME(estimateAffine3D(src:dst:out:inliers:));


//
//  Mat cv::estimateAffine3D(Mat src, Mat dst, double* scale = nullptr, bool force_rotation = true)
//
/**
 * Computes an optimal affine transformation between two 3D point sets.
 *
 * It computes `$$R,s,t$$` minimizing `$$\sum{i} dst_i - c \cdot R \cdot src_i $$`
 * where `$$R$$` is a 3x3 rotation matrix, `$$t$$` is a 3x1 translation vector and `$$s$$` is a
 * scalar size value. This is an implementation of the algorithm by Umeyama \cite umeyama1991least .
 * The estimated affine transform has a homogeneous scale which is a subclass of affine
 * transformations with 7 degrees of freedom. The paired point sets need to comprise at least 3
 * points each.
 *
 * @param src First input 3D point set.
 * @param dst Second input 3D point set.
 * @param scale If null is passed, the scale parameter c will be assumed to be 1.0.
 * Else the pointed-to variable will be set to the optimal scale.
 * @param force_rotation If true, the returned rotation will never be a reflection.
 * This might be unwanted, e.g. when optimizing a transform between a right- and a
 * left-handed coordinate system.
 * @return 3D affine transformation matrix `$$3 \times 4$$` of the form
 * `$$T =
 * \begin{bmatrix}
 * R & t\\
 * \end{bmatrix}
 * $$`
 */
+ (Mat*)estimateAffine3D:(Mat*)src dst:(Mat*)dst scale:(double*)scale force_rotation:(BOOL)force_rotation NS_SWIFT_NAME(estimateAffine3D(src:dst:scale:force_rotation:));

/**
 * Computes an optimal affine transformation between two 3D point sets.
 *
 * It computes `$$R,s,t$$` minimizing `$$\sum{i} dst_i - c \cdot R \cdot src_i $$`
 * where `$$R$$` is a 3x3 rotation matrix, `$$t$$` is a 3x1 translation vector and `$$s$$` is a
 * scalar size value. This is an implementation of the algorithm by Umeyama \cite umeyama1991least .
 * The estimated affine transform has a homogeneous scale which is a subclass of affine
 * transformations with 7 degrees of freedom. The paired point sets need to comprise at least 3
 * points each.
 *
 * @param src First input 3D point set.
 * @param dst Second input 3D point set.
 * @param scale If null is passed, the scale parameter c will be assumed to be 1.0.
 * Else the pointed-to variable will be set to the optimal scale.
 * This might be unwanted, e.g. when optimizing a transform between a right- and a
 * left-handed coordinate system.
 * @return 3D affine transformation matrix `$$3 \times 4$$` of the form
 * `$$T =
 * \begin{bmatrix}
 * R & t\\
 * \end{bmatrix}
 * $$`
 */
+ (Mat*)estimateAffine3D:(Mat*)src dst:(Mat*)dst scale:(double*)scale NS_SWIFT_NAME(estimateAffine3D(src:dst:scale:));

/**
 * Computes an optimal affine transformation between two 3D point sets.
 *
 * It computes `$$R,s,t$$` minimizing `$$\sum{i} dst_i - c \cdot R \cdot src_i $$`
 * where `$$R$$` is a 3x3 rotation matrix, `$$t$$` is a 3x1 translation vector and `$$s$$` is a
 * scalar size value. This is an implementation of the algorithm by Umeyama \cite umeyama1991least .
 * The estimated affine transform has a homogeneous scale which is a subclass of affine
 * transformations with 7 degrees of freedom. The paired point sets need to comprise at least 3
 * points each.
 *
 * @param src First input 3D point set.
 * @param dst Second input 3D point set.
 * Else the pointed-to variable will be set to the optimal scale.
 * This might be unwanted, e.g. when optimizing a transform between a right- and a
 * left-handed coordinate system.
 * @return 3D affine transformation matrix `$$3 \times 4$$` of the form
 * `$$T =
 * \begin{bmatrix}
 * R & t\\
 * \end{bmatrix}
 * $$`
 */
+ (Mat*)estimateAffine3D:(Mat*)src dst:(Mat*)dst NS_SWIFT_NAME(estimateAffine3D(src:dst:));


//
//  bool cv::estimateTranslation3D(Mat src, Mat dst, Mat& out, Mat& inliers, double ransacThreshold = 3, double confidence = 0.99)
//
/**
 * Computes an optimal translation between two 3D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * z\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * X\\
 * Y\\
 * Z\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * b_3\\
 * \end{bmatrix}
 * $$`
 *
 * @param src First input 3D point set containing `$$(X,Y,Z)$$`.
 * @param dst Second input 3D point set containing `$$(x,y,z)$$`.
 * @param out Output 3D translation vector `$$3 \times 1$$` of the form
 * `$$
 * \begin{bmatrix}
 * b_1 \\
 * b_2 \\
 * b_3 \\
 * \end{bmatrix}
 * $$`
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param ransacThreshold Maximum reprojection error in the RANSAC algorithm to consider a point as
 * an inlier.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 *
 * @return Whether a translation was found.
 *
 * The function estimates an optimal 3D translation between two 3D point sets using the
 * RANSAC algorithm.
 *
 */
+ (BOOL)estimateTranslation3D:(Mat*)src dst:(Mat*)dst out:(Mat*)out inliers:(Mat*)inliers ransacThreshold:(double)ransacThreshold confidence:(double)confidence NS_SWIFT_NAME(estimateTranslation3D(src:dst:out:inliers:ransacThreshold:confidence:));

/**
 * Computes an optimal translation between two 3D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * z\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * X\\
 * Y\\
 * Z\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * b_3\\
 * \end{bmatrix}
 * $$`
 *
 * @param src First input 3D point set containing `$$(X,Y,Z)$$`.
 * @param dst Second input 3D point set containing `$$(x,y,z)$$`.
 * @param out Output 3D translation vector `$$3 \times 1$$` of the form
 * `$$
 * \begin{bmatrix}
 * b_1 \\
 * b_2 \\
 * b_3 \\
 * \end{bmatrix}
 * $$`
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param ransacThreshold Maximum reprojection error in the RANSAC algorithm to consider a point as
 * an inlier.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 *
 * @return Whether a translation was found.
 *
 * The function estimates an optimal 3D translation between two 3D point sets using the
 * RANSAC algorithm.
 *
 */
+ (BOOL)estimateTranslation3D:(Mat*)src dst:(Mat*)dst out:(Mat*)out inliers:(Mat*)inliers ransacThreshold:(double)ransacThreshold NS_SWIFT_NAME(estimateTranslation3D(src:dst:out:inliers:ransacThreshold:));

/**
 * Computes an optimal translation between two 3D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * z\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * X\\
 * Y\\
 * Z\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * b_3\\
 * \end{bmatrix}
 * $$`
 *
 * @param src First input 3D point set containing `$$(X,Y,Z)$$`.
 * @param dst Second input 3D point set containing `$$(x,y,z)$$`.
 * @param out Output 3D translation vector `$$3 \times 1$$` of the form
 * `$$
 * \begin{bmatrix}
 * b_1 \\
 * b_2 \\
 * b_3 \\
 * \end{bmatrix}
 * $$`
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * an inlier.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 *
 * @return Whether a translation was found.
 *
 * The function estimates an optimal 3D translation between two 3D point sets using the
 * RANSAC algorithm.
 *
 */
+ (BOOL)estimateTranslation3D:(Mat*)src dst:(Mat*)dst out:(Mat*)out inliers:(Mat*)inliers NS_SWIFT_NAME(estimateTranslation3D(src:dst:out:inliers:));


//
//  Mat cv::estimateAffine2D(Mat from, Mat to, Mat& inliers = Mat(), int method = RANSAC, double ransacReprojThreshold = 3, size_t maxIters = 2000, double confidence = 0.99, size_t refineIters = 10)
//
/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * @param refineIters Maximum number of iterations of refining algorithm (Levenberg-Marquardt).
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters confidence:(double)confidence refineIters:(size_t)refineIters NS_SWIFT_NAME(estimateAffine2D(from:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:));

/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters confidence:(double)confidence NS_SWIFT_NAME(estimateAffine2D(from:to:inliers:method:ransacReprojThreshold:maxIters:confidence:));

/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters NS_SWIFT_NAME(estimateAffine2D(from:to:inliers:method:ransacReprojThreshold:maxIters:));

/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold NS_SWIFT_NAME(estimateAffine2D(from:to:inliers:method:ransacReprojThreshold:));

/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method NS_SWIFT_NAME(estimateAffine2D(from:to:inliers:method:));

/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers NS_SWIFT_NAME(estimateAffine2D(from:to:inliers:));

/**
 * Computes an optimal affine transformation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y\\
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * a_{11} & a_{12}\\
 * a_{21} & a_{22}\\
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y\\
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * b_1\\
 * b_2\\
 * \end{bmatrix}
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation matrix `$$2 \times 3$$` or empty matrix if transformation
 * could not be estimated. The returned matrix has the following form:
 * `$$
 * \begin{bmatrix}
 * a_{11} & a_{12} & b_1\\
 * a_{21} & a_{22} & b_2\\
 * \end{bmatrix}
 * $$`
 *
 * The function estimates an optimal 2D affine transformation between two 2D point sets using the
 * selected robust algorithm.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffine2D:(Mat*)from to:(Mat*)to NS_SWIFT_NAME(estimateAffine2D(from:to:));


//
//  Mat cv::estimateAffine2D(Mat pts1, Mat pts2, Mat& inliers, UsacParams params)
//
+ (Mat*)estimateAffine2D:(Mat*)pts1 pts2:(Mat*)pts2 inliers:(Mat*)inliers params:(UsacParams*)params NS_SWIFT_NAME(estimateAffine2D(pts1:pts2:inliers:params:));


//
//  Mat cv::estimateAffinePartial2D(Mat from, Mat to, Mat& inliers = Mat(), int method = RANSAC, double ransacReprojThreshold = 3, size_t maxIters = 2000, double confidence = 0.99, size_t refineIters = 10)
//
/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * @param inliers Output vector indicating which points are inliers.
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * @param refineIters Maximum number of iterations of refining algorithm (Levenberg-Marquardt).
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters confidence:(double)confidence refineIters:(size_t)refineIters NS_SWIFT_NAME(estimateAffinePartial2D(from:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:));

/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * @param inliers Output vector indicating which points are inliers.
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters confidence:(double)confidence NS_SWIFT_NAME(estimateAffinePartial2D(from:to:inliers:method:ransacReprojThreshold:maxIters:confidence:));

/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * @param inliers Output vector indicating which points are inliers.
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters NS_SWIFT_NAME(estimateAffinePartial2D(from:to:inliers:method:ransacReprojThreshold:maxIters:));

/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * @param inliers Output vector indicating which points are inliers.
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold NS_SWIFT_NAME(estimateAffinePartial2D(from:to:inliers:method:ransacReprojThreshold:));

/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * @param inliers Output vector indicating which points are inliers.
 * @param method Robust method used to compute transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method NS_SWIFT_NAME(estimateAffinePartial2D(from:to:inliers:method:));

/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * @param inliers Output vector indicating which points are inliers.
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers NS_SWIFT_NAME(estimateAffinePartial2D(from:to:inliers:));

/**
 * Computes an optimal limited affine transformation with 4 degrees of freedom between
 * two 2D point sets.
 *
 * @param from First input 2D point set.
 * @param to Second input 2D point set.
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8-0.9 can result in an incorrectly estimated transformation.
 * Passing 0 will disable refining, so the output matrix will be output of robust method.
 *
 * @return Output 2D affine transformation (4 degrees of freedom) matrix `$$2 \times 3$$` or
 * empty matrix if transformation could not be estimated.
 *
 * The function estimates an optimal 2D affine transformation with 4 degrees of freedom limited to
 * combinations of translation, rotation, and uniform scaling. Uses the selected algorithm for robust
 * estimation.
 *
 * The computed transformation is then refined further (using only inliers) with the
 * Levenberg-Marquardt method to reduce the re-projection error even more.
 *
 * Estimated transformation matrix is:
 * `$$ \begin{bmatrix} \cos(\theta) \cdot s & -\sin(\theta) \cdot s & t_x \\
 *                 \sin(\theta) \cdot s & \cos(\theta) \cdot s & t_y
 * \end{bmatrix} $$`
 * Where `$$ \theta $$` is the rotation angle, `$$ s $$` the scaling factor and `$$ t_x, t_y $$` are
 * translations in `$$ x, y $$` axes respectively.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but need a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but it works
 * correctly only when there are more than 50% of inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Mat*)estimateAffinePartial2D:(Mat*)from to:(Mat*)to NS_SWIFT_NAME(estimateAffinePartial2D(from:to:));


//
//  Vec2d cv::estimateTranslation2D(Mat from, Mat to, Mat& inliers = Mat(), int method = RANSAC, double ransacReprojThreshold = 3, size_t maxIters = 2000, double confidence = 0.99, size_t refineIters = 0)
//
/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute the transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * @param refineIters Maximum number of iterations of the refining algorithm. For pure translation
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters confidence:(double)confidence refineIters:(size_t)refineIters NS_SWIFT_NAME(estimateTranslation2D(from:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:));

/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute the transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * @param confidence Confidence level, between 0 and 1, for the estimated transformation. Anything
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters confidence:(double)confidence NS_SWIFT_NAME(estimateTranslation2D(from:to:inliers:method:ransacReprojThreshold:maxIters:confidence:));

/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute the transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * @param maxIters The maximum number of robust method iterations.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold maxIters:(size_t)maxIters NS_SWIFT_NAME(estimateTranslation2D(from:to:inliers:method:ransacReprojThreshold:maxIters:));

/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute the transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * @param ransacReprojThreshold Maximum reprojection error in the RANSAC algorithm to consider
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method ransacReprojThreshold:(double)ransacReprojThreshold NS_SWIFT_NAME(estimateTranslation2D(from:to:inliers:method:ransacReprojThreshold:));

/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * @param method Robust method used to compute the transformation. The following methods are possible:
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers method:(int)method NS_SWIFT_NAME(estimateTranslation2D(from:to:inliers:method:));

/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * @param inliers Output vector indicating which points are inliers (1-inlier, 0-outlier).
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to inliers:(Mat*)inliers NS_SWIFT_NAME(estimateTranslation2D(from:to:inliers:));

/**
 * Computes a pure 2D translation between two 2D point sets.
 *
 * It computes
 * `$$
 * \begin{bmatrix}
 * x\\
 * y
 * \end{bmatrix}
 * =
 * \begin{bmatrix}
 * 1 & 0\\
 * 0 & 1
 * \end{bmatrix}
 * \begin{bmatrix}
 * X\\
 * Y
 * \end{bmatrix}
 * +
 * \begin{bmatrix}
 * t_x\\
 * t_y
 * \end{bmatrix}.
 * $$`
 *
 * @param from First input 2D point set containing `$$(X,Y)$$`.
 * @param to Second input 2D point set containing `$$(x,y)$$`.
 * -   *Ref:* RANSAC - RANSAC-based robust method
 * -   *Ref:* LMEDS - Least-Median robust method
 * RANSAC is the default method.
 * a point as an inlier. Applies only to RANSAC.
 * between 0.95 and 0.99 is usually good enough. Values too close to 1 can slow down the estimation
 * significantly. Values lower than 0.8–0.9 can result in an incorrectly estimated transformation.
 * the least-squares solution on inliers is closed-form, so passing 0 is recommended (no additional refine).
 *
 * @return A 2D translation vector `$$[t_x, t_y]^T$$` as `cv::Vec2d`. If the translation could not be
 * estimated, both components are set to NaN and, if @p inliers is provided, the mask is filled with zeros.
 *
 * \par Converting to a 2x3 transformation matrix:
 * `$$
 * \begin{bmatrix}
 * 1 & 0 & t_x\\
 * 0 & 1 & t_y
 * \end{bmatrix}
 * $$`
 *
 *
 * cv::Vec2d t = cv::estimateTranslation2D(from, to, inliers);
 * cv::Mat T = (cv::Mat_<double>(2,3) << 1,0,t[0], 0,1,t[1]);
 *
 *
 * The function estimates a pure 2D translation between two 2D point sets using the selected robust
 * algorithm. Inliers are determined by the reprojection error threshold.
 *
 * Note:*
 * The RANSAC method can handle practically any ratio of outliers but needs a threshold to
 * distinguish inliers from outliers. The method LMeDS does not need any threshold but works
 * correctly only when there are more than 50% inliers.
 *
 * - SeeAlso ``estimateAffine2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``estimateAffinePartial2D:to:inliers:method:ransacReprojThreshold:maxIters:confidence:refineIters:``, ``getAffineTransform:dst:``
 */
+ (Double2*)estimateTranslation2D:(Mat*)from to:(Mat*)to NS_SWIFT_NAME(estimateTranslation2D(from:to:));


//
//  int cv::decomposeHomographyMat(Mat H, Mat K, vector_Mat& rotations, vector_Mat& translations, vector_Mat& normals)
//
/**
 * Decompose a homography matrix to rotation(s), translation(s) and plane normal(s).
 *
 * @param H The input homography matrix between two images.
 * @param K The input camera intrinsic matrix.
 * @param rotations Array of rotation matrices.
 * @param translations Array of translation matrices.
 * @param normals Array of plane normal matrices.
 *
 * This function extracts relative camera motion between two views of a planar object and returns up to
 * four mathematical solution tuples of rotation, translation, and plane normal. The decomposition of
 * the homography matrix H is described in detail in *Cite:* Malis2007.
 *
 * If the homography H, induced by the plane, gives the constraint
 * `$$s_i \vecthree{x'_i}{y'_i}{1} \sim H \vecthree{x_i}{y_i}{1}$$` on the source image points
 * `$$p_i$$` and the destination image points `$$p'_i$$`, then the tuple of rotations[k] and
 * translations[k] is a change of basis from the source camera's coordinate system to the destination
 * camera's coordinate system. However, by decomposing H, one can only get the translation normalized
 * by the (typically unknown) depth of the scene, i.e. its direction but with normalized length.
 *
 * If point correspondences are available, at least two solutions may further be invalidated, by
 * applying positive depth constraint, i.e. all points must be in front of the camera.
 */
+ (int)decomposeHomographyMat:(Mat*)H K:(Mat*)K rotations:(NSMutableArray<Mat*>*)rotations translations:(NSMutableArray<Mat*>*)translations normals:(NSMutableArray<Mat*>*)normals NS_SWIFT_NAME(decomposeHomographyMat(H:K:rotations:translations:normals:));


//
//  void cv::filterHomographyDecompByVisibleRefpoints(vector_Mat rotations, vector_Mat normals, Mat beforePoints, Mat afterPoints, Mat& possibleSolutions, Mat pointsMask = Mat())
//
/**
 * Filters homography decompositions based on additional information.
 *
 * @param rotations Vector of rotation matrices.
 * @param normals Vector of plane normal matrices.
 * @param beforePoints Vector of (rectified) visible reference points before the homography is applied
 * @param afterPoints Vector of (rectified) visible reference points after the homography is applied
 * @param possibleSolutions Vector of int indices representing the viable solution set after filtering
 * @param pointsMask optional Mat/Vector of CV_8U, CV_8S or CV_Bool type representing the mask for the inliers
 * as given by the ``Geometry/findHomography`` function
 *
 * This function is intended to filter the output of the ``Geometry/decomposeHomographyMat`` based on additional
 * information as described in *Cite:* Malis2007 . The summary of the method: the ``Geometry/decomposeHomographyMat`` function
 * returns 2 unique solutions and their "opposites" for a total of 4 solutions. If we have access to the
 * sets of points visible in the camera frame before and after the homography transformation is applied,
 * we can determine which are the true potential solutions and which are the opposites by verifying which
 * homographies are consistent with all visible reference points being in front of the camera. The inputs
 * are left unchanged; the filtered solution set is returned as indices into the existing one.
 */
+ (void)filterHomographyDecompByVisibleRefpoints:(NSArray<Mat*>*)rotations normals:(NSArray<Mat*>*)normals beforePoints:(Mat*)beforePoints afterPoints:(Mat*)afterPoints possibleSolutions:(Mat*)possibleSolutions pointsMask:(Mat*)pointsMask NS_SWIFT_NAME(filterHomographyDecompByVisibleRefpoints(rotations:normals:beforePoints:afterPoints:possibleSolutions:pointsMask:));

/**
 * Filters homography decompositions based on additional information.
 *
 * @param rotations Vector of rotation matrices.
 * @param normals Vector of plane normal matrices.
 * @param beforePoints Vector of (rectified) visible reference points before the homography is applied
 * @param afterPoints Vector of (rectified) visible reference points after the homography is applied
 * @param possibleSolutions Vector of int indices representing the viable solution set after filtering
 * as given by the ``Geometry/findHomography`` function
 *
 * This function is intended to filter the output of the ``Geometry/decomposeHomographyMat`` based on additional
 * information as described in *Cite:* Malis2007 . The summary of the method: the ``Geometry/decomposeHomographyMat`` function
 * returns 2 unique solutions and their "opposites" for a total of 4 solutions. If we have access to the
 * sets of points visible in the camera frame before and after the homography transformation is applied,
 * we can determine which are the true potential solutions and which are the opposites by verifying which
 * homographies are consistent with all visible reference points being in front of the camera. The inputs
 * are left unchanged; the filtered solution set is returned as indices into the existing one.
 */
+ (void)filterHomographyDecompByVisibleRefpoints:(NSArray<Mat*>*)rotations normals:(NSArray<Mat*>*)normals beforePoints:(Mat*)beforePoints afterPoints:(Mat*)afterPoints possibleSolutions:(Mat*)possibleSolutions NS_SWIFT_NAME(filterHomographyDecompByVisibleRefpoints(rotations:normals:beforePoints:afterPoints:possibleSolutions:));


//
//  void cv::calibrationMatrixValues(Mat cameraMatrix, Size imageSize, double apertureWidth, double apertureHeight, double& fovx, double& fovy, double& focalLength, Point2d& principalPoint, double& aspectRatio)
//
/**
 * Computes useful camera characteristics from the camera intrinsic matrix.
 *
 * @param cameraMatrix Input camera intrinsic matrix that can be estimated by #calibrateCamera or
 * #stereoCalibrate .
 * @param imageSize Input image size in pixels.
 * @param apertureWidth Physical width in mm of the sensor.
 * @param apertureHeight Physical height in mm of the sensor.
 * @param fovx Output field of view in degrees along the horizontal sensor axis.
 * @param fovy Output field of view in degrees along the vertical sensor axis.
 * @param focalLength Focal length of the lens in mm.
 * @param principalPoint Principal point in mm.
 * @param aspectRatio `$$f_y/f_x$$`
 *
 * The function computes various useful camera characteristics from the previously estimated camera
 * matrix.
 *
 * *Note:*
 * Do keep in mind that the unity measure 'mm' stands for whatever unit of measure one chooses for
 * the chessboard pitch (it can thus be any value).
 */
+ (void)calibrationMatrixValues:(Mat*)cameraMatrix imageSize:(Size2i*)imageSize apertureWidth:(double)apertureWidth apertureHeight:(double)apertureHeight fovx:(double*)fovx fovy:(double*)fovy focalLength:(double*)focalLength principalPoint:(Point2d*)principalPoint aspectRatio:(double*)aspectRatio NS_SWIFT_NAME(calibrationMatrixValues(cameraMatrix:imageSize:apertureWidth:apertureHeight:fovx:fovy:focalLength:principalPoint:aspectRatio:));


//
//  Mat cv::getDefaultNewCameraMatrix(Mat cameraMatrix, Size imgsize = Size(), bool centerPrincipalPoint = false)
//
/**
 * Returns the default new camera matrix.
 *
 * The function returns the camera matrix that is either an exact copy of the input cameraMatrix (when
 * centerPrinicipalPoint=false ), or the modified one (when centerPrincipalPoint=true).
 *
 * In the latter case, the new camera matrix will be:
 *
 * `$$\begin{bmatrix} f_x && 0 && ( \texttt{imgSize.width} -1)*0.5  \\ 0 && f_y && ( \texttt{imgSize.height} -1)*0.5  \\ 0 && 0 && 1 \end{bmatrix} ,$$`
 *
 * where `$$f_x$$` and `$$f_y$$` are `$$(0,0)$$` and `$$(1,1)$$` elements of cameraMatrix, respectively.
 *
 * By default, the undistortion functions in OpenCV (see #initUndistortRectifyMap, #undistort) do not
 * move the principal point. However, when you work with stereo, it is important to move the principal
 * points in both views to the same y-coordinate (which is required by most of stereo correspondence
 * algorithms), and may be to the same x-coordinate too. So, you can form the new camera matrix for
 * each view where the principal points are located at the center.
 *
 * @param cameraMatrix Input camera matrix.
 * @param imgsize Camera view image size in pixels.
 * @param centerPrincipalPoint Location of the principal point in the new camera matrix. The
 * parameter indicates whether this location should be at the image center or not.
 */
+ (Mat*)getDefaultNewCameraMatrix:(Mat*)cameraMatrix imgsize:(Size2i*)imgsize centerPrincipalPoint:(BOOL)centerPrincipalPoint NS_SWIFT_NAME(getDefaultNewCameraMatrix(cameraMatrix:imgsize:centerPrincipalPoint:));

/**
 * Returns the default new camera matrix.
 *
 * The function returns the camera matrix that is either an exact copy of the input cameraMatrix (when
 * centerPrinicipalPoint=false ), or the modified one (when centerPrincipalPoint=true).
 *
 * In the latter case, the new camera matrix will be:
 *
 * `$$\begin{bmatrix} f_x && 0 && ( \texttt{imgSize.width} -1)*0.5  \\ 0 && f_y && ( \texttt{imgSize.height} -1)*0.5  \\ 0 && 0 && 1 \end{bmatrix} ,$$`
 *
 * where `$$f_x$$` and `$$f_y$$` are `$$(0,0)$$` and `$$(1,1)$$` elements of cameraMatrix, respectively.
 *
 * By default, the undistortion functions in OpenCV (see #initUndistortRectifyMap, #undistort) do not
 * move the principal point. However, when you work with stereo, it is important to move the principal
 * points in both views to the same y-coordinate (which is required by most of stereo correspondence
 * algorithms), and may be to the same x-coordinate too. So, you can form the new camera matrix for
 * each view where the principal points are located at the center.
 *
 * @param cameraMatrix Input camera matrix.
 * @param imgsize Camera view image size in pixels.
 * parameter indicates whether this location should be at the image center or not.
 */
+ (Mat*)getDefaultNewCameraMatrix:(Mat*)cameraMatrix imgsize:(Size2i*)imgsize NS_SWIFT_NAME(getDefaultNewCameraMatrix(cameraMatrix:imgsize:));

/**
 * Returns the default new camera matrix.
 *
 * The function returns the camera matrix that is either an exact copy of the input cameraMatrix (when
 * centerPrinicipalPoint=false ), or the modified one (when centerPrincipalPoint=true).
 *
 * In the latter case, the new camera matrix will be:
 *
 * `$$\begin{bmatrix} f_x && 0 && ( \texttt{imgSize.width} -1)*0.5  \\ 0 && f_y && ( \texttt{imgSize.height} -1)*0.5  \\ 0 && 0 && 1 \end{bmatrix} ,$$`
 *
 * where `$$f_x$$` and `$$f_y$$` are `$$(0,0)$$` and `$$(1,1)$$` elements of cameraMatrix, respectively.
 *
 * By default, the undistortion functions in OpenCV (see #initUndistortRectifyMap, #undistort) do not
 * move the principal point. However, when you work with stereo, it is important to move the principal
 * points in both views to the same y-coordinate (which is required by most of stereo correspondence
 * algorithms), and may be to the same x-coordinate too. So, you can form the new camera matrix for
 * each view where the principal points are located at the center.
 *
 * @param cameraMatrix Input camera matrix.
 * parameter indicates whether this location should be at the image center or not.
 */
+ (Mat*)getDefaultNewCameraMatrix:(Mat*)cameraMatrix NS_SWIFT_NAME(getDefaultNewCameraMatrix(cameraMatrix:));


//
//  Mat cv::getOptimalNewCameraMatrix(Mat cameraMatrix, Mat distCoeffs, Size imageSize, double alpha, Size newImgSize = Size(), Rect* validPixROI = 0, bool centerPrincipalPoint = false)
//
/**
 * Returns the new camera intrinsic matrix based on the free scaling parameter.
 *
 * @param cameraMatrix Input camera intrinsic matrix.
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param imageSize Original image size.
 * @param alpha Free scaling parameter between 0 (when all the pixels in the undistorted image are
 * valid) and 1 (when all the source image pixels are retained in the undistorted image). See
 * #stereoRectify for details.
 * @param newImgSize Image size after rectification. By default, it is set to imageSize .
 * @param validPixROI Optional output rectangle that outlines all-good-pixels region in the
 * undistorted image. See roi1, roi2 description in #stereoRectify .
 * @param centerPrincipalPoint Optional flag that indicates whether in the new camera intrinsic matrix the
 * principal point should be at the image center or not. By default, the principal point is chosen to
 * best fit a subset of the source image (determined by alpha) to the corrected image.
 * @return new_camera_matrix Output new camera intrinsic matrix.
 *
 * The function computes and returns the optimal new camera intrinsic matrix based on the free scaling parameter.
 * By varying this parameter, you may retrieve only sensible pixels alpha=0 , keep all the original
 * image pixels if there is valuable information in the corners alpha=1 , or get something in between.
 * When alpha\>0 , the undistorted result is likely to have some black pixels corresponding to
 * "virtual" pixels outside of the captured distorted image. The original camera intrinsic matrix, distortion
 * coefficients, the computed new camera intrinsic matrix, and newImageSize should be passed to
 * #initUndistortRectifyMap to produce the maps for #remap .
 */
+ (Mat*)getOptimalNewCameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imageSize:(Size2i*)imageSize alpha:(double)alpha newImgSize:(Size2i*)newImgSize validPixROI:(Rect2i*)validPixROI centerPrincipalPoint:(BOOL)centerPrincipalPoint NS_SWIFT_NAME(getOptimalNewCameraMatrix(cameraMatrix:distCoeffs:imageSize:alpha:newImgSize:validPixROI:centerPrincipalPoint:));

/**
 * Returns the new camera intrinsic matrix based on the free scaling parameter.
 *
 * @param cameraMatrix Input camera intrinsic matrix.
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param imageSize Original image size.
 * @param alpha Free scaling parameter between 0 (when all the pixels in the undistorted image are
 * valid) and 1 (when all the source image pixels are retained in the undistorted image). See
 * #stereoRectify for details.
 * @param newImgSize Image size after rectification. By default, it is set to imageSize .
 * @param validPixROI Optional output rectangle that outlines all-good-pixels region in the
 * undistorted image. See roi1, roi2 description in #stereoRectify .
 * principal point should be at the image center or not. By default, the principal point is chosen to
 * best fit a subset of the source image (determined by alpha) to the corrected image.
 * @return new_camera_matrix Output new camera intrinsic matrix.
 *
 * The function computes and returns the optimal new camera intrinsic matrix based on the free scaling parameter.
 * By varying this parameter, you may retrieve only sensible pixels alpha=0 , keep all the original
 * image pixels if there is valuable information in the corners alpha=1 , or get something in between.
 * When alpha\>0 , the undistorted result is likely to have some black pixels corresponding to
 * "virtual" pixels outside of the captured distorted image. The original camera intrinsic matrix, distortion
 * coefficients, the computed new camera intrinsic matrix, and newImageSize should be passed to
 * #initUndistortRectifyMap to produce the maps for #remap .
 */
+ (Mat*)getOptimalNewCameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imageSize:(Size2i*)imageSize alpha:(double)alpha newImgSize:(Size2i*)newImgSize validPixROI:(Rect2i*)validPixROI NS_SWIFT_NAME(getOptimalNewCameraMatrix(cameraMatrix:distCoeffs:imageSize:alpha:newImgSize:validPixROI:));

/**
 * Returns the new camera intrinsic matrix based on the free scaling parameter.
 *
 * @param cameraMatrix Input camera intrinsic matrix.
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param imageSize Original image size.
 * @param alpha Free scaling parameter between 0 (when all the pixels in the undistorted image are
 * valid) and 1 (when all the source image pixels are retained in the undistorted image). See
 * #stereoRectify for details.
 * @param newImgSize Image size after rectification. By default, it is set to imageSize .
 * undistorted image. See roi1, roi2 description in #stereoRectify .
 * principal point should be at the image center or not. By default, the principal point is chosen to
 * best fit a subset of the source image (determined by alpha) to the corrected image.
 * @return new_camera_matrix Output new camera intrinsic matrix.
 *
 * The function computes and returns the optimal new camera intrinsic matrix based on the free scaling parameter.
 * By varying this parameter, you may retrieve only sensible pixels alpha=0 , keep all the original
 * image pixels if there is valuable information in the corners alpha=1 , or get something in between.
 * When alpha\>0 , the undistorted result is likely to have some black pixels corresponding to
 * "virtual" pixels outside of the captured distorted image. The original camera intrinsic matrix, distortion
 * coefficients, the computed new camera intrinsic matrix, and newImageSize should be passed to
 * #initUndistortRectifyMap to produce the maps for #remap .
 */
+ (Mat*)getOptimalNewCameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imageSize:(Size2i*)imageSize alpha:(double)alpha newImgSize:(Size2i*)newImgSize NS_SWIFT_NAME(getOptimalNewCameraMatrix(cameraMatrix:distCoeffs:imageSize:alpha:newImgSize:));

/**
 * Returns the new camera intrinsic matrix based on the free scaling parameter.
 *
 * @param cameraMatrix Input camera intrinsic matrix.
 * @param distCoeffs Input vector of distortion coefficients
 * `$$\distcoeffs$$`. If the vector is NULL/empty, the zero distortion coefficients are
 * assumed.
 * @param imageSize Original image size.
 * @param alpha Free scaling parameter between 0 (when all the pixels in the undistorted image are
 * valid) and 1 (when all the source image pixels are retained in the undistorted image). See
 * #stereoRectify for details.
 * undistorted image. See roi1, roi2 description in #stereoRectify .
 * principal point should be at the image center or not. By default, the principal point is chosen to
 * best fit a subset of the source image (determined by alpha) to the corrected image.
 * @return new_camera_matrix Output new camera intrinsic matrix.
 *
 * The function computes and returns the optimal new camera intrinsic matrix based on the free scaling parameter.
 * By varying this parameter, you may retrieve only sensible pixels alpha=0 , keep all the original
 * image pixels if there is valuable information in the corners alpha=1 , or get something in between.
 * When alpha\>0 , the undistorted result is likely to have some black pixels corresponding to
 * "virtual" pixels outside of the captured distorted image. The original camera intrinsic matrix, distortion
 * coefficients, the computed new camera intrinsic matrix, and newImageSize should be passed to
 * #initUndistortRectifyMap to produce the maps for #remap .
 */
+ (Mat*)getOptimalNewCameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs imageSize:(Size2i*)imageSize alpha:(double)alpha NS_SWIFT_NAME(getOptimalNewCameraMatrix(cameraMatrix:distCoeffs:imageSize:alpha:));


//
//  void cv::undistortPoints(Mat src, Mat& dst, Mat cameraMatrix, Mat distCoeffs, Mat R = Mat(), Mat P = Mat(), TermCriteria criteria = TermCriteria(TermCriteria::MAX_ITER, 5, 0.01))
//
/**
 * Computes the ideal point coordinates from the observed point coordinates.
 *
 * The function is similar to #undistort and #initUndistortRectifyMap but it operates on a
 * sparse set of points instead of a raster image. Also the function performs a reverse transformation
 * to  ``Geometry/projectPoints``. In case of a 3D object, it does not reconstruct its 3D coordinates, but for a
 * planar object, it does, up to a translation vector, if the proper R is specified.
 *
 * For each observed point coordinate `$$(u, v)$$` the function computes:
 * `$$
 * \begin{array}{l}
 * x^{"}  \leftarrow (u - c_x)/f_x  \\
 * y^{"}  \leftarrow (v - c_y)/f_y  \\
 * (x',y') = undistort(x^{"},y^{"}, \texttt{distCoeffs}) \\
 * {[X\,Y\,W]} ^T  \leftarrow R*[x' \, y' \, 1]^T  \\
 * x  \leftarrow X/W  \\
 * y  \leftarrow Y/W  \\
 * \text{only performed if P is specified:} \\
 * u'  \leftarrow x {f'}_x + {c'}_x  \\
 * v'  \leftarrow y {f'}_y + {c'}_y
 * \end{array}
 * $$`
 *
 * where *undistort* is an approximate iterative algorithm that estimates the normalized original
 * point coordinates out of the normalized distorted point coordinates ("normalized" means that the
 * coordinates do not depend on the camera matrix).
 *
 * The function can be used for both a stereo camera head or a monocular camera (when R is empty).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`src`)**: Points are expected in **pixel coordinates** of the distorted image, i.e.,
 *   coordinates `$$(u, v)$$` measured in pixels from the top-left corner of the image.
 * - **Output (`dst`)**: The coordinate system of output points depends on parameter `P`:
 *   - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted image plane, using the camera matrix `P`.
 *   - If `P` is empty or identity: Output points are in **normalized camera coordinates** (also called "normalized image coordinates"),
 *     which are dimensionless coordinates `$$(x, y)$$` in the camera's focal plane, related to pixel coordinates by:
 *     `$$x = (u - c_x) / f_x$$` and `$$y = (v - c_y) / f_y$$`. These normalized coordinates are independent of the camera's intrinsic parameters and are useful for 3D reconstruction or epipolar geometry.
 *
 * @param src Observed point coordinates in **pixel coordinates** of the distorted image, 2xN/Nx2 1-channel or 1xN/Nx1 2-channel (CV_32FC2 or CV_64FC2) (or
 * vector\<Point2f\> ).
 * @param dst Output ideal point coordinates (1xN/Nx1 2-channel or vector\<Point2f\> ) after undistortion and reverse perspective
 * transformation. If matrix P is identity or omitted, dst will contain normalized point coordinates.
 * @param cameraMatrix Camera matrix `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param R Rectification transformation in the object space (3x3 matrix). R1 or R2 computed by
 * #stereoRectify can be passed here. If the matrix is empty, the identity transformation is used.
 * @param P New camera matrix (3x3) or new projection matrix (3x4) `$$\begin{bmatrix} {f'}_x & 0 & {c'}_x & t_x \\ 0 & {f'}_y & {c'}_y & t_y \\ 0 & 0 & 1 & t_z \end{bmatrix}$$`. P1 or P2 computed by
 * #stereoRectify can be passed here. If the matrix is empty, the identity new camera matrix is used and output will be in normalized coordinates.
 * @param criteria termination criteria for the iterative point undistortion algorithm
 */
+ (void)undistortPoints:(Mat*)src dst:(Mat*)dst cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs R:(Mat*)R P:(Mat*)P criteria:(TermCriteria*)criteria NS_SWIFT_NAME(undistortPoints(src:dst:cameraMatrix:distCoeffs:R:P:criteria:));

/**
 * Computes the ideal point coordinates from the observed point coordinates.
 *
 * The function is similar to #undistort and #initUndistortRectifyMap but it operates on a
 * sparse set of points instead of a raster image. Also the function performs a reverse transformation
 * to  ``Geometry/projectPoints``. In case of a 3D object, it does not reconstruct its 3D coordinates, but for a
 * planar object, it does, up to a translation vector, if the proper R is specified.
 *
 * For each observed point coordinate `$$(u, v)$$` the function computes:
 * `$$
 * \begin{array}{l}
 * x^{"}  \leftarrow (u - c_x)/f_x  \\
 * y^{"}  \leftarrow (v - c_y)/f_y  \\
 * (x',y') = undistort(x^{"},y^{"}, \texttt{distCoeffs}) \\
 * {[X\,Y\,W]} ^T  \leftarrow R*[x' \, y' \, 1]^T  \\
 * x  \leftarrow X/W  \\
 * y  \leftarrow Y/W  \\
 * \text{only performed if P is specified:} \\
 * u'  \leftarrow x {f'}_x + {c'}_x  \\
 * v'  \leftarrow y {f'}_y + {c'}_y
 * \end{array}
 * $$`
 *
 * where *undistort* is an approximate iterative algorithm that estimates the normalized original
 * point coordinates out of the normalized distorted point coordinates ("normalized" means that the
 * coordinates do not depend on the camera matrix).
 *
 * The function can be used for both a stereo camera head or a monocular camera (when R is empty).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`src`)**: Points are expected in **pixel coordinates** of the distorted image, i.e.,
 *   coordinates `$$(u, v)$$` measured in pixels from the top-left corner of the image.
 * - **Output (`dst`)**: The coordinate system of output points depends on parameter `P`:
 *   - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted image plane, using the camera matrix `P`.
 *   - If `P` is empty or identity: Output points are in **normalized camera coordinates** (also called "normalized image coordinates"),
 *     which are dimensionless coordinates `$$(x, y)$$` in the camera's focal plane, related to pixel coordinates by:
 *     `$$x = (u - c_x) / f_x$$` and `$$y = (v - c_y) / f_y$$`. These normalized coordinates are independent of the camera's intrinsic parameters and are useful for 3D reconstruction or epipolar geometry.
 *
 * @param src Observed point coordinates in **pixel coordinates** of the distorted image, 2xN/Nx2 1-channel or 1xN/Nx1 2-channel (CV_32FC2 or CV_64FC2) (or
 * vector\<Point2f\> ).
 * @param dst Output ideal point coordinates (1xN/Nx1 2-channel or vector\<Point2f\> ) after undistortion and reverse perspective
 * transformation. If matrix P is identity or omitted, dst will contain normalized point coordinates.
 * @param cameraMatrix Camera matrix `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param R Rectification transformation in the object space (3x3 matrix). R1 or R2 computed by
 * #stereoRectify can be passed here. If the matrix is empty, the identity transformation is used.
 * @param P New camera matrix (3x3) or new projection matrix (3x4) `$$\begin{bmatrix} {f'}_x & 0 & {c'}_x & t_x \\ 0 & {f'}_y & {c'}_y & t_y \\ 0 & 0 & 1 & t_z \end{bmatrix}$$`. P1 or P2 computed by
 * #stereoRectify can be passed here. If the matrix is empty, the identity new camera matrix is used and output will be in normalized coordinates.
 */
+ (void)undistortPoints:(Mat*)src dst:(Mat*)dst cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs R:(Mat*)R P:(Mat*)P NS_SWIFT_NAME(undistortPoints(src:dst:cameraMatrix:distCoeffs:R:P:));

/**
 * Computes the ideal point coordinates from the observed point coordinates.
 *
 * The function is similar to #undistort and #initUndistortRectifyMap but it operates on a
 * sparse set of points instead of a raster image. Also the function performs a reverse transformation
 * to  ``Geometry/projectPoints``. In case of a 3D object, it does not reconstruct its 3D coordinates, but for a
 * planar object, it does, up to a translation vector, if the proper R is specified.
 *
 * For each observed point coordinate `$$(u, v)$$` the function computes:
 * `$$
 * \begin{array}{l}
 * x^{"}  \leftarrow (u - c_x)/f_x  \\
 * y^{"}  \leftarrow (v - c_y)/f_y  \\
 * (x',y') = undistort(x^{"},y^{"}, \texttt{distCoeffs}) \\
 * {[X\,Y\,W]} ^T  \leftarrow R*[x' \, y' \, 1]^T  \\
 * x  \leftarrow X/W  \\
 * y  \leftarrow Y/W  \\
 * \text{only performed if P is specified:} \\
 * u'  \leftarrow x {f'}_x + {c'}_x  \\
 * v'  \leftarrow y {f'}_y + {c'}_y
 * \end{array}
 * $$`
 *
 * where *undistort* is an approximate iterative algorithm that estimates the normalized original
 * point coordinates out of the normalized distorted point coordinates ("normalized" means that the
 * coordinates do not depend on the camera matrix).
 *
 * The function can be used for both a stereo camera head or a monocular camera (when R is empty).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`src`)**: Points are expected in **pixel coordinates** of the distorted image, i.e.,
 *   coordinates `$$(u, v)$$` measured in pixels from the top-left corner of the image.
 * - **Output (`dst`)**: The coordinate system of output points depends on parameter `P`:
 *   - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted image plane, using the camera matrix `P`.
 *   - If `P` is empty or identity: Output points are in **normalized camera coordinates** (also called "normalized image coordinates"),
 *     which are dimensionless coordinates `$$(x, y)$$` in the camera's focal plane, related to pixel coordinates by:
 *     `$$x = (u - c_x) / f_x$$` and `$$y = (v - c_y) / f_y$$`. These normalized coordinates are independent of the camera's intrinsic parameters and are useful for 3D reconstruction or epipolar geometry.
 *
 * @param src Observed point coordinates in **pixel coordinates** of the distorted image, 2xN/Nx2 1-channel or 1xN/Nx1 2-channel (CV_32FC2 or CV_64FC2) (or
 * vector\<Point2f\> ).
 * @param dst Output ideal point coordinates (1xN/Nx1 2-channel or vector\<Point2f\> ) after undistortion and reverse perspective
 * transformation. If matrix P is identity or omitted, dst will contain normalized point coordinates.
 * @param cameraMatrix Camera matrix `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * @param R Rectification transformation in the object space (3x3 matrix). R1 or R2 computed by
 * #stereoRectify can be passed here. If the matrix is empty, the identity transformation is used.
 * #stereoRectify can be passed here. If the matrix is empty, the identity new camera matrix is used and output will be in normalized coordinates.
 */
+ (void)undistortPoints:(Mat*)src dst:(Mat*)dst cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs R:(Mat*)R NS_SWIFT_NAME(undistortPoints(src:dst:cameraMatrix:distCoeffs:R:));

/**
 * Computes the ideal point coordinates from the observed point coordinates.
 *
 * The function is similar to #undistort and #initUndistortRectifyMap but it operates on a
 * sparse set of points instead of a raster image. Also the function performs a reverse transformation
 * to  ``Geometry/projectPoints``. In case of a 3D object, it does not reconstruct its 3D coordinates, but for a
 * planar object, it does, up to a translation vector, if the proper R is specified.
 *
 * For each observed point coordinate `$$(u, v)$$` the function computes:
 * `$$
 * \begin{array}{l}
 * x^{"}  \leftarrow (u - c_x)/f_x  \\
 * y^{"}  \leftarrow (v - c_y)/f_y  \\
 * (x',y') = undistort(x^{"},y^{"}, \texttt{distCoeffs}) \\
 * {[X\,Y\,W]} ^T  \leftarrow R*[x' \, y' \, 1]^T  \\
 * x  \leftarrow X/W  \\
 * y  \leftarrow Y/W  \\
 * \text{only performed if P is specified:} \\
 * u'  \leftarrow x {f'}_x + {c'}_x  \\
 * v'  \leftarrow y {f'}_y + {c'}_y
 * \end{array}
 * $$`
 *
 * where *undistort* is an approximate iterative algorithm that estimates the normalized original
 * point coordinates out of the normalized distorted point coordinates ("normalized" means that the
 * coordinates do not depend on the camera matrix).
 *
 * The function can be used for both a stereo camera head or a monocular camera (when R is empty).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`src`)**: Points are expected in **pixel coordinates** of the distorted image, i.e.,
 *   coordinates `$$(u, v)$$` measured in pixels from the top-left corner of the image.
 * - **Output (`dst`)**: The coordinate system of output points depends on parameter `P`:
 *   - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted image plane, using the camera matrix `P`.
 *   - If `P` is empty or identity: Output points are in **normalized camera coordinates** (also called "normalized image coordinates"),
 *     which are dimensionless coordinates `$$(x, y)$$` in the camera's focal plane, related to pixel coordinates by:
 *     `$$x = (u - c_x) / f_x$$` and `$$y = (v - c_y) / f_y$$`. These normalized coordinates are independent of the camera's intrinsic parameters and are useful for 3D reconstruction or epipolar geometry.
 *
 * @param src Observed point coordinates in **pixel coordinates** of the distorted image, 2xN/Nx2 1-channel or 1xN/Nx1 2-channel (CV_32FC2 or CV_64FC2) (or
 * vector\<Point2f\> ).
 * @param dst Output ideal point coordinates (1xN/Nx1 2-channel or vector\<Point2f\> ) after undistortion and reverse perspective
 * transformation. If matrix P is identity or omitted, dst will contain normalized point coordinates.
 * @param cameraMatrix Camera matrix `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs Input vector of distortion coefficients
 * `$$(k_1, k_2, p_1, p_2[, k_3[, k_4, k_5, k_6[, s_1, s_2, s_3, s_4[, \tau_x, \tau_y]]]])$$`
 * of 4, 5, 8, 12 or 14 elements. If the vector is NULL/empty, the zero distortion coefficients are assumed.
 * #stereoRectify can be passed here. If the matrix is empty, the identity transformation is used.
 * #stereoRectify can be passed here. If the matrix is empty, the identity new camera matrix is used and output will be in normalized coordinates.
 */
+ (void)undistortPoints:(Mat*)src dst:(Mat*)dst cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs NS_SWIFT_NAME(undistortPoints(src:dst:cameraMatrix:distCoeffs:));


//
//  void cv::undistortImagePoints(Mat src, Mat& dst, Mat cameraMatrix, Mat distCoeffs, TermCriteria arg1 = TermCriteria(TermCriteria::MAX_ITER, 5, 0.01))
//
/**
 * Compute undistorted image points position
 *
 * @param src Observed points position, 2xN/Nx2 1-channel or 1xN/Nx1 2-channel (CV_32FC2 or CV_64FC2) (or vector\<Point2f\> ).
 * @param dst Output undistorted points position (1xN/Nx1 2-channel or vector\<Point2f\> ).
 * @param cameraMatrix Camera matrix `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs Distortion coefficients
 */
+ (void)undistortImagePoints:(Mat*)src dst:(Mat*)dst cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs arg1:(TermCriteria*)arg1 NS_SWIFT_NAME(undistortImagePoints(src:dst:cameraMatrix:distCoeffs:arg1:));

/**
 * Compute undistorted image points position
 *
 * @param src Observed points position, 2xN/Nx2 1-channel or 1xN/Nx1 2-channel (CV_32FC2 or CV_64FC2) (or vector\<Point2f\> ).
 * @param dst Output undistorted points position (1xN/Nx1 2-channel or vector\<Point2f\> ).
 * @param cameraMatrix Camera matrix `$$\newcommand{\vecthreethree}[9]{ \begin{bmatrix} #1 & #2 & #3\\\\ #4 & #5 & #6\\\\ #7 & #8 & #9 \end{bmatrix} } \vecthreethree{f_x}{0}{c_x}{0}{f_y}{c_y}{0}{0}{1}$$` .
 * @param distCoeffs Distortion coefficients
 */
+ (void)undistortImagePoints:(Mat*)src dst:(Mat*)dst cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs NS_SWIFT_NAME(undistortImagePoints(src:dst:cameraMatrix:distCoeffs:));


//
//  void cv::fisheye::projectPoints(Mat objectPoints, Mat& imagePoints, Mat rvec, Mat tvec, Mat K, Mat D, double alpha = 0, Mat& jacobian = Mat())
//
+ (void)fisheye_projectPoints:(Mat*)objectPoints imagePoints:(Mat*)imagePoints rvec:(Mat*)rvec tvec:(Mat*)tvec K:(Mat*)K D:(Mat*)D alpha:(double)alpha jacobian:(Mat*)jacobian NS_SWIFT_NAME(fisheye_projectPoints(objectPoints:imagePoints:rvec:tvec:K:D:alpha:jacobian:));

+ (void)fisheye_projectPoints:(Mat*)objectPoints imagePoints:(Mat*)imagePoints rvec:(Mat*)rvec tvec:(Mat*)tvec K:(Mat*)K D:(Mat*)D alpha:(double)alpha NS_SWIFT_NAME(fisheye_projectPoints(objectPoints:imagePoints:rvec:tvec:K:D:alpha:));

+ (void)fisheye_projectPoints:(Mat*)objectPoints imagePoints:(Mat*)imagePoints rvec:(Mat*)rvec tvec:(Mat*)tvec K:(Mat*)K D:(Mat*)D NS_SWIFT_NAME(fisheye_projectPoints(objectPoints:imagePoints:rvec:tvec:K:D:));


//
//  void cv::fisheye::distortPoints(Mat undistorted, Mat& distorted, Mat K, Mat D, double alpha = 0)
//
/**
 * Distorts 2D points using fisheye model.
 *
 * @param undistorted Array of object points, 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is
 * the number of points in the view.
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param alpha The skew coefficient.
 * @param distorted Output array of image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 *
 * Note that the function assumes the camera intrinsic matrix of the undistorted points to be identity.
 * This means if you want to distort image points you have to multiply them with `$$K^{-1}$$` or
 * use another function overload.
 */
+ (void)fisheye_distortPoints:(Mat*)undistorted distorted:(Mat*)distorted K:(Mat*)K D:(Mat*)D alpha:(double)alpha NS_SWIFT_NAME(fisheye_distortPoints(undistorted:distorted:K:D:alpha:));

/**
 * Distorts 2D points using fisheye model.
 *
 * @param undistorted Array of object points, 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is
 * the number of points in the view.
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param distorted Output array of image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 *
 * Note that the function assumes the camera intrinsic matrix of the undistorted points to be identity.
 * This means if you want to distort image points you have to multiply them with `$$K^{-1}$$` or
 * use another function overload.
 */
+ (void)fisheye_distortPoints:(Mat*)undistorted distorted:(Mat*)distorted K:(Mat*)K D:(Mat*)D NS_SWIFT_NAME(fisheye_distortPoints(undistorted:distorted:K:D:));


//
//  void cv::fisheye::distortPoints(Mat undistorted, Mat& distorted, Mat Kundistorted, Mat K, Mat D, double alpha = 0)
//
/**
 *
 * Overload of distortPoints function to handle cases when undistorted points are got with non-identity
 * camera matrix, e.g. output of #estimateNewCameraMatrixForUndistortRectify.
 * @param undistorted Array of object points, 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is
 * the number of points in the view.
 * @param Kundistorted Camera intrinsic matrix used as new camera matrix for undistortion.
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param alpha The skew coefficient.
 * @param distorted Output array of image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 *
 * - SeeAlso estimateNewCameraMatrixForUndistortRectify
 */
+ (void)fisheye_distortPoints:(Mat*)undistorted distorted:(Mat*)distorted Kundistorted:(Mat*)Kundistorted K:(Mat*)K D:(Mat*)D alpha:(double)alpha NS_SWIFT_NAME(fisheye_distortPoints(undistorted:distorted:Kundistorted:K:D:alpha:));

/**
 *
 * Overload of distortPoints function to handle cases when undistorted points are got with non-identity
 * camera matrix, e.g. output of #estimateNewCameraMatrixForUndistortRectify.
 * @param undistorted Array of object points, 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is
 * the number of points in the view.
 * @param Kundistorted Camera intrinsic matrix used as new camera matrix for undistortion.
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param distorted Output array of image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 *
 * - SeeAlso estimateNewCameraMatrixForUndistortRectify
 */
+ (void)fisheye_distortPoints:(Mat*)undistorted distorted:(Mat*)distorted Kundistorted:(Mat*)Kundistorted K:(Mat*)K D:(Mat*)D NS_SWIFT_NAME(fisheye_distortPoints(undistorted:distorted:Kundistorted:K:D:));


//
//  void cv::fisheye::undistortPoints(Mat distorted, Mat& undistorted, Mat K, Mat D, Mat R = Mat(), Mat P = Mat(), TermCriteria criteria = TermCriteria(TermCriteria::MAX_ITER + TermCriteria::EPS, 10, 1e-8))
//
/**
 * Undistorts 2D points using fisheye camera model
 *
 * This function performs undistortion for fisheye camera models, which use a different distortion model
 * compared to the standard pinhole camera model used by *undistortPoints*. The fisheye model is suitable
 * for wide-angle cameras.
 *
 * The function transforms points from the distorted fisheye image to undistorted coordinates, optionally
 * applying a rectification transformation (R) and projecting to a new image plane (P).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`distorted`)**: Points are expected in **pixel coordinates** of the distorted fisheye image,
 *     i.e., coordinates measured in pixels from the top-left corner of the image.
 * - **Output (`undistorted`)**: The coordinate system depends on parameter `P`:
 *     - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted
 *     image plane, using the camera matrix `P`.
 *     - If `P` is empty or identity: Output points are in **normalized camera coordinates** (normalized image coordinates),
 *     which are dimensionless coordinates in the camera's focal plane, independent of intrinsic parameters.
 *
 * Note:* **Fisheye vs. Standard Model:**
 * Use this function (#cv::fisheye::undistortPoints) for fisheye cameras (wide-angle lenses).
 * For standard pinhole cameras, use *undistortPoints* instead. The fisheye model uses a different distortion
 * parameterization (4 coefficients) compared to the standard model (4-14 coefficients).
 *
 * @param distorted Array of distorted point coordinates in **pixel coordinates** of the fisheye image,
 * 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is the number of points in the view.
 * @param K Camera intrinsic matrix `$$\cameramatrix{K}$$` of the fisheye camera.
 * @param D Input vector of fisheye distortion coefficients `$$\distcoeffsfisheye$$` (must contain exactly 4 coefficients).
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel. If empty, the identity transformation is used.
 * @param P New camera intrinsic matrix (3x3) or new projection matrix (3x4). If empty or identity,
 * output will be in normalized camera coordinates.
 * @param criteria Termination criteria for the iterative undistortion algorithm.
 * @param undistorted Output array of undistorted image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 * The coordinate system depends on parameter P (see above).
 */
+ (void)fisheye_undistortPoints:(Mat*)distorted undistorted:(Mat*)undistorted K:(Mat*)K D:(Mat*)D R:(Mat*)R P:(Mat*)P criteria:(TermCriteria*)criteria NS_SWIFT_NAME(fisheye_undistortPoints(distorted:undistorted:K:D:R:P:criteria:));

/**
 * Undistorts 2D points using fisheye camera model
 *
 * This function performs undistortion for fisheye camera models, which use a different distortion model
 * compared to the standard pinhole camera model used by *undistortPoints*. The fisheye model is suitable
 * for wide-angle cameras.
 *
 * The function transforms points from the distorted fisheye image to undistorted coordinates, optionally
 * applying a rectification transformation (R) and projecting to a new image plane (P).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`distorted`)**: Points are expected in **pixel coordinates** of the distorted fisheye image,
 *     i.e., coordinates measured in pixels from the top-left corner of the image.
 * - **Output (`undistorted`)**: The coordinate system depends on parameter `P`:
 *     - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted
 *     image plane, using the camera matrix `P`.
 *     - If `P` is empty or identity: Output points are in **normalized camera coordinates** (normalized image coordinates),
 *     which are dimensionless coordinates in the camera's focal plane, independent of intrinsic parameters.
 *
 * Note:* **Fisheye vs. Standard Model:**
 * Use this function (#cv::fisheye::undistortPoints) for fisheye cameras (wide-angle lenses).
 * For standard pinhole cameras, use *undistortPoints* instead. The fisheye model uses a different distortion
 * parameterization (4 coefficients) compared to the standard model (4-14 coefficients).
 *
 * @param distorted Array of distorted point coordinates in **pixel coordinates** of the fisheye image,
 * 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is the number of points in the view.
 * @param K Camera intrinsic matrix `$$\cameramatrix{K}$$` of the fisheye camera.
 * @param D Input vector of fisheye distortion coefficients `$$\distcoeffsfisheye$$` (must contain exactly 4 coefficients).
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel. If empty, the identity transformation is used.
 * @param P New camera intrinsic matrix (3x3) or new projection matrix (3x4). If empty or identity,
 * output will be in normalized camera coordinates.
 * @param undistorted Output array of undistorted image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 * The coordinate system depends on parameter P (see above).
 */
+ (void)fisheye_undistortPoints:(Mat*)distorted undistorted:(Mat*)undistorted K:(Mat*)K D:(Mat*)D R:(Mat*)R P:(Mat*)P NS_SWIFT_NAME(fisheye_undistortPoints(distorted:undistorted:K:D:R:P:));

/**
 * Undistorts 2D points using fisheye camera model
 *
 * This function performs undistortion for fisheye camera models, which use a different distortion model
 * compared to the standard pinhole camera model used by *undistortPoints*. The fisheye model is suitable
 * for wide-angle cameras.
 *
 * The function transforms points from the distorted fisheye image to undistorted coordinates, optionally
 * applying a rectification transformation (R) and projecting to a new image plane (P).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`distorted`)**: Points are expected in **pixel coordinates** of the distorted fisheye image,
 *     i.e., coordinates measured in pixels from the top-left corner of the image.
 * - **Output (`undistorted`)**: The coordinate system depends on parameter `P`:
 *     - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted
 *     image plane, using the camera matrix `P`.
 *     - If `P` is empty or identity: Output points are in **normalized camera coordinates** (normalized image coordinates),
 *     which are dimensionless coordinates in the camera's focal plane, independent of intrinsic parameters.
 *
 * Note:* **Fisheye vs. Standard Model:**
 * Use this function (#cv::fisheye::undistortPoints) for fisheye cameras (wide-angle lenses).
 * For standard pinhole cameras, use *undistortPoints* instead. The fisheye model uses a different distortion
 * parameterization (4 coefficients) compared to the standard model (4-14 coefficients).
 *
 * @param distorted Array of distorted point coordinates in **pixel coordinates** of the fisheye image,
 * 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is the number of points in the view.
 * @param K Camera intrinsic matrix `$$\cameramatrix{K}$$` of the fisheye camera.
 * @param D Input vector of fisheye distortion coefficients `$$\distcoeffsfisheye$$` (must contain exactly 4 coefficients).
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel. If empty, the identity transformation is used.
 * output will be in normalized camera coordinates.
 * @param undistorted Output array of undistorted image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 * The coordinate system depends on parameter P (see above).
 */
+ (void)fisheye_undistortPoints:(Mat*)distorted undistorted:(Mat*)undistorted K:(Mat*)K D:(Mat*)D R:(Mat*)R NS_SWIFT_NAME(fisheye_undistortPoints(distorted:undistorted:K:D:R:));

/**
 * Undistorts 2D points using fisheye camera model
 *
 * This function performs undistortion for fisheye camera models, which use a different distortion model
 * compared to the standard pinhole camera model used by *undistortPoints*. The fisheye model is suitable
 * for wide-angle cameras.
 *
 * The function transforms points from the distorted fisheye image to undistorted coordinates, optionally
 * applying a rectification transformation (R) and projecting to a new image plane (P).
 *
 * Note:* **Coordinate Systems:**
 * - **Input (`distorted`)**: Points are expected in **pixel coordinates** of the distorted fisheye image,
 *     i.e., coordinates measured in pixels from the top-left corner of the image.
 * - **Output (`undistorted`)**: The coordinate system depends on parameter `P`:
 *     - If `P` is provided (not empty): Output points are in **pixel coordinates** of the rectified/undistorted
 *     image plane, using the camera matrix `P`.
 *     - If `P` is empty or identity: Output points are in **normalized camera coordinates** (normalized image coordinates),
 *     which are dimensionless coordinates in the camera's focal plane, independent of intrinsic parameters.
 *
 * Note:* **Fisheye vs. Standard Model:**
 * Use this function (#cv::fisheye::undistortPoints) for fisheye cameras (wide-angle lenses).
 * For standard pinhole cameras, use *undistortPoints* instead. The fisheye model uses a different distortion
 * parameterization (4 coefficients) compared to the standard model (4-14 coefficients).
 *
 * @param distorted Array of distorted point coordinates in **pixel coordinates** of the fisheye image,
 * 1xN/Nx1 2-channel (or vector\<Point2f\> ), where N is the number of points in the view.
 * @param K Camera intrinsic matrix `$$\cameramatrix{K}$$` of the fisheye camera.
 * @param D Input vector of fisheye distortion coefficients `$$\distcoeffsfisheye$$` (must contain exactly 4 coefficients).
 * 1-channel or 1x1 3-channel. If empty, the identity transformation is used.
 * output will be in normalized camera coordinates.
 * @param undistorted Output array of undistorted image points, 1xN/Nx1 2-channel, or vector\<Point2f\> .
 * The coordinate system depends on parameter P (see above).
 */
+ (void)fisheye_undistortPoints:(Mat*)distorted undistorted:(Mat*)undistorted K:(Mat*)K D:(Mat*)D NS_SWIFT_NAME(fisheye_undistortPoints(distorted:undistorted:K:D:));


//
//  void cv::fisheye::estimateNewCameraMatrixForUndistortRectify(Mat K, Mat D, Size image_size, Mat R, Mat& P, double balance = 0.0, Size new_size = Size(), double fov_scale = 1.0)
//
/**
 * Estimates new camera intrinsic matrix for undistortion or rectification.
 *
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param image_size Size of the image
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel
 * @param P New camera intrinsic matrix (3x3) or new projection matrix (3x4)
 * @param balance Sets the new focal length in range between the min focal length and the max focal
 * length. Balance is in range of [0, 1].
 * @param new_size the new size
 * @param fov_scale Divisor for new focal length.
 */
+ (void)fisheye_estimateNewCameraMatrixForUndistortRectify:(Mat*)K D:(Mat*)D image_size:(Size2i*)image_size R:(Mat*)R P:(Mat*)P balance:(double)balance new_size:(Size2i*)new_size fov_scale:(double)fov_scale NS_SWIFT_NAME(fisheye_estimateNewCameraMatrixForUndistortRectify(K:D:image_size:R:P:balance:new_size:fov_scale:));

/**
 * Estimates new camera intrinsic matrix for undistortion or rectification.
 *
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param image_size Size of the image
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel
 * @param P New camera intrinsic matrix (3x3) or new projection matrix (3x4)
 * @param balance Sets the new focal length in range between the min focal length and the max focal
 * length. Balance is in range of [0, 1].
 * @param new_size the new size
 */
+ (void)fisheye_estimateNewCameraMatrixForUndistortRectify:(Mat*)K D:(Mat*)D image_size:(Size2i*)image_size R:(Mat*)R P:(Mat*)P balance:(double)balance new_size:(Size2i*)new_size NS_SWIFT_NAME(fisheye_estimateNewCameraMatrixForUndistortRectify(K:D:image_size:R:P:balance:new_size:));

/**
 * Estimates new camera intrinsic matrix for undistortion or rectification.
 *
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param image_size Size of the image
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel
 * @param P New camera intrinsic matrix (3x3) or new projection matrix (3x4)
 * @param balance Sets the new focal length in range between the min focal length and the max focal
 * length. Balance is in range of [0, 1].
 */
+ (void)fisheye_estimateNewCameraMatrixForUndistortRectify:(Mat*)K D:(Mat*)D image_size:(Size2i*)image_size R:(Mat*)R P:(Mat*)P balance:(double)balance NS_SWIFT_NAME(fisheye_estimateNewCameraMatrixForUndistortRectify(K:D:image_size:R:P:balance:));

/**
 * Estimates new camera intrinsic matrix for undistortion or rectification.
 *
 * @param K Camera intrinsic matrix `$$cameramatrix{K}$$`.
 * @param image_size Size of the image
 * @param D Input vector of distortion coefficients `$$\distcoeffsfisheye$$`.
 * @param R Rectification transformation in the object space: 3x3 1-channel, or vector: 3x1/1x3
 * 1-channel or 1x1 3-channel
 * @param P New camera intrinsic matrix (3x3) or new projection matrix (3x4)
 * length. Balance is in range of [0, 1].
 */
+ (void)fisheye_estimateNewCameraMatrixForUndistortRectify:(Mat*)K D:(Mat*)D image_size:(Size2i*)image_size R:(Mat*)R P:(Mat*)P NS_SWIFT_NAME(fisheye_estimateNewCameraMatrixForUndistortRectify(K:D:image_size:R:P:));


//
//  bool cv::fisheye::solvePnP(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, bool useExtrinsicGuess = false, int flags = SOLVEPNP_ITERATIVE, TermCriteria criteria = TermCriteria(TermCriteria::MAX_ITER + TermCriteria::EPS, 10, 1e-8))
//
/**
 * Finds an object pose from 3D-2D point correspondences for fisheye camera model.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 * - point 0: [-squareLength / 2,  squareLength / 2, 0]
 * - point 1: [ squareLength / 2,  squareLength / 2, 0]
 * - point 2: [ squareLength / 2, -squareLength / 2, 0]
 * - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * @param criteria Termination criteria for internal undistortPoints call.
 * The function internally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. Check there and Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags criteria:(TermCriteria*)criteria NS_SWIFT_NAME(fisheye_solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:flags:criteria:));

/**
 * Finds an object pose from 3D-2D point correspondences for fisheye camera model.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 * - point 0: [-squareLength / 2,  squareLength / 2, 0]
 * - point 1: [ squareLength / 2,  squareLength / 2, 0]
 * - point 2: [ squareLength / 2, -squareLength / 2, 0]
 * - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * The function internally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. Check there and Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess flags:(int)flags NS_SWIFT_NAME(fisheye_solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:flags:));

/**
 * Finds an object pose from 3D-2D point correspondences for fisheye camera model.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 * - point 0: [-squareLength / 2,  squareLength / 2, 0]
 * - point 1: [ squareLength / 2,  squareLength / 2, 0]
 * - point 2: [ squareLength / 2, -squareLength / 2, 0]
 * - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * The function internally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. Check there and Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess NS_SWIFT_NAME(fisheye_solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:));

/**
 * Finds an object pose from 3D-2D point correspondences for fisheye camera model.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can also be passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can also be passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * This function returns the rotation and the translation vectors that transform a 3D point expressed in the object
 * coordinate frame to the camera coordinate frame, using different methods:
 * - P3P methods (*Ref:* SOLVEPNP_P3P, *Ref:* SOLVEPNP_AP3P): need 4 input points to return a unique solution.
 * - *Ref:* SOLVEPNP_IPPE Input points must be >= 4 and object points must be coplanar.
 * - *Ref:* SOLVEPNP_IPPE_SQUARE Special case suitable for marker pose estimation.
 * Number of input points must be 4. Object points must be defined in the following order:
 * - point 0: [-squareLength / 2,  squareLength / 2, 0]
 * - point 1: [ squareLength / 2,  squareLength / 2, 0]
 * - point 2: [ squareLength / 2, -squareLength / 2, 0]
 * - point 3: [-squareLength / 2, -squareLength / 2, 0]
 * - for all the other flags, number of input points must be >= 4 and object points can be in any configuration.
 * The function internally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. Check there and Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnP:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(fisheye_solvePnP(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:));


//
//  bool cv::fisheye::solvePnPRansac(Mat objectPoints, Mat imagePoints, Mat cameraMatrix, Mat distCoeffs, Mat& rvec, Mat& tvec, bool useExtrinsicGuess = false, int iterationsCount = 100, float reprojectionError = 8.0, double confidence = 0.99, Mat& inliers = Mat(), int flags = SOLVEPNP_ITERATIVE, TermCriteria criteria = TermCriteria(TermCriteria::MAX_ITER + TermCriteria::EPS, 10, 1e-8))
//
/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 * @param inliers Output vector that contains indices of inliers in objectPoints and imagePoints .
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * @param criteria Termination criteria for internal undistortPoints call.
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence inliers:(Mat*)inliers flags:(int)flags criteria:(TermCriteria*)criteria NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:inliers:flags:criteria:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 * @param inliers Output vector that contains indices of inliers in objectPoints and imagePoints .
 * @param flags Method for solving a PnP problem: see *Ref:* calib3d_solvePnP_flags
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence inliers:(Mat*)inliers flags:(int)flags NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:inliers:flags:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 * @param inliers Output vector that contains indices of inliers in objectPoints and imagePoints .
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence inliers:(Mat*)inliers NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:inliers:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * @param confidence The probability that the algorithm produces a useful result.
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError confidence:(double)confidence NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:confidence:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * @param reprojectionError Inlier threshold value used by the RANSAC procedure. The parameter value
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount reprojectionError:(float)reprojectionError NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:reprojectionError:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * @param iterationsCount Number of iterations.
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess iterationsCount:(int)iterationsCount NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:iterationsCount:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * @param useExtrinsicGuess Parameter used for ``SolvePnPMethod/SOLVEPNP_ITERATIVE``. If true (1), the function uses
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec useExtrinsicGuess:(BOOL)useExtrinsicGuess NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:useExtrinsicGuess:));

/**
 * Finds an object pose from 3D-2D point correspondences using the RANSAC scheme for fisheye camera moodel.
 *
 * @param objectPoints Array of object points in the object coordinate space, Nx3 1-channel or
 * 1xN/Nx1 3-channel, where N is the number of points. vector\<Point3d\> can be also passed here.
 * @param imagePoints Array of corresponding image points, Nx2 1-channel or 1xN/Nx1 2-channel,
 * where N is the number of points. vector\<Point2d\> can be also passed here.
 * @param cameraMatrix Input camera intrinsic matrix `$$\cameramatrix{A}$$` .
 * @param distCoeffs Input vector of distortion coefficients (4x1/1x4).
 * @param rvec Output rotation vector (see *Ref:* Rodrigues ) that, together with tvec, brings points from
 * the model coordinate system to the camera coordinate system.
 * @param tvec Output translation vector.
 * the provided rvec and tvec values as initial approximations of the rotation and translation
 * vectors, respectively, and further optimizes them.
 * is the maximum allowed distance between the observed and computed point projections to consider it
 * an inlier.
 * The function interally undistorts points with *Ref:* undistortPoints and call *Ref:* cv::solvePnP,
 * thus the input are very similar. More information about Perspective-n-Points is described in *Ref:* calib3d_solvePnP
 * for more information.
 */
+ (BOOL)fisheye_solvePnPRansac:(Mat*)objectPoints imagePoints:(Mat*)imagePoints cameraMatrix:(Mat*)cameraMatrix distCoeffs:(Mat*)distCoeffs rvec:(Mat*)rvec tvec:(Mat*)tvec NS_SWIFT_NAME(fisheye_solvePnPRansac(objectPoints:imagePoints:cameraMatrix:distCoeffs:rvec:tvec:));



@end

NS_ASSUME_NONNULL_END


