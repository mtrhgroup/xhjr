//
//  NetworkLostError.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/29.
//
//

#import "NetworkLostError.h"

@implementation NetworkLostError
+(id)aError{
   NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络不给力" forKey:NSLocalizedDescriptionKey];
   return [[NSError alloc] initWithDomain:SXTErrorDomain code:XNetworkLost userInfo:userInfo];
}

@end
