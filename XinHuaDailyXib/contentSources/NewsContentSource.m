//
//  NewsSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-14.
//
//

#import "NewsContentSource.h"

@implementation NewsContentSource
@synthesize title;
@synthesize siblings=_siblings;
@synthesize index=_index;

-(int)moveDownIndex{
    if(self.index==[self.siblings count]-1){
        _index=0;
    }else{
        _index++;
    }
    return _index;
}
-(int)moveUpIndex{
    if(self.index==0){
        _index=[self.siblings count]-1;
    }else{
        _index--;
    }
    return _index;
}
-(NSURL *)get_current_news{
    return [self makeURLwith:[self.siblings objectAtIndex:_index]];
}
-(NSURL *)get_previous_news{
    if(index==0){
        return [self makeURLwith:[self.siblings objectAtIndex:[self.siblings count]-1]];
    }
    else{
        return [self makeURLwith:[self.siblings objectAtIndex:_index-1]];
    }
    return nil;
}
-(NSURL *)get_next_news{
    if(_index==[self.siblings count]-1)return [self makeURLwith:[self.siblings objectAtIndex:0]];
    else return [self makeURLwith:[self.siblings objectAtIndex:_index+1]];
    return nil;
}
-(NSURL *)makeURLwith:(id)item{
    return nil;
}
@end
