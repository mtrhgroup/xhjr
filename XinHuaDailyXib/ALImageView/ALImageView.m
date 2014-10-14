//
//  ALImageView.m
//  ALImageView
//
//  Created by SpringOx on 12-8-2.
//  Copyright (c) 2012年 SpringOx. All rights reserved.
//
//  Contact:jiachunke@gmail.com
//

#import "ALImageView.h"
#import "NetStreamStatistics.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)MD5EncodedString;

@end

@implementation NSString (MD5)

- (NSString *)MD5EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], [data length], result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

@end

const NSString *const LOCAL_CAHCE_DIRECTORY_DEFAULT = @"com.springox.ALImageView";
const NSTimeInterval LOCAL_CACHE_EXPIRED_TIME_DEFAULT = 10;
const BOOL CLEAR_CACHE=FALSE;

@implementation ALImageCache

+ (ALImageCache *)sharedInstance
{
    static ALImageCache *_imageCache = nil;
    static dispatch_once_t _oncePredicate;
    dispatch_once(&_oncePredicate, ^{
        _imageCache = [[ALImageCache alloc] init];
    });
    return _imageCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    @autoreleasepool {
        self.memoryCache = [[[NSCache alloc] init] autorelease];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        if (0 < [cachesPath length]) {
            self.localCacheDirectory = [cachesPath stringByAppendingPathComponent:(NSString *)LOCAL_CAHCE_DIRECTORY_DEFAULT];
        }
        
        self.localCacheExpiredTime = LOCAL_CACHE_EXPIRED_TIME_DEFAULT;
        if(CLEAR_CACHE){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanAllMemoryCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanExpiredLocalCache)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        }
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.memoryCache = nil;
    self.localCacheDirectory = nil;
    [super dealloc];
}

#pragma mark ALImageCache (@public)

- (void)setLocalCacheDirectory:(NSString *)localCacheDirectory
{
    if (_localCacheDirectory != localCacheDirectory) {
        if (nil != _localCacheDirectory) {
            [_localCacheDirectory release];
            _localCacheDirectory = nil;
        }
        
        if (nil != localCacheDirectory) {
            _localCacheDirectory = [localCacheDirectory retain];
        }
    }
    
    if (0 < [_localCacheDirectory length]) {
        BOOL isDirectory = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:_localCacheDirectory isDirectory:&isDirectory] || !isDirectory) {  // File is not exist or is not directory
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:_localCacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
}

- (void)setLocalCacheExpiredTime:(NSTimeInterval)localCacheExpiredTime
{
    if (0 >= localCacheExpiredTime) {
        _localCacheExpiredTime = 0;
    } else {
        _localCacheExpiredTime = localCacheExpiredTime;
    }
}

- (UIImage *)cachedImageForImageURL:(NSString *)url fromLocal:(BOOL)localEnabled
{
    UIImage *img = [self cachedImageForKey:url];
    if (nil == img && localEnabled && nil != _localCacheDirectory) {
        NSString *localCachePath = [_localCacheDirectory stringByAppendingPathComponent:[url MD5EncodedString]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localCachePath]) {
            NSData *data = [NSData dataWithContentsOfFile:localCachePath];
            img = [UIImage imageWithData:data];
            [self cacheImage:img forKey:url];
            NSLog(@"cached image local cache path:%@", localCachePath);
        }
    }
	return img;
}

- (UIImage *)cacheImageWithData:(NSData *)data forImageURL:(NSString *)url toLocal:(BOOL)localEnabled
{
    UIImage *img = [UIImage imageWithData:data];
    [self cacheImage:img forKey:url];
    if (localEnabled && nil != _localCacheDirectory) {
        NSString *localCachePath = [_localCacheDirectory stringByAppendingPathComponent:[url MD5EncodedString]];
        NSError *error = nil;
        [data writeToFile:localCachePath options:NSDataWritingFileProtectionComplete error:&error];
        NSLog(@"cache image local cache path:%@ error:%@", localCachePath, error);
    }
    return img;
}

