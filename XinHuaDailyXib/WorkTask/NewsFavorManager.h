//
//  NewsFavorManager.h
//  CampusNewsLetter
//
//  Created by apple on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFavorManager : NSObject
+(NewsFavorManager *)sharedInstance;
-(BOOL)iscollected:(UIWebView *)webview;
-(void)saveArticle:(UIWebView *)webview;
-(void)removeArticle:(UIWebView *)webview;
-(NSMutableArray *)allArticleTitle;
-(NSMutableArray *)allArticleURL;
-(void)removeAll;
-(void)removeArticleWithTitle:(NSString *)title;
@end
