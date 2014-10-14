//
//  NotificationCenter.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-11.
//
//

#import "NotificationCenter.h"
#define kMessage @"message"
#define kArticle_received @"article_received"
@implementation NotificationCenter
static NotificationCenter *_center=nil;
+(NotificationCenter *)center{
    if(_center==nil){
        _center=[[NotificationCenter alloc]init];
    }
    return _center;
}
-(void)postMessageNotificationWithMessage:(NSString *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName: kMessage object: message ];
}
-(void)addMessageNotificationObserver:(id)observer selector:(SEL)aSelector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kMessage object:nil];
}
-(void)removeMessageNotificationObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kMessage object:nil];
}
-(void)postArticleReceivedNotificationWithArticle:(Article *)article{
    [[NSNotificationCenter defaultCenter] postNotificationName: kArticle_received object: article ];
}
-(void)addArticleReceivedNotificationObserver:(id)observer selector:(SEL)aSelector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kArticle_received object:nil];
}
-(void)removeArticleReceivedNotificationObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kArticle_received object:nil];
}
@end