- (BOOL)clearCache
{
    NSFileManager *fm = [NSFileManager defaultManager];

    NSError *error = nil;
    NSArray *contents = [fm contentsOfDirectoryAtPath:_localCacheDirectory error:&error];
    @autoreleasepool {
        for (NSString *itemName in contents) {
            NSString *absolutePath = [_localCacheDirectory stringByAppendingPathComponent:itemName];
            error = nil;
            [fm removeItemAtPath:absolutePath error:&error];
            NSLog(@"remove file for clear cache error:%@", error);
        }
    }
    if (nil == error) {
        [self.memoryCache removeAllObjects];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark ALImageCache (@private)

- (UIImage *)cachedImageForKey:(NSString *)key
{
	return [self.memoryCache objectForKey:key];
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key
{
    if (image && key) {
        [self.memoryCache setObject:image forKey:key];
    }
}

- (void)cleanAllMemoryCache
{
    [self.memoryCache removeAllObjects];
}

- (void)cleanExpiredLocalCache
{
    if (_localCacheExpiredTime <= 0) {
        return;
    }
    
    __block UIBackgroundTaskIdentifier bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // End the background task when expiration.
        if (UIBackgroundTaskInvalid != bgTaskIdentifier) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTaskIdentifier];
            bgTaskIdentifier = UIBackgroundTaskInvalid;
            NSLog(@"end the background task when expiration");
        }
    }];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *localCacheDirURL = [NSURL fileURLWithPath:_localCacheDirectory isDirectory:YES];
    NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtURL:localCacheDirURL
                                     includingPropertiesForKeys:resourceKeys
                                                        options:NSDirectoryEnumerationSkipsHiddenFiles
                                                   errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                       return YES;
                                                   }];
    NSError *error = nil;
    for (NSURL *fileURL in fileEnumerator) {
        @autoreleasepool {
            
            // Copy from SDWebImage.
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue])
            {
                continue;
            }
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if (_localCacheExpiredTime <= -[modificationDate timeIntervalSinceNow])
            {
                error = nil;
                [fm removeItemAtURL:fileURL error:&error];
                NSLog(@"remove file for clean expired local cache %f error:%@", [modificationDate timeIntervalSinceNow], error);
            }
            // --Copy from SDWebImage.
        }
    }
    
    // End the background task with clean expired local cache.
    if (UIBackgroundTaskInvalid != bgTaskIdentifier) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTaskIdentifier];
        bgTaskIdentifier = UIBackgroundTaskInvalid;
        NSLog(@"end the background task with clean expired local cache");
    }
}

@end

#pragma mark -

const NSTimeInterval REQUEST_TIME_OUT_INTERVAL = 30.f;
const int SLEEP_TIME_INTERVAL = 400;  //milliseconds
const int REQUEST_RETRY_COUNT = 2;

@interface ALImageView ()
{
    UIImage *_placeholderImage;
    UIActivityIndicatorView *_activityView;
    id _target;
    SEL _action;
    NSInteger _taskCount;      // Add the count to reload a picture when the object is complex,
                               // the old block, in effect, equivalent cancel
}

@end

@implementation ALImageView

+ (void)loadImageInTheBackground:(NSString *)imageURL
{
    ALImageView *aImageView = [[ALImageView alloc] init];
    [aImageView loadImage:imageURL placeholderImage:nil];
    [aImageView release];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _contentEdgeInsets = UIEdgeInsetsZero;
    _index = -UINT_MAX;
    _queuePriority = ALImageQueuePriorityNormal;
    _localCacheEnabled = YES;
    _indicatorEnabled = NO;
    _asyncLoadImageFinished = YES;
    
    //_queuePriority = ALImageQueuePriorityLow;
}

- (void)dealloc
{
    self.imageURL = nil;
    if (nil != _activityView) {
        [_activityView stopAnimating];
        [_activityView release];
        _activityView = nil;
    }
    [super dealloc];
}

