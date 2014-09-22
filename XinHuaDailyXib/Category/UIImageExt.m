//
//  MNUIImage.m
//  juwu
//
//  Created by wu quancheng on 11-7-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageExt.h"

@implementation UIImage (UIImageExt)

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (UIImage*)scaleToSize:(CGSize)size 
{
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);

	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage*)scaleToFixSize:(CGSize)aSize
{	
	CGSize picSize = self.size;
    while ( picSize.width > aSize.width || picSize.height > aSize.height )
    {
        float scale = ((float)aSize.width/picSize.width);
        if ( scale == 1.0f )
        {
            scale = ((float)aSize.height/picSize.height);
        }
        picSize.width *= scale;
        picSize.height *= scale;
    }	
	return [self scaleToSize:picSize];
}

- (UIImage*)scaleToFixSizeIgnoreScale:(CGSize)aSize
{	
	CGSize picSize = self.size;
    while ( picSize.width > aSize.width || picSize.height > aSize.height )
    {
        float scale = ((float)aSize.width/picSize.width);
        if ( scale == 1.0f )
        {
            scale = ((float)aSize.height/picSize.height);
        }
        picSize.width *= scale;
        picSize.height *= scale;
    }	
    
    UIGraphicsBeginImageContextWithOptions(picSize,NO,1.0);
    
	[self drawInRect:CGRectMake(0, 0, ceil(picSize.width), ceil(picSize.height))];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage*)clipImageToSize:(CGSize)size
{
    UIImage* tmp = self;
    if (self.size.width < size.width || self.size.height < size.height)
    {
        tmp = [self scaleToFixSize:size];
    }
    
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    [tmp drawAtPoint:CGPointMake(0 - (tmp.size.width - size.width)/2, 0 - (tmp.size.height - size.height)/2)];
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;

}

- (UIImage *)convertToGrayscale
{
    
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast | kCGImageAlphaNone );
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
     
    /*
    int width = self.size.width; 
    int height = self.size.height; 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray(); 
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone); 
    CGColorSpaceRelease(colorSpace); 
    if (context == NULL) 
    { 
        return nil; 
    } 
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage); 
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)]; 
    CGContextRelease(context); 
    return grayImage;
     */
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED>__IPHONE_6_1
#define  kCGImageAlphaPremultipliedLast (kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast)
#else
#define kCGImageAlphaPremultipliedLast kCGImageAlphaPremultipliedLast
#endif
- (UIImage*)imageUseMask:(UIImage*)mask
{
	CGFloat width = mask.size.width * [[UIScreen mainScreen] scale];
	CGFloat height = mask.size.height * [[UIScreen  mainScreen] scale];
	CGContextRef mainViewContentContext; 
	CGColorSpaceRef colorSpace; 
	colorSpace = CGColorSpaceCreateDeviceRGB(); 
	// create a bitmap graphics context the size of the image 
	mainViewContentContext = CGBitmapContextCreate (NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast); 
	// free the rgb colorspace 
	CGColorSpaceRelease(colorSpace);     
	if (mainViewContentContext==NULL)
		return NULL; 
	
	CGImageRef maskImage = mask.CGImage; 
	CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, width, height), maskImage); 
	CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, width,  height), self.CGImage); 
	
	// Create CGImageRef of the main view bitmap content, and then 
	// release that bitmap context 
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext); 
	CGContextRelease(mainViewContentContext); 
	// convert the finished resized image to a UIImage 
	UIImage *theImage = nil;
	if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)])
	{
		theImage = [UIImage imageWithCGImage:mainViewContentBitmapContext scale:[[UIScreen  mainScreen] scale] orientation:UIImageOrientationUp]; 
	}
	else
	{
		theImage = [UIImage imageWithCGImage:mainViewContentBitmapContext]; 		
	}
    
	CGImageRelease(mainViewContentBitmapContext); 
	// return the image 
	return theImage; 
}

- (UIImage*)mirrorImage
{
    CGSize imagesize = self.size;
	CGRect rect = CGRectMake(0, 0, imagesize.width, imagesize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,[UIScreen mainScreen].scale);
    
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformMakeTranslation(imagesize.width, 0.0);
    transform = CGAffineTransformScale(transform, -1.0, 1.0);
    CGContextConcatCTM(context, transform);
    [self drawInRect:rect];
    
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}

