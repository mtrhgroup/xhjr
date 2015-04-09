//
//  Keyword.m
//  XinHuaDailyXib
//
//  Created by apple on 14/12/12.
//
//

#import "Keyword.h"

@implementation Keyword
-(id)initWithKeywordMO:(KeywordMO *)keywordMO{
    self=[super init];
    if(self){
        self.keyword_id=keywordMO.a_keyword_id;
        self.keyword_sort=[keywordMO.a_keyword_sort integerValue];
        self.keyword_name=keywordMO.a_keyword_name;
    }
    return self;
}
-(void)toKeywordMO:(KeywordMO *)keywordMO{
    keywordMO.a_keyword_id=self.keyword_id;
    keywordMO.a_keyword_sort=[NSNumber numberWithInteger:self.keyword_sort];
    keywordMO.a_keyword_name=self.keyword_name;

}
@end
