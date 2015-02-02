//
//  Keyword.h
//  XinHuaDailyXib
//
//  Created by apple on 14/12/12.
//
//

#import <Foundation/Foundation.h>
#import "KeywordMO.h"
@interface Keyword : NSObject
@property(nonatomic,strong)NSString *keyword_id;
@property(nonatomic,assign)NSInteger keyword_sort;
@property(nonatomic,strong)NSString *keyword_name;
-(id)initWithKeywordMO:(KeywordMO *)keywordMO;
-(void)toKeywordMO:(KeywordMO *)keywordMO;
@end
