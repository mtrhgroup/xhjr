//
//  XHRequest.h
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

/**
 *  对ASI的封装
 */
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
/**
 *  Debug_LOG信息控制；
 *
 *  IS_ENABLE_DEBUG_LOG 设置为 1 ，打印请求log基本信息；
 *  IS_ENABLE_DEBUG_LOG 设置为 0 ，不打印请求log基本信息；
 */
#define IS_ENABLE_DEBUG_LOG 1

#if IS_ENABLE_DEBUG_LOG
#define kDEBUG_LOG() NSLog(@"line:(%d),%s",__LINE__,__FUNCTION__)
#define kNSLog(...)  NSLog(__VA_ARGS__)
#else
#define kDEBUG_LOG()
#define kNSLog(...)
#endif

extern NSString *const kAPI_BASE_URL;

/**
 *  ASICLient 请求回调的块声明；
 *
 *  基本的请求完成，失败，上传及下载进度 Block回调；
 */
typedef void (^KKCompletedBlock)(id JSON,NSString *stringData);
typedef void (^KKFailedBlock)(NSError *error);
typedef void (^KKProgressBlock)(float progress);


@interface XHRequest : NSObject
+(XHRequest*)shareInstance;
/**
 *  一般的get请求，无参数；
 *
 *  @param path          接口路径，不能为空；
 *  @param completeBlock 请求完成块，返回 id JSON, NSString *stringData;
 *  @param failed        请求失败块，返回 NSError *error;
 *
 *  @return 返回ASIHTTPRequest的指针，可用于 NSOperationQueue操作；
 */
- (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed;

/**
 *  一般的POST请求，有参数；
 *
 *  @param path          接口路径，不能为空；
 *  @param paramsDic     请求的参数的字典，参数可为nil, 例如：NSDictionary *params = @{@"key":@"value"}
 *  @param completeBlock 请求完成块，返回 id JSON, NSString *stringData;
 *  @param failed        请求失败块，返回 NSError *error;
 *
 *  @return 返回ASIHTTPRequest的指针，可用于 NSOperationQueue操作
 */
- (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed;
@end
