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


@class Mat;


// C++: enum Distance (cv.ANNIndex.Distance)
typedef NS_ENUM(int, Distance) {
    ANNIndex_DIST_EUCLIDEAN NS_SWIFT_NAME(DIST_EUCLIDEAN) = 0,
    ANNIndex_DIST_MANHATTAN NS_SWIFT_NAME(DIST_MANHATTAN) = 1,
    ANNIndex_DIST_ANGULAR NS_SWIFT_NAME(DIST_ANGULAR) = 2,
    ANNIndex_DIST_HAMMING NS_SWIFT_NAME(DIST_HAMMING) = 3,
    ANNIndex_DIST_DOTPRODUCT NS_SWIFT_NAME(DIST_DOTPRODUCT) = 4
};



NS_ASSUME_NONNULL_BEGIN

// C++: class ANNIndex
/**
 * *************************************************************************************\
 * Approximate Nearest Neighbors                              *
 * \***************************************************************************************
 *
 * Member of `Features`
 */
CV_EXPORTS @interface ANNIndex : NSObject


#ifdef __cplusplus
@property(readonly)cv::Ptr<cv::ANNIndex> nativePtr;
#endif

#ifdef __cplusplus
- (instancetype)initWithNativePtr:(cv::Ptr<cv::ANNIndex>)nativePtr;
+ (instancetype)fromNative:(cv::Ptr<cv::ANNIndex>)nativePtr;
#endif


#pragma mark - Methods


//
//  void cv::ANNIndex::addItems(Mat features)
//
/**
 * Add feature vectors to index.
 *
 * @param features Matrix containing the feature vectors to index. The size of the matrix is
 *         num_features x feature_dimension.
 */
- (void)addItems:(Mat*)features NS_SWIFT_NAME(addItems(features:));


//
//  void cv::ANNIndex::build(int trees = -1)
//
/**
 * Build the index.
 *
 * @param trees Number of trees in the index. If not provided, the number is determined automatically
 * in a way that at most 2x as much memory as the features vectors take is used.
 */
- (void)build:(int)trees NS_SWIFT_NAME(build(trees:));

/**
 * Build the index.
 *
 * in a way that at most 2x as much memory as the features vectors take is used.
 */
- (void)build NS_SWIFT_NAME(build());


//
//  void cv::ANNIndex::knnSearch(Mat query, Mat& indices, Mat& dists, int knn, int search_k = -1)
//
/**
 * Performs a K-nearest neighbor search for given query vector(s) using the index.
 *
 * @param query The query vector(s).
 * @param indices Matrix that will contain the indices of the K-nearest neighbors found, optional.
 * @param dists Matrix that will contain the distances to the K-nearest neighbors found, optional.
 * @param knn Number of nearest neighbors to search for.
 * @param search_k The maximum number of nodes to inspect, which defaults to trees x knn if not provided.
 */
- (void)knnSearch:(Mat*)query indices:(Mat*)indices dists:(Mat*)dists knn:(int)knn search_k:(int)search_k NS_SWIFT_NAME(knnSearch(query:indices:dists:knn:search_k:));

/**
 * Performs a K-nearest neighbor search for given query vector(s) using the index.
 *
 * @param query The query vector(s).
 * @param indices Matrix that will contain the indices of the K-nearest neighbors found, optional.
 * @param dists Matrix that will contain the distances to the K-nearest neighbors found, optional.
 * @param knn Number of nearest neighbors to search for.
 */
- (void)knnSearch:(Mat*)query indices:(Mat*)indices dists:(Mat*)dists knn:(int)knn NS_SWIFT_NAME(knnSearch(query:indices:dists:knn:));


//
//  void cv::ANNIndex::save(String filename, bool prefault = false)
//
/**
 * Save the index to disk and loads it. After saving, no more vectors can be added.
 *
 * @param filename Filename of the index to be saved.
 * @param prefault If prefault is set to true, it will pre-read the entire file into memory (using mmap
 * with MAP_POPULATE). Default is false.
 */
- (void)save:(NSString*)filename prefault:(BOOL)prefault NS_SWIFT_NAME(save(filename:prefault:));

/**
 * Save the index to disk and loads it. After saving, no more vectors can be added.
 *
 * @param filename Filename of the index to be saved.
 * with MAP_POPULATE). Default is false.
 */
- (void)save:(NSString*)filename NS_SWIFT_NAME(save(filename:));


//
//  void cv::ANNIndex::load(String filename, bool prefault = false)
//
/**
 * Loads (mmaps) an index from disk.
 *
 * @param filename Filename of the index to be loaded.
 * @param prefault If prefault is set to true, it will pre-read the entire file into memory (using mmap
 * with MAP_POPULATE). Default is false.
 */
- (void)load:(NSString*)filename prefault:(BOOL)prefault NS_SWIFT_NAME(load(filename:prefault:));

/**
 * Loads (mmaps) an index from disk.
 *
 * @param filename Filename of the index to be loaded.
 * with MAP_POPULATE). Default is false.
 */
- (void)load:(NSString*)filename NS_SWIFT_NAME(load(filename:));


//
//  int cv::ANNIndex::getTreeNumber()
//
/**
 * Return the number of trees in the index.
 */
- (int)getTreeNumber NS_SWIFT_NAME(getTreeNumber());


//
//  int cv::ANNIndex::getItemNumber()
//
/**
 * Return the number of feature vectors in the index.
 */
- (int)getItemNumber NS_SWIFT_NAME(getItemNumber());


//
//  bool cv::ANNIndex::setOnDiskBuild(String filename)
//
/**
 *  Prepare to build the index in the specified file instead of RAM (execute before adding
 * items, no need to save after build)
 *
 * @param filename Filename of the index to be built.
 */
- (BOOL)setOnDiskBuild:(NSString*)filename NS_SWIFT_NAME(setOnDiskBuild(filename:));


//
//  void cv::ANNIndex::setSeed(int seed)
//
/**
 * Initialize the random number generator with the given seed. Only necessary to pass this
 * before adding the items. Will have no effect after calling build() or load().
 *
 * @param seed The given seed of the random number generator. Its value should be within the range of uint32_t.
 */
- (void)setSeed:(int)seed NS_SWIFT_NAME(setSeed(seed:));


//
// static Ptr_ANNIndex cv::ANNIndex::create(int dim, ANNIndex_Distance distType = ANNIndex::DIST_EUCLIDEAN)
//
/**
 * Creates an instance of annoy index class with given parameters
 *
 * @param dim The dimension of the feature vector.
 * @param distType Metric to calculate the distance between two feature vectors, can be DIST_EUCLIDEAN,
 *         DIST_MANHATTAN, DIST_ANGULAR, DIST_HAMMING, or DIST_DOTPRODUCT.
 */
+ (ANNIndex*)create:(int)dim distType:(Distance)distType NS_SWIFT_NAME(create(dim:distType:));

/**
 * Creates an instance of annoy index class with given parameters
 *
 * @param dim The dimension of the feature vector.
 *         DIST_MANHATTAN, DIST_ANGULAR, DIST_HAMMING, or DIST_DOTPRODUCT.
 */
+ (ANNIndex*)create:(int)dim NS_SWIFT_NAME(create(dim:));



@end

NS_ASSUME_NONNULL_END


