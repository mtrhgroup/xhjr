//
//  ParserFailedError.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/29.
//
//

#import "ParserFailedError.h"

@implementation ParserFailedError
+(id)aError{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"XML解析失败" forKey:NSLocalizedDescriptionKey];
    return [[NSError alloc] initWithDomain:SXTErrorDomain code:XParserFailed userInfo:userInfo];
}
@end