- (UIImage*)clipImageFrom:(CGFloat)left width:(CGFloat)width
{
    if (left<0 || left > self.size.width)
    {
        return self;
    }
    if (width < 1 || width > (self.size.width - left))
    {
        width = self.size.width - left;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, self.size.height),NO,[UIScreen mainScreen].scale);
    [self drawAtPoint:CGPointMake(0 - (self.size.width - left), 0)];
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}

- (UIImage*)imageWithColor:(UIColor*)color
{
    CGSize imagesize = self.size;
	CGRect rect = CGRectMake(0, 0, imagesize.width, imagesize.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,[UIScreen mainScreen].scale);
    
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, imagesize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextClipToMask(context, rect, self.CGImage); 
    
	CGContextSetFillColorWithColor( context, color.CGColor );   
	CGContextFillRect( context, rect );
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
	return newimage;
}

- (UIImage*)imageMerged:(UIImage*)image
{
    CGSize size = self.size;
	UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[self drawInRect:rect];
	[image drawInRect:rect];
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage insetSize:(CGSize)insetSize size:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);    
    CGRect r = CGRectInset(rect, insetSize.width, insetSize.height);
	[image drawInRect:r];
    [topImage drawInRect:rect];


	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}
+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage
{
	UIGraphicsBeginImageContextWithOptions(topImage.size,NO,[UIScreen mainScreen].scale);
	CGRect rect = CGRectMake((topImage.size.width - image.size.width)/2,(topImage.size.height - image.size.height)/2,image.size.width,image.size.height);
	[image drawInRect:rect];
    
    CGRect rect2 = CGRectMake(0, 0, topImage.size.width, topImage.size.height);
    [topImage drawInRect:rect2];
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage offset:(CGPoint)offset
{
    UIGraphicsBeginImageContextWithOptions(image.size,NO,[UIScreen mainScreen].scale);
	CGRect rect = CGRectMake(0,0, image.size.width, image.size.height);
	[image drawInRect:rect];
    
    CGRect rect2 = CGRectMake(offset.x, offset.y, topImage.size.width, topImage.size.height);
    [topImage drawInRect:rect2];
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}
- (UIImage*)imageMergedWithBg:(UIImage*)image expandSize:(CGSize)expandSize offset:(CGPoint)offset
{
    CGSize size = self.size;
	UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[image drawInRect:rect];
    [self drawInRect:CGRectOffset(CGRectInset(rect, expandSize.width, expandSize.height),offset.x,offset.y)];
    
	UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}
//
//- (UIImage *)roundCorner
//{
//    int w = self.size.width;
//    int h = self.size.height;
//    
//	CGSize size = CGSizeMake(w, h);
//    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
//   	CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextBeginPath(context);
//    CGRect rect = CGRectMake(0, 0, w, h);
//    addRoundedRectToPath(context, rect, 3.0f);
//    CGContextClosePath(context);
//    CGContextClip(context);
//    
//	[self drawInRect:CGRectMake(0, 0, w, h)];
//    
//    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//    return imageOut;    
//}

- (UIImage*)scaleAndRotateImage:(CGSize)targetSize
{
    
    UIImageOrientation orientation = self.imageOrientation;
    
    CGRect bounds = CGRectMake(0, 0, 0, 0);
    
    
    bounds.size.width = targetSize.width;
    bounds.size.height = targetSize.height;
    
    if ((orientation == UIImageOrientationUp || orientation == UIImageOrientationDown)&& self.size.height > self.size.width)
    {
        bounds.size.width = targetSize.height;
        bounds.size.height = targetSize.width;
    }
    
	
    CGImageRef imgRef =self.CGImage;
	
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if (width < bounds.size.width && height < bounds.size.height)
    {
        return self;
    }
    
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGFloat scaleRatio = MAX(bounds.size.width / width,bounds.size.height / height);
    //    CGFloat scaleRatioheight = bounds.size.height / height;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient =self.imageOrientation;
    switch(orient)
    {
			
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
			
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
			
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
			
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid?image?orientation"];
            break;
    }
	
    UIGraphicsBeginImageContext(bounds.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
//////////////
-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
            // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
        // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) Logger(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor) 
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
            // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
        // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) Logger(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
        //   CGSize imageSize = sourceImage.size;
        //   CGFloat width = imageSize.width;
        //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
        //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
        // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) Logger(@"could not scale image");
    
    
    return newImage ;
}


@end
