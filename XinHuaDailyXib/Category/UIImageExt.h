//
//  MNUIImage.h
//  juwu
//
//  Created by wu quancheng on 11-7-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (UIImageExt)

- (UIImage*)scaleToSize:(CGSize)size;

- (UIImage*)scaleToFixSize:(CGSize)size;

- (UIImage*)scaleToFixSizeIgnoreScale:(CGSize)aSize;

- (UIImage*)clipImageToSize:(CGSize)size;

- (UIImage *)convertToGrayscale;

- (UIImage*)imageUseMask:(UIImage*)mask ;

- (UIImage*)mirrorImage;

- (UIImage*)clipImageFrom:(CGFloat)left width:(CGFloat)width;

- (UIImage*)imageWithColor:(UIColor*)color;

- (UIImage*)imageMerged:(UIImage*)image;

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage insetSize:(CGSize)insetSize size:(CGSize)size;

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage;

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage offset:(CGPoint)offset;

- (UIImage*)imageMergedWithBg:(UIImage*)image expandSize:(CGSize)expandSize offset:(CGPoint)offset;

//- (UIImage *)roundCorner;

- (UIImage*)scaleAndRotateImage:(CGSize)targetSize;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

@end
