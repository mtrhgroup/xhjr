//
//  SUNViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-10-9.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController+Subclass.h"
#import "DefaultView.h"
@interface DrawerViewController : MMDrawerController
-(void)presentArtilceContentVCWithArticle:(Article *)article channel:(Channel *)channel;
-(void)presentArticleContentVCWithPushArticleID:(NSString *)articleID;
@end