#pragma mark ALImageView (@public)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if (_placeholderImage != placeholderImage) {
        if (nil != _placeholderImage) {
            [_placeholderImage release];
            _placeholderImage = nil;
        }
        
        if (nil != placeholderImage) {
            _placeholderImage = [placeholderImage retain];
        }
    }
    self.image = _placeholderImage;
}

- (void)setImageURL:(NSString *)imageURL
{
    imageURL=[imageURL  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (_imageURL != imageURL) {
        if (nil != _imageURL) {
            if (nil != _placeholderImage) {
                self.image = _placeholderImage;
            } else {
                self.image = nil;
            }
            [_imageURL release];
            _imageURL = nil;
        }
        
        if (nil != imageURL) {
            _imageURL = [imageURL retain];
        }
    }
    
    if (0 < [_imageURL length]) {
        UIImage *img = [[ALImageCache sharedInstance] cachedImageForImageURL:_imageURL fromLocal:_localCacheEnabled];
        if (nil != img) {
            _asyncLoadImageFinished = YES;
            [self setImageWithPlaceholder:img];
            NSLog(@"set load image finished tag is YES because cache is not nil!");
            return;
        }
        
        _asyncLoadImageFinished = NO;
        [self asyncLoadImageWithURL:[NSURL URLWithString:_imageURL]];
        NSLog(@"set load image finished tag is NO!");
    } else {
        _asyncLoadImageFinished = YES;
        NSLog(@"set load image finished tag is YES because image url length is zero!");
    }
}

- (void)setIndicatorEnabled:(BOOL)indicatorEnabled
{
    _indicatorEnabled = indicatorEnabled;
    if (!_indicatorEnabled) {
        if (nil != _activityView) {
            [_activityView stopAnimating];
            [_activityView release];
            _activityView = nil;
        }
    }
}

- (void)setIsCorner:(BOOL)isCorner
{
    _isCorner = isCorner;
    if (_isCorner) {
        self.layer.cornerRadius = 10.0f;
        self.clipsToBounds = YES;
    } else {
        self.layer.cornerRadius = 0.0f;
        self.clipsToBounds = NO;
    }
}

- (void)loadImage:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    self.placeholderImage = placeholderImage;
    self.imageURL = imageURL;
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureRecognizer:)];
    [self addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
}

- (void)cancelLoading
{
    // if the task(async load image) is waitting, _taskCount++ can make the task skip execution, tencent:jiachunke(20140531)
    _taskCount++;
    _asyncLoadImageFinished = YES;
    [_activityView stopAnimating];
}

#pragma mark ALImageView (@private)

- (UIImage *)insertBgImage:(UIImage *)bgImage toImage:(UIImage *)image
{
    if (_contentEdgeInsets.top || _contentEdgeInsets.left || _contentEdgeInsets.bottom || _contentEdgeInsets.right) {
        CGFloat s = [UIScreen mainScreen].scale;
        CGSize size = CGSizeMake(s*self.bounds.size.width, s*self.bounds.size.height);
        UIGraphicsBeginImageContext(size);
        [bgImage drawInRect:CGRectMake(0.f, 0.f, s*self.bounds.size.width, s*self.bounds.size.height)];
        [image drawInRect:CGRectMake(s*_contentEdgeInsets.left, s*_contentEdgeInsets.top, s*(self.bounds.size.width-_contentEdgeInsets.left-_contentEdgeInsets.right), s*(self.bounds.size.height-_contentEdgeInsets.top-_contentEdgeInsets.bottom))];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage;
    } else {
        return image;
    }
}

- (void)setImageWithPlaceholder:(UIImage *)img
{
    if (nil == img) {
        return;
    }
    
    if (nil != _placeholderImage) {
        self.image = [self insertBgImage:_placeholderImage toImage:img];
    } else {
        self.image = img;
    }
}

- (void)setImageWithAnimation:(UIImage *)img
{
    [self setImageWithPlaceholder:img];
    
    if (nil == _placeholderImage) {
        self.alpha = 0.f;
        [UIView animateWithDuration:1.2f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alpha = 1.f;
                         }
                         completion:nil];
    }
}

