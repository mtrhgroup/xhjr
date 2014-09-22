//
//  CommonMethod.m
//  Youlu
//
//  Created by William on 10-10-22.
//  Copyright 2010 Youlu . All rights reserved.
//
#import "CommonMethod.h"


static NSString* __key = nil;
static NSString* __mcc = nil;

@interface CommonMethod(inner)

+(NSInteger) fibonacci:(NSInteger) index;

@end


@implementation CommonMethod(inner)


+(NSInteger) fibonacci:(NSInteger) index
{
	int a = 1;
	int b = 1;
	int c = 0;
	for (int i = 1; i < index; i++) 
	{
		c = a + b;
		a = b;
		b = c;
	}
	return c;
}

@end

@implementation CommonMethod


+(NSString*)fileWithTempPath:(NSString*)filePath
{
    NSString* path = [NSTemporaryDirectory()stringByAppendingString:filePath];
    LoggerS(path);
	return path;
}

+(NSString*)fileWithUploadPath:(NSString*)filePath
{
    return [CommonMethod fileWithDocumentsPath:[NSString stringWithFormat:@"upload/%@",filePath]];
}

+(NSString*)fileWithDocumentsPath:(NSString*)filePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dcoumentpath = ([paths count] > 0)? [paths objectAtIndex:0] : nil;
        //assert (dcoumentpath); 
	
	NSMutableString* result = [NSMutableString stringWithCapacity:3];
	[result appendString:dcoumentpath];
    if ([result compare:@"/var/mobile/Documents"] == 0)
    {
        [result appendFormat:@"/Youlu"];
    }
	[result appendString:@"/"];
	[result appendString:filePath];
	
	NSRange range = [result rangeOfString:@"/" options:NSBackwardsSearch];
    NSString* dirPath = [result substringToIndex:range.location];
	
	NSFileManager *NSFm= [NSFileManager defaultManager];
	[NSFm createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    return result;
}


+(NSInteger) fileSize:(NSString*) filePath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];  
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];  	
	if (fileAttributes != nil) 
	{  
		return [[fileAttributes objectForKey:NSFileSize] intValue];
	}
	else 
	{
		return 0;
	}
}
@end
