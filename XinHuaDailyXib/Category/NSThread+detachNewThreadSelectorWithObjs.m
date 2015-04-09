//
//  NSObject+detachNewThreadSelectorWithObjs.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-6.
//
//

#import "NSThread+detachNewThreadSelectorWithObjs.h"

@implementation NSThread (detachNewThreadSelectorWithObjs)
+ (void)detachNewThreadSelector:(SEL)aSelector
                       toTarget:(id)aTarget
                     withObject:(id)anArgument
                     and2Object:(id)another2Argument
                     and3Object:(id)another3Argument
{
    NSMethodSignature *signature = [aTarget methodSignatureForSelector:aSelector];
    if (!signature) return;
    
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:aTarget];
    [invocation setSelector:aSelector];
    [invocation setArgument:&anArgument atIndex:2];
    [invocation setArgument:&another2Argument atIndex:3];
    [invocation setArgument:&another3Argument atIndex:4];
    [invocation retainArguments];
    [self detachNewThreadSelector:@selector(invoke) toTarget:invocation withObject:nil];
}

@end