- (NSInteger)getTaskCount
{
    return _taskCount;
}

- (UIActivityIndicatorView *)getActivityView
{
    return _activityView;
}

- (void)asyncLoadImageWithURL:(NSURL *)url
{
    if (_indicatorEnabled && nil == _activityView) {
        if (nil == _placeholderImage) {
            _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        } else {
            _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        _activityView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:_activityView];
    }
    [_activityView startAnimating];
    
    _taskCount++;
    
    NSInteger countStamp = _taskCount;
    dispatch_block_t loadImageBlock = ^(void) {
        
        NSData *data = nil;
        UIImage *img = nil;
        
        // the img has cached when task executing, retrun at once, springox(20140531)
        img = [[ALImageCache sharedInstance] cachedImageForImageURL:self.imageURL fromLocal:self.localCacheEnabled];
        
        // if task is not current task, give up and release resources, springox(20140302)
        if (nil == img && countStamp == [self getTaskCount]) {
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:REQUEST_TIME_OUT_INTERVAL];
            int retryCount = -1;
            while (REQUEST_RETRY_COUNT > retryCount && countStamp == [self getTaskCount]) {
                NSLog(@"async load image start url:%@ countStamp:%d _taskCount:%d", [request.URL.absoluteString lastPathComponent], countStamp, [self getTaskCount]);
                
                if (0 <= retryCount) {
                    NSLog(@"async load image usleep url:%@ countStamp:%d _taskCount:%d", [request.URL.absoluteString lastPathComponent], countStamp, [self getTaskCount]);
                    usleep(SLEEP_TIME_INTERVAL*(retryCount+1));
                }
                
                NSURLResponse *response = nil;
                NSError *error = nil;
                data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                retryCount++;
                
                NSLog(@"async load image retry count:%d expected length:%lld", retryCount, response.expectedContentLength);
                
                if (nil == error &&
                    0 < response.expectedContentLength &&
                    response.expectedContentLength == [data length]) {  // Tested may return the length of the data is empty or less
                    int toAdd=(int)response.expectedContentLength;
                    if(toAdd>0){
                        [[NetStreamStatistics sharedInstance] appendBytesToDictionary:toAdd];
                    }
                    img = [[ALImageCache sharedInstance] cacheImageWithData:data forImageURL:[url absoluteString] toLocal:self.localCacheEnabled];
                    
                    NSLog(@"async load image success url:%@ countStamp:%d _taskCount:%d dataLength:%d", [self.imageURL lastPathComponent], countStamp, [self getTaskCount], [data length]);
                    break;
                } else {
                    data = nil;
                }
                
                NSLog(@"async load image fail url:%@ countStamp:%d _taskCount:%d dataLength:%d", [self.imageURL lastPathComponent], countStamp, [self getTaskCount], [data length]);
            }
        } else {
            NSLog(@"async load image not start countStamp:%d _taskCount:%d", countStamp, [self getTaskCount]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (countStamp == [self getTaskCount]) {  // Add the count to reload a picture when the object is complex,the old block, in effect, equivalent cancel
                self.asyncLoadImageFinished = YES;
                [[self getActivityView] stopAnimating];
                
                [self setImageWithAnimation:img];
                NSLog(@"async load image finish!");
            } else {
                NSLog(@"async load image finish without set image!");
            }
            
        });
    };
    
    if (ALImageQueuePriorityHigh == _queuePriority) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), loadImageBlock);
    } else if (ALImageQueuePriorityNormal == _queuePriority) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), loadImageBlock);
    } else {
        static dispatch_queue_t imageQueue = NULL;
        
        if (NULL == imageQueue) {
            imageQueue = dispatch_queue_create("com.springox.ALImageView.image_queue", nil);
        }
        dispatch_async(imageQueue, loadImageBlock);
    }
}

- (void)didTapGestureRecognizer:(id)sender
{
    if (nil == self.image || _activityView.isAnimating) {
        return;
    }
    [_target performSelector:_action withObject:self];
}

@end
