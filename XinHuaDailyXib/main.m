                                          

//  main.m
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DFNAppDelegate.h"

int main(int argc, char *argv[])
{
#ifdef LNFB
    @autoreleasepool {
        return UIApplicationMain(argc, argv, @"UIApplication", NSStringFromClass([XinHuaAppDelegate class]));
    }
#endif
#ifdef DFN
    @autoreleasepool {
        return UIApplicationMain(argc, argv, @"UIApplication", NSStringFromClass([DFNAppDelegate class]));
    }
#endif
}

