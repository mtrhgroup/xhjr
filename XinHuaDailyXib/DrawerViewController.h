//
//  SUNViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-10-9.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController+Subclass.h"
#import "KidsDefaultView.h"
@interface DrawerViewController : MMDrawerController<KidsCoverViewDelegate>
-(void)setTopTitle:(NSString *)title;
-(void)presentArtilceContentVCWithArticle:(KidsArticle *)article channel:(KidsChannel *)channel;
-(void)presentClassListVCWithChannel:(KidsChannel *)channel;
-(void)presentArticleContentVCWithPushArticleID:(NSString *)articleID;
-(NSMutableArray *)appendOriginalChannels:(NSArray*)channels;
@end
