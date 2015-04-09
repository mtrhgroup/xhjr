//
//  NSIks.m
//  Youlu
//
//  Created by William on 10-10-19.
//  Copyright 2010 Youlu . All rights reserved.
//

#import "NSIks.h"
#define KTimeSec 1.0

@implementation NSIks
@synthesize xmlObject = _xmlObject;

- (id)init:(NSString*)name
{
	if (self = [super init])
	{
		const char *c_name = [name  UTF8String];
		_xmlObject = iks_new(c_name);		
	}
    return self;
}

- (id)initWithIks:(NSIks*)xml
{
	if (self = [super init])
	{
		_xmlObject = iks_copy(xml.xmlObject);
	}
    return self;
}

- (id)initWithData:(NSData*)data
{
	if (self = [super init])
	{
		int* err = 0;
		_xmlObject = iks_tree((char*)[data bytes], data.length, err);
	}
    return self;
}

- (id)initWithString:(NSString*)string
{
	if (self = [super init])
	{
		int* err = 0;
		NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
		_xmlObject = iks_tree((char*)[data bytes], data.length, err);
	}
    return self;
}

- (iks*)insertNodeTo:(iks*)x nodeName:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	return iks_insert(x, c_name);
}

- (iks*)insertNodeAndValueTo:(iks*)x nodeName:(NSString*)name nodeValue:(NSString*)value
{
	iks* node = [self insertNodeTo:x nodeName:name];
	return [self insertValueTo:node value:value];
}

- (iks*)insertNodeAndValueIntTo:(iks*)x nodeName:(NSString*)name nodeValue:(NSInteger)value
{
	iks* node = [self insertNodeTo:x nodeName:name];
	return [self insertValueIntTo:node value:value];
}

- (iks*)insertNodeAndValueInt64To:(iks*)x nodeName:(NSString*)name nodeValue:(int64_t)value
{
    iks* node = [self insertNodeTo:x nodeName:name];
	return [self insertValueInt64To:node value:value];
}

- (iks*)insertNodeAndValueDoubleTo:(iks*)x nodeName:(NSString*)name nodeValue:(double)value
{
    iks* node = [self insertNodeTo:x nodeName:name];
	return [self insertValueDoubleTo:node value:value];
}
- (iks*)insertNodeAndValueTimeTo:(iks*)x nodeName:(NSString*)name nodeValue:(NSDate*)value
{
    iks* node = [self insertNodeTo:x nodeName:name];
    return [self insertValueTimeTo:node value:value];
}
- (iks*)insertValueTo:(iks*)x value:(NSString*)data
{	
	if (data.length>0)
	{
		const char* c_value = [data  UTF8String];
		return iks_insert_cdata(x, c_value, strlen(c_value));
	}
	else 
	{
		return iks_insert_cdata(x, "", 0);
	}
}

- (iks*)insertValueIntTo:(iks*)x value:(NSInteger)data
{
	NSString* tmp = [NSString stringWithFormat:@"%d",data];
	const char *c_data = [tmp  UTF8String];
	return iks_insert_cdata(x, c_data, strlen(c_data));
}

- (iks*)insertValueInt64To:(iks*)x value:(int64_t)data
{
	NSString* tmp = [NSString stringWithFormat:@"%lld",data];
	const char *c_data = [tmp  UTF8String];
	return iks_insert_cdata(x, c_data, strlen(c_data));
}

- (iks*)insertValueDoubleTo:(iks*)x value:(double)data
{
	NSString* tmp = [NSString stringWithFormat:@"%f",data];
	const char *c_data = [tmp  UTF8String];
	return iks_insert_cdata(x, c_data, strlen(c_data));
}

- (iks*)insertValueTimeTo:(iks*)x value:(NSDate*)data
{
	NSTimeInterval time = [data timeIntervalSince1970];
	NSString* tmp = [NSString stringWithFormat:@"%.0f",time*KTimeSec];//%qi
	const char *c_data = [tmp  UTF8String];
	return iks_insert_cdata(x, c_data, strlen(c_data));
}

