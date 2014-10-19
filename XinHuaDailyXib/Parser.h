//
//  Parser.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"
#import "Article.h"
@interface Parser : NSObject
-(NSArray *)parseChannels:(NSString *) xmlstring;
-(NSArray *)parseArticles:(NSString *)xmlstring;
-(NSArray *)parseMoreArticles:(NSString *)xmlstring;
-(Article *)parseOneArticle:(NSString *)xmlstring;
-(AppInfo *)parseAppInfo:(NSString *)xmlstring;
-(NSArray *)parseCommands:(NSString *)xmlstring;
@end
