//
//  NSObject+detachNewThreadSelectorWithObjs.h
//  XinHuaDailyXib
//
//  Created by apple on 13-8-6.
//
//

#import <Foundation/Foundation.h>

@interface NSThread (detachNewThreadSelectorWithObjs)
+ (void)detachNewThreadSelector:(SEL)aSelector
                       toTarget:(id)aTarget
                     withObject:(id)anArgument
                      and2Object:(id)another2Argument
                     and3Object:(id)another3Argument;
@end
