                                          

//  main.m
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef DFN
#import "DFNAppDelegate.h"
#endif
#ifdef LNFB
#import "XinHuaAppDelegate.h"
#endif
#ifdef Ocean
#import "OceanAppDelegate.h"
#endif
#ifdef Money
#import "MoneyAppDelegate.h"
#endif
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
#ifdef Ocean
    @autoreleasepool {
        return UIApplicationMain(argc, argv, @"UIApplication", NSStringFromClass([OceanAppDelegate class]));
    }
#endif
#ifdef Money
    @autoreleasepool {
        return UIApplicationMain(argc, argv, @"UIApplication", NSStringFromClass([MoneyAppDelegate class]));
    }
#endif
}

