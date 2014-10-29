//
//  FSManager.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/29.
//
//

#import <Foundation/Foundation.h>

@interface FSManager : NSObject
@property(nonatomic,readonly)NSString *article_cache_dir_path;
-(NSString *)sizeOfArticleCache;
-(void)clearArticleCache;
@end
