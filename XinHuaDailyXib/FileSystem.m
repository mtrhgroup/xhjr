//
//  FileSystem.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-12.
//
//

#import "FileSystem.h"

@implementation FileSystem
static FileSystem *_system=nil;
+(FileSystem *)system{
    if(_system==nil){
        _system=[[FileSystem alloc]init];
    }
    return _system;
}
-(void)removeArticle:(Article *)article{
    
}
-(BOOL)isArticleExistWithArticle:(Article *)article{
    return NO;
}
@end