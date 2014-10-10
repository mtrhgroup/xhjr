//
//  Parser.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import "VersionInfo.h"

@interface Parser : NSObject
-(NSArray*)parseChannels:(NSString *) xmlstring;
-(NSArray*)parseArticles:(NSString *)xmlstring;
-(NSArray *)parseMoreXdailyItems:(NSString *)xmlstring;
-(XDailyItem*)parseXDailyItem:(NSString *)xmlstring;
-(VersionInfo *)parseVersionInfo:(NSString *)xmlstring;
-(NSArray *)parseModifyActions:(NSString *)xmlstring;
@end
