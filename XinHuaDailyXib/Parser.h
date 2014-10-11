//
//  Parser.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"

@interface Parser : NSObject
-(NSArray*)parseChannels:(NSString *) xmlstring;
-(NSArray*)parseArticles:(NSString *)xmlstring;
-(NSArray *)parseMoreXdailyItems:(NSString *)xmlstring;
-(XDailyItem*)parseOneArticle:(NSString *)xmlstring;
-(AppInfo *)parseAppInfo:(NSString *)xmlstring;
-(NSArray *)parseModifyActions:(NSString *)xmlstring;
@end
