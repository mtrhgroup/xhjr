//
//  NSString+Md5.m
//  Youlu
//
//  Created by William on 10-10-26.
//  Copyright 2010 Youlu . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

#import "NSStringExt.h"
    //char to nsstring CFSTR()
@implementation NSString (EXT)

#define CHUNK_SIZE 1024
+(NSString*)fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil )return nil; // file didnt exist
	
    CC_MD5_CTX md5;
	
    CC_MD5_Init(&md5);
	
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 )done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1], 
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

- (NSString*)MD5String 
{
	if (self.length == 0)
	{
		return @"";
	}
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
	
    char md5string[CC_MD5_DIGEST_LENGTH*2];
	
    int i;
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        sprintf(md5string+i*2, "%02x", digest[i]);
    }
	
    return [NSString stringWithCString:md5string encoding:NSASCIIStringEncoding];
    // return [NSString stringWithCString:md5string length:CC_MD5_DIGEST_LENGTH*2];
}


- (NSString*)toHex
{
	NSMutableString* hex = [NSMutableString string];
	for (int i=0; i<[self length]; i++)
	{
		unichar c = [self characterAtIndex:i] & 0xFF;
		[hex appendFormat:@"%02x",c];
	}
	return hex;
}

- (NSData*)toBinData
{
	NSMutableData* data = [NSMutableData data];
	int idx;
	for (idx = 0; idx+2 <= self.length; idx+=2){
		NSRange range = NSMakeRange(idx, 2);
		NSString* hexStr = [self substringWithRange:range];
		NSScanner* scanner = [NSScanner scannerWithString:hexStr];
		unsigned int intValue;
		[scanner scanHexInt:&intValue];
		[data appendBytes:&intValue length:1];
	}
	return data;	
}




+ (NSString*)stringWithLong:(long)number
{
	NSNumber* num = [NSNumber numberWithLong:number];
	return [num stringValue];
}
+ (NSString*)stringwithDouble:(double)number
{
    NSNumber* num = [NSNumber numberWithDouble:number];
    return [num stringValue];
}

+ (NSString*)stringWithChar:(char)aChar
{
    NSString *string = [NSString stringWithFormat:@"%c",aChar];
    return string;
}

- (NSString*)unFormatNumber
{
	NSCharacterSet *nonDecimalDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSMutableString* numberString = [NSMutableString stringWithCapacity:11];
    
    NSUInteger i, count;
    for (i=0, count=CFStringGetLength((CFStringRef)self); i<count; ++i)
	{
        unichar character = CFStringGetCharacterAtIndex((CFStringRef)self, i);
		if (character == '@')
		{
			return @"";
		}
        if (![nonDecimalDigits characterIsMember:character] || character=='p' || character==','
			|| character=='#' || character=='*')
		{
            CFStringAppendCharacters((CFMutableStringRef)numberString, &character, 1);
        }
		else if ( i==0  && character=='+')
		{
			CFStringAppendCharacters((CFMutableStringRef)numberString, &character, 1);
		}
    }
    return numberString;
}

//- (NSString*)fileExt
//{
//	NSRange range = [self rangeOfString:@"." options:NSBackwardsSearch];
//	range.length = self.length - range.location;
//	return [self substringWithRange:range];
//}
//for  example "0xfafaf4ff" to int
- (NSUInteger)hexStringToInt
{
	unsigned int hexValue = 0;
	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	[scanner scanHexInt:&hexValue];
	[scanner release];
	return hexValue;
}

- (NSString*)hideNumber
{
    NSMutableString* number = [NSMutableString stringWithString:[self unFormatNumber]];
    if (number.length < 8)
    {
        return @"******";
    }
    NSInteger pos = number.length - 8;
    [number replaceCharactersInRange:NSMakeRange(pos, 4)withString:@"****"];
    return number;
}
- (NSString*)trimSpaceAndReturn
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)URLEncodedString
{    
    NSString *result = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[] "),
                                            kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++){
		unsigned char c = *p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_'){
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len){
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound){
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location){
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]){
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML
{
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [[self mutableCopy] autorelease];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0){
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound){
			[s appendString:target];
			break;
		}
		
		if (r.location > 0){
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]){
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]){
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]){
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]){
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters 
{
    NSMutableString* result = [NSMutableString stringWithString:self];
    int count = CFStringGetLength((CFStringRef)self);
    for (int i=count-1;i>=0; i--)
	{
        unichar character = CFStringGetCharacterAtIndex((CFStringRef)self, i);
		if (character == ' ' || character == '\r' || character == '\n')
		{
            CFStringDelete((CFMutableStringRef)result, CFRangeMake(i, 1));
		}
        else
        {
            break;
        }
    }
    return result;

}

-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}
-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedText = [self attributedStringFromStingWithFont:font
                                                                        withLineSpacing:lineSpacing];
    CGSize textSize = [attributedText boundingRectWithSize:size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size;
    return textSize;
}
@end