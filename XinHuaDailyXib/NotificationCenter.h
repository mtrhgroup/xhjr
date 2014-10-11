//
//  NotificationCenter.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-11.
//
//

#import <Foundation/Foundation.h>
#import "Article.h"
@interface NotificationCenter : NSObject
+(NotificationCenter *)center;
-(void)postMessageNotificationWithMessage:(NSString *)message;
-(void)addMessageNotificationObserver:(id)observer selector:(SEL)aSelector;
-(void)removeMessageNotificationObserver:(id)observer;
-(void)postArticleReceivedNotificationWithArticle:(Article *)article;
-(void)addArticleReceivedNotificationObserver:(id)observer selector:(SEL)aSelector;
-(void)removeArticleReceivedNotificationObserver:(id)observer;
@end
