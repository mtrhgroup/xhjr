//
//  PictureNewsBuilder.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import "PictureNewsBuilder.h"
#import "XDailyItem.h"
#import "PictureNews.h"
#import "PictureView.h"
@implementation PictureNewsBuilder
+(PictureNews *)picturenewsFromXDailyItem:(XDailyItem *)item{
    NSString *imgURL;
    NSString *articleURL;
    NSString *thumbnailURL;
    if(item.thumbnail!=nil){
        NSLog(@"original thumbnail url%@",item.thumbnail);
        NSString *thumbnail_file=[[item.thumbnail stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
        thumbnailURL=[[[[item localPath] stringByDeletingLastPathComponent] stringByAppendingString:@"/Imgs/"]  stringByAppendingString:thumbnail_file];
    }
    if(item.attachments!=nil){
        NSArray* tmpArray=[item.attachments componentsSeparatedByString:@";"];
        NSString *picturefilename=[[[tmpArray objectAtIndex:0]  stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
        imgURL=[[[[item localPath] stringByDeletingLastPathComponent] stringByAppendingString:@"/Imgs/"]  stringByAppendingString:picturefilename];
        NSString* filename=[[item.pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
        articleURL=[[[item localPath] stringByAppendingString:@"/" ] stringByAppendingString:filename];
        
    }        
        PictureNews *pic_news=[[PictureNews alloc]initWithXdaily:item];
        pic_news.picture_title=item.title;
        pic_news.picture_view=[[PictureView alloc]init];
        pic_news.picture_view.imageUrl=thumbnailURL;
        pic_news.articel_url=articleURL;
        pic_news.picture_url=imgURL;
        return pic_news;
}

@end
