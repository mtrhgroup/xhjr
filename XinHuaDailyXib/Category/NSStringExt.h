//
//  NSStringExt.h
//  Youlu
//
//  Created by William on 10-10-27.
//  Copyright 2010 Youlu . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (EXT)

+ (NSString*)fileMD5:(NSString*)path;
- (NSString*)MD5String;
- (NSString*)toHex;
- (NSData*)toBinData;
+ (NSString*)stringWithLong:(long)number;
+ (NSString*)stringwithDouble:(double)number;
+ (NSString*)stringWithChar:(char)aChar;
- (NSString*)unFormatNumber;
- (NSUInteger)hexStringToInt;
- (NSString*)hideNumber;

- (NSString*)trimSpaceAndReturn;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

//计算文本的size
-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing;
//sting转AttributedString
-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing;

@end
