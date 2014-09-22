//
//  UserDefaultManager.m
//  XDailyNews
//
//  Created by peiqiang li on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager
SYNTHESIZE_SINGLETON_FOR_CLASS(UserDefaultManager);
- (id)init
{
    self = [super init];
    if (self)
    {
        _defaults  = [NSUserDefaults standardUserDefaults];
        [_defaults retain];
    }
    return self;
}

- (void)dealloc
{
    [_defaults release];
    [super dealloc];
}


- (void)initialize
{
	/*just a place holder funcation*/
}

- (BOOL)boolForKey:(NSString*)key defaultValue:(BOOL)defaultValue
{
	NSNumber* result = [_defaults objectForKey:key];
	if (result)
	{
		return [result boolValue];
	}
	else
	{
		return defaultValue;
	}
}

- (NSInteger)intForKey:(NSString*)key defaultValue:(NSInteger)defaultValue
{
	NSNumber* result = [_defaults objectForKey:key];
	if (result)
	{
		return [result intValue];
	}
	else
	{
		return defaultValue;
	}
}

- (double)doubleForKey:(NSString*)key defaultValue:(double)defaultValue
{
	NSNumber* result = [_defaults objectForKey:key];
	if (result)
	{
		return [result doubleValue];
	}
	else
	{
		return defaultValue;
	}
}

- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue
{
	NSString* result = [_defaults stringForKey:key];
	if (!result)
    {
		result = defaultValue;
	}
	return result;
}

- (NSDate*)dateForKey:(NSString*)key defaultValue:(NSDate*)defaultValue
{
	NSDate* result = [_defaults objectForKey:key];
	if (!result)
    {
		result = defaultValue;
	}
	return result;
}

- (NSObject*)valueForKey:(NSString*)key defaultValue:(NSObject*)defaultValue
{
    NSObject* result = [_defaults objectForKey:key];
	if (!result)
    {
		result = defaultValue;
	}
	return result;
    
}

- (void)setBool:(BOOL)value forKey:(NSString*)key
{
	[_defaults setObject:[NSNumber numberWithBool:value] forKey:key];
	[_defaults synchronize];
}

- (void)setInt:(NSInteger)value forKey:(NSString*)key
{
	[_defaults setObject:[NSNumber numberWithInteger:value] forKey:key];	
	[_defaults synchronize];
}

- (void)setDouble:(double)value forKey:(NSString*)key
{
	[_defaults setObject:[NSNumber numberWithDouble:value] forKey:key];	
	[_defaults synchronize];
}

- (void)setString:(NSString*)value forKey:(NSString*)key
{
	[_defaults setObject:value forKey:key];
	[_defaults synchronize];
}

- (void)setDate:(NSDate*)value forKey:(NSString*)key
{
	[_defaults setObject:value forKey:key];
	[_defaults synchronize];
}

- (void)setData:(NSObject*)value forKey:(NSString*)key
{
	[_defaults setObject:value forKey:key];
	[_defaults synchronize];
}

- (void)setValue:(NSObject *)value forKey:(NSString *)key
{
	[_defaults setObject:value forKey:key];
	[_defaults synchronize];
}

@end