- (iks*)insertAttribTo:(iks*)x attribName:(NSString*)name attribValue:(NSString*)data
{
	const char *c_name = [name  UTF8String];
	const char *c_data = [data  UTF8String];
	if (data.length>0)
	{
		return iks_insert_attrib(x, c_name, c_data);
	}
	else 
	{
		return iks_insert_attrib(x, c_name, "");
	}

	
}

- (iks*)insertAttribIntTo:(iks*)x attribName:(NSString*)name attribValue:(NSInteger)data
{
	const char *c_name = [name  UTF8String];
	NSString* tmp = [NSString stringWithFormat:@"%d",data];
	const char *c_data = [tmp  UTF8String];
	return iks_insert_attrib(x, c_name, c_data);
}

- (iks*)insertAttribInt64To:(iks*)x attribName:(NSString*)name attribValue:(int64_t)data
{
    const char *c_name = [name  UTF8String];
	NSString* tmp = [NSString stringWithFormat:@"%lld",data];
	const char *c_data = [tmp  UTF8String];
	return iks_insert_attrib(x, c_name, c_data);
}

- (iks*)insertAttribDoubleTo:(iks*)x attribName:(NSString*)name attribValue:(double)data
{
    const char *c_name = [name  UTF8String];
	NSString* tmp = [NSString stringWithFormat:@"%f",data];
	const char *c_data = [tmp  UTF8String];
	return iks_insert_attrib(x, c_name, c_data);
}

- (iks*)insertAttribTimeTo:(iks*)x attribName:(NSString*)name attribValue:(NSDate*)data
{
	const char *c_name = [name  UTF8String];
	NSTimeInterval time = [data timeIntervalSince1970];
	NSString* tmp = [NSString stringWithFormat:@"%.0f",time*KTimeSec];//%qi
	const char *c_data = [tmp  UTF8String];
	return iks_insert_attrib(x, c_name, c_data);	
}

- (iks*)firstTagFrom:(iks*)x
{
	return iks_first_tag(x);
}

- (iks*)nextTagFrom:(iks*)x
{
	return iks_next_tag(x);
}

- (NSString*)name:(iks*)x
{
	const char* c_name = iks_name(x);
	return [[[NSString alloc]initWithUTF8String:c_name] autorelease];
}

- (iks*)findNodeFrom:(iks*)x nodeName:(NSString*)name
{	
	const char *c_name = [name  UTF8String];
	return iks_find(x, c_name);
}

- (NSString*)findValueFrom:(iks*)x nodeName:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_cdata(x, c_name);
    if (c_value && strlen(c_value)>0)
    {
        return [[[NSString alloc]initWithUTF8String:c_value] autorelease];
    }
    else
    {
        return nil;
    }
}

- (NSNumber*)findValueIntFrom:(iks*)x nodeName:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_cdata(x, c_name);
	if (c_value && strlen(c_value)>0)
	{
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		NSInteger result = [tmp intValue];
		[tmp release];
		return [NSNumber numberWithInt:result];
	}
	return nil;
}

- (NSNumber*)findValueDoubleFrom:(iks*)x nodeName:(NSString*)name
{
    const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_cdata(x, c_name);
	if (c_value && strlen(c_value)>0)
	{
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		double result = [tmp doubleValue];
		[tmp release];
		return [NSNumber numberWithDouble:result];
	}
	return nil;
}

- (NSDate*)findValueTimeFrom:(iks*)x nodeName:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_cdata(x, c_name);
	if (c_value && strlen(c_value)>0)
	{
		NSTimeInterval sec;
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		sec = [tmp doubleValue]/KTimeSec;
		[tmp release];
		return [NSDate dateWithTimeIntervalSince1970:sec];
	}
	else 
	{
		return [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
	}
}

