//
//  PictureNewsSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-14.
//
//

#import "PictureNewsSource.h"
#import "PictureNews.h"
@implementation PictureNewsSource
-(NSURL *)makeURLwith:(id)item{
    return  [NSURL fileURLWithPath:((PictureNews *)item).articel_url];
}
@end
