//
//  UIScreenExt.m
//  YContact
//
//  Created by William on 11-9-21.
//  Copyright 2011年 Youlu. All rights reserved.
//

#import "UIScreenExt.h"
static CGFloat __screenScale = -1;

@implementation UIScreen(ext)


+ (CGFloat)height
{
    return [[UIScreen mainScreen]  bounds].size.height;
}

+ (CGFloat)width
{
    return [[UIScreen mainScreen]  bounds].size.width;
}

+ (CGFloat)screenScale
{
	if (__screenScale < 0) 
	{
		__screenScale = 1.0;
		UIScreen* screen = [UIScreen mainScreen];
		if ([screen respondsToSelector:@selector(scale)])
		{
			__screenScale = screen.scale;
		} 
	}
	return __screenScale;
}
@end
