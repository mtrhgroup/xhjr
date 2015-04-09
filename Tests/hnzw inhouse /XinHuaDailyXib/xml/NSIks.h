//
//  NSIks.h
//  Youlu
//
//  Created by William on 10-10-19.
//  Copyright 2010 Youlu . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iksemel.h"

@interface NSIks : NSObject {
	iks* _xmlObject;
}

@property (nonatomic,readonly)iks* xmlObject;

- (id)init:(NSString*)name;
- (id)initWithIks:(NSIks*)xml;
- (id)initWithData:(NSData*)data;
- (id)initWithString:(NSString*)string;
- (iks*)insertNodeTo:(iks*)x nodeName:(NSString*)name;
- (iks*)insertNodeAndValueTo:(iks*)x nodeName:(NSString*)name nodeValue:(NSString*)value;
- (iks*)insertNodeAndValueIntTo:(iks*)x nodeName:(NSString*)name nodeValue:(NSInteger)value;
- (iks*)insertNodeAndValueInt64To:(iks*)x nodeName:(NSString*)name nodeValue:(int64_t)value;
- (iks*)insertNodeAndValueDoubleTo:(iks*)x nodeName:(NSString*)name nodeValue:(double)value;
- (iks*)insertNodeAndValueTimeTo:(iks*)x nodeName:(NSString*)name nodeValue:(NSDate*)value;

- (iks*)insertValueTo:(iks*)x value:(NSString*)data;
- (iks*)insertValueIntTo:(iks*)x value:(NSInteger)data;
- (iks*)insertValueInt64To:(iks*)x value:(int64_t)data;
- (iks*)insertValueDoubleTo:(iks*)x value:(double)data;
- (iks*)insertValueTimeTo:(iks*)x value:(NSDate*)data;
- (iks*)insertAttribTo:(iks*)x attribName:(NSString*)name attribValue:(NSString*)data;
- (iks*)insertAttribIntTo:(iks*)x attribName:(NSString*)name attribValue:(NSInteger)data;
- (iks*)insertAttribInt64To:(iks*)x attribName:(NSString*)name attribValue:(int64_t)data;
- (iks*)insertAttribDoubleTo:(iks*)x attribName:(NSString*)name attribValue:(double)data;
- (iks*)insertAttribTimeTo:(iks*)x attribName:(NSString*)name attribValue:(NSDate*)data;
- (iks*)firstTagFrom:(iks*)x;
- (iks*)nextTagFrom:(iks*)x;
- (NSString*)name:(iks*)x;
- (iks*)findNodeFrom:(iks*)x nodeName:(NSString*)name;

- (NSString*)findValueFrom:(iks*)x nodeName:(NSString*)name;
- (NSNumber*)findValueIntFrom:(iks*)x nodeName:(NSString*)name;
- (NSNumber*)findValueDoubleFrom:(iks*)x nodeName:(NSString*)name;
- (NSDate*)findValueTimeFrom:(iks*)x nodeName:(NSString*)name;

- (NSString*)valueFrom:(iks*)x;
- (NSNumber*)valueIntFrom:(iks*)x;
- (NSNumber*)valueDoubleFrom:(iks*)x;
- (NSDate*)valueTimeFrom:(iks*)x;

- (NSString*)findAttribFrom:(iks*)x attribname:(NSString*)name;
- (NSNumber*)findAttribIntFrom:(iks*)x attribname:(NSString*)name;
- (NSNumber*)findAttribDoubleFrom:(iks*)x attribname:(NSString*)name;
- (NSDate*)findAttribTimeFrom:(iks*)x attribname:(NSString*)name;
- (NSString*)UTF8String;
- (NSInteger)length;
- (iks*)resultData;
- (NSString*)nameFromNode:(iks*)x;
- (NSData*)xmlData;
- (NSInteger)numberOfTagsFromNode:(iks*)x tagName:(NSString*)name;

- (void)deleteNode:(iks*)node;
@end
