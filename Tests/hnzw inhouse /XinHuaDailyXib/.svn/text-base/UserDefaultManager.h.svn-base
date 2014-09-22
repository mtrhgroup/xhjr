//
//  UserDefaultManager.h
//  XDailyNews
//
//  Created by peiqiang li on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
@interface UserDefaultManager : NSObject
{
    NSUserDefaults          *_defaults;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(UserDefaultManager);

- (BOOL)boolForKey:(NSString*)key defaultValue:(BOOL)defaultValue;
- (NSInteger)intForKey:(NSString*)key defaultValue:(NSInteger)defaultValue;
- (double)doubleForKey:(NSString*)key defaultValue:(double)defaultValue;
- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;
- (NSDate*)dateForKey:(NSString*)key defaultValue:(NSDate*)defaultValue;
- (NSObject*)valueForKey:(NSString*)key defaultValue:(NSObject*)defaultValue;

- (void)setBool:(BOOL)value forKey:(NSString*)key;
- (void)setInt:(NSInteger)value forKey:(NSString*)key;
- (void)setDouble:(double)value forKey:(NSString*)key;
- (void)setString:(NSString*)value forKey:(NSString*)key;
- (void)setDate:(NSDate*)value forKey:(NSString*)key;
- (void)setData:(NSObject*)value forKey:(NSString*)key;
- (void)setValue:(NSObject*)value forKey:(NSString*)key;

@end
