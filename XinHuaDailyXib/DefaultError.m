//
//  BindingFailed.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/29.
//
//

#import "DefaultError.h"

@implementation DefaultError
+(id)aErrorWithMessage:(NSString *)message{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    return [[NSError alloc] initWithDomain:SXTErrorDomain code:XDefultFailed userInfo:userInfo];
}
@end
