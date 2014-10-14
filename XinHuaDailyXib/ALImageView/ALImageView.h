//
//  ALImageView.h
//  ALImageView
//
//  Created by SpringOx on 12-8-2.
//  Copyright (c) 2012年 SpringOx. All rights reserved.
//
//  Contact:jiachunke@gmail.com
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ALImageCache : NSObject

/**
 Share a single case
 */
+ (ALImageCache *)sharedInstance;

/**
 Set a memory cache.
 */
@property (nonatomic, retain) NSCache *memoryCache;

/**
 Set a local cache directory, the default is Caches/com.springox.ALImageView.
 */
@property (nonatomic, retain) NSString *localCacheDirectory;

/**
 Set a local cache expired time, the type of the variable is NSTimeInterval, 
 it is must be greater than or equal to zero.
 If try to set a negative number, the result will be converted to zero.
 When the value of the variable is not equal to zero, the operation for clean expired local cache will be
 execute after receive UIApplicationDidEnterBackgroundNotification.
 The default is 10.
 */
@property (nonatomic, assign) NSTimeInterval localCacheExpiredTime;

/**
 Return image from memory cache,if memory cache unfind and localEnabled equal to YES,
 return image from local cache.
 
 @param url
 @param localEnabled
 */
- (UIImage *)cachedImageForImageURL:(NSString *)url fromLocal:(BOOL)localEnabled;

/**
 Cache data for image to memory cache,and localEnabled equal to YES,
 cache to local cache also.
 
 @param data
 @param url
 @param localEnabled
 */
- (UIImage *)cacheImageWithData:(NSData *)data forImageURL:(NSString *)url toLocal:(BOOL)localEnabled;

/**
 Clear memory cache and local cache.
 */
- (BOOL)clearCache;

@end

#pragma mark -

typedef enum {
    ALImageQueuePriorityLow = 0,
    ALImageQueuePriorityNormal,
    ALImageQueuePriorityHigh,
} ALImageQueuePriority;

@interface ALImageView : UIImageView

/**
 Set a palce holder image for the image view.
 */
@property (nonatomic, retain) UIImage *placeholderImage;

/**
 When load image finished,the image can cover the place holder image with the parameter.
 */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

/**
 Set a index number for the image view.
 */
@property (nonatomic, assign) NSInteger index;

/**
 Set a uri for loading image,no matter the source keep in memory cache,
 local cache or remote server,and image will be loaded at once.
 */
@property (nonatomic, retain) NSString *imageURL;

/**
 Set a flag for loading asynchronously status.
 */
@property (nonatomic, assign) BOOL asyncLoadImageFinished;

/**
 Set a priority for connection queue,if the value equal to high or normal,
 the queue which connection added to will run concomitantly,
 and if equal to low,the queue will run with serial execution.
 */
@property (nonatomic, assign) ALImageQueuePriority queuePriority;

/**
 Set the property to YES,load image asynchronously with a standard indicator view.
 */
@property (nonatomic, assign) BOOL indicatorEnabled;

/**
 Set the property to YES,the image which loaded from remote server will be cached to local disk.
 */
@property (nonatomic, assign) BOOL localCacheEnabled;

/**
 Set the property to YES,the image view have four symmetric corner,corner radius equal to '10.0f'.
 */
@property (nonatomic, assign) BOOL isCorner;

/**
 Set some user infomation,default value is 'nil'.
 */
@property (nonatomic, retain) NSDictionary *userInfo;

/**
 Load image immediately in the background with a image url.
 
 Class method
 
 @param imageURL
 */
+ (void)loadImageInTheBackground:(NSString *)imageURL;

/**
 Load image immediately with a image url and a place holder image.
 
 @param imageURL 
 @param placeholderImage
 */
- (void)loadImage:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage;

/**
 Callback method when there is a tap gesture on the image view.
 
 @param target
 @param action
 */
- (void)addTarget:(id)target action:(SEL)action;

/**
 Cancel current task with asynchronously loading image.
 */
- (void)cancelLoading;

@end