- (NSString*)valueFrom:(iks*)x
{
	const char* c_value  = iks_cdata(x);
    if (c_value && strlen(c_value)>0)
    {
        return [[[NSString alloc]initWithUTF8String:c_value] autorelease];
    }
    else
    {
        return nil;
    }
}

- (NSNumber*)valueIntFrom:(iks*)x
{
	const char* c_value  = iks_cdata(x);
	if (c_value && strlen(c_value)>0)
	{
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		NSInteger result = [tmp intValue];
		[tmp release];
		return [NSNumber numberWithInt:result];
	}
	return nil;
}

- (NSNumber*)valueDoubleFrom:(iks*)x
{
   const char* c_value  = iks_cdata(x);
	if (c_value && strlen(c_value)>0)
	{
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		double result = [tmp doubleValue];
		[tmp release];
		return [NSNumber numberWithDouble:result];
	}
	return nil;
}

- (NSDate*)valueTimeFrom:(iks*)x 
{
	const char* c_value  = iks_cdata(x);
	if (c_value && strlen(c_value)>0)
	{
		NSTimeInterval sec;
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		sec = [tmp doubleValue]/KTimeSec;
		[tmp release];
		return [NSDate dateWithTimeIntervalSince1970:sec];
	}
	else 
	{
		return [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
	}
}

- (NSString*)findAttribFrom:(iks*)x attribname:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_attrib_unescape(x, c_name);
    if (c_value && strlen(c_value)>0)
    {
        return [[[NSString alloc]initWithUTF8String:c_value] autorelease];
    }
    else
    {
        return nil;
    }
}

- (NSNumber*)findAttribIntFrom:(iks*)x attribname:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_attrib(x, c_name);
	if (c_value && strlen(c_value)>0)
	{
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		NSInteger result = [tmp intValue];
		[tmp release];
		return [NSNumber numberWithInt:result];
	}
	return nil;
}

- (NSNumber*)findAttribDoubleFrom:(iks*)x attribname:(NSString*)name
{
    const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_attrib(x, c_name);
	if (c_value && strlen(c_value)>0)
	{
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		double result = [tmp doubleValue];
		[tmp release];
		return [NSNumber numberWithDouble:result];
	}
	return nil;
}

- (NSDate*)findAttribTimeFrom:(iks*)x attribname:(NSString*)name
{
	const char *c_name = [name  UTF8String];
	const char* c_value  = iks_find_attrib(x, c_name);
	
	if (c_value && strlen(c_value)>0)
	{
		NSTimeInterval sec;
		NSString* tmp = [[NSString alloc]initWithUTF8String:c_value];
		sec = [tmp doubleValue]/KTimeSec;
		[tmp release];
		return [NSDate dateWithTimeIntervalSince1970:sec];
	}
	else 
	{
		return [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
	}
}

- (NSString*)UTF8String
{
	char* c_string = iks_string(NULL, self.xmlObject);
	NSMutableString* str= [NSMutableString stringWithUTF8String:c_string];
	iks_free(c_string);
	[str insertString:@"<?xml version='1.0' encoding='utf-8'?>" atIndex:0];
	return str;
}

- (NSInteger)length
{
	char* c_string = iks_string(NULL, self.xmlObject);
	NSInteger result = strlen(c_string);
	iks_free(c_string);
	return result;
}

- (iks*)resultData
{
	return iks_find(_xmlObject,"data");
}

- (NSString*)nameFromNode:(iks*)x
{
	char* c_name = iks_name(x);
	return [NSString stringWithCString:c_name encoding:NSUTF8StringEncoding];
}

- (NSData*)xmlData
{
    NSString* str = [self UTF8String];
	return [NSData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSInteger)numberOfTagsFromNode:(iks*)x tagName:(NSString*)name
{
    const char *c_name = [name  UTF8String];
    return iks_numberOfTags(x, c_name);
}

- (void)deleteNode:(iks *)node
{
    iks_delete(node);
}

- (void)dealloc
{
	iks_delete(_xmlObject);
	[super dealloc];
}

@end
