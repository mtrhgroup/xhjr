//
//  PictureViewProxy.m
//  XinHuaDailyXib
//
//  Created by apple on 13-3-5.
//
//

#import "PictureView.h"
#import "NewsManager.h"
#import "NewsManagerDelegate.h"

@interface PictureView()
  -(void)forwardImageLoadingThread;
@end
@implementation PictureView{
    NewsManager *_manager;
}

@synthesize imageUrl=_imageUrl,waitingImage=_waitingImage,grayStylable=_grayStylable,isGrayStyle=_isGrayStyle;
- (id)init
{
    self = [super init];
    if (self) {
        _manager=[[NewsManager alloc]init];
        _manager.delegate=self;
        _grayStylable=NO;
        _isGrayStyle=NO;
        if(_waitingImage==nil){
            self.waitingImage=[UIImage imageNamed:@"ext_default_thumbnail.png"];
        }
    }
    return self;
}
-(UIImage *)image{
    if(_realImage==nil){
        if(_imageUrl!=nil){
            NSLog(@"_imageUrl %@",_imageUrl);
            _realImage=[UIImage imageWithContentsOfFile:_imageUrl];
            [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
        }
    }
    return _realImage;
}
-(void)didReceivedPicture:(NSString *)localpath{
    _realImage=[[UIImage alloc] initWithContentsOfFile:localpath];
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
}
-(void)drawRect:(CGRect)rect{
    if(_realImage==nil){
        [_waitingImage drawInRect:rect];
        if(!_loadingThreadHasLaunched){
            [self performSelectorInBackground:@selector(forwardImageLoadingThread) withObject:nil];
            _loadingThreadHasLaunched=YES;
        }
    }else{
        if(_isGrayStyle&&_grayStylable){
            [[self getGrayImage:_realImage] drawInRect:rect];
        }else{
            [_realImage drawInRect:rect];
            
        }
    }
}

-(void)forwardImageLoadingThread{
    @autoreleasepool {
         [self image];   
    }
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED>__IPHONE_6_1
#define  kCGImageAlphaNone (kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast)
#else
#define kCGImageAlphaNone kCGImageAlphaPremultipliedLast
#endif

- (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}
@end
