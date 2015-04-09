//
//  BindleLostError.m
//  XinHuaDailyXib
//
//  Created by apple on 14/12/4.
//
//

#import "BindleLostError.h"

@implementation BindleLostError
+(id)aError{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络不给力" forKey:NSLocalizedDescriptionKey];
    return [[NSError alloc] initWithDomain:SXTErrorDomain code:XBindingFailed userInfo:userInfo];
}
@end
