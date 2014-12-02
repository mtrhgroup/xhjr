//
//  Article.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Article.h"
#import "FSManager.h"
@implementation Article
@synthesize  article_id=_article_id;
@synthesize  article_title=_article_title;
@synthesize  page_url=_page_url;
@synthesize  zip_url=_zip_url;
@synthesize  publish_date=_publish_date;
@synthesize  is_read=_is_read;
@synthesize  is_collected=_is_collected;
@synthesize  channel_id=_channel_id;
@synthesize  channel_name=_channel_name;
@synthesize  attachments=_attachments;
@synthesize  summary=_summary;
@synthesize  thumbnail_url=_thumbnail_url;
@synthesize  cover_image_url=_cover_image_url;
@synthesize  is_push=_is_push;
@synthesize  video_url=_video_url;
@synthesize  visit_number=_visit_number;
@synthesize  like_number=_like_number;
@synthesize  is_like=_is_like;
@synthesize  key_words=_key_words;
@synthesize comments_number=_comments_number;

-(NSString *)page_path{
    NSString *dir_path=[self.zip_path stringByDeletingPathExtension];
    NSString *page_file_name=[self.page_url lastPathComponent];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",dir_path,page_file_name]);
    return [NSString stringWithFormat:@"%@/%@",dir_path,page_file_name];
}
-(NSString *)zip_path{
    NSString* zip_file_name = [self.zip_url lastPathComponent];
    return [NSString stringWithFormat:@"%@/%@",AppDelegate.service.fs_manager.article_cache_dir_path,zip_file_name];
}
-(NSString *)article_content_id{
    NSString *page_file_name=[self.page_url lastPathComponent];
    return [page_file_name stringByDeletingPathExtension];
}
-(BOOL)is_cached{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.page_path];
}
-(id)initWithArticleMO:(ArticleMO *)articleMO{
    self=[super init];
    if(self){
        self.article_id=articleMO.a_article_id;
        self.article_title=articleMO.a_article_title;
        self.page_url=articleMO.a_page_url;
        self.zip_url=articleMO.a_zip_url;
        NSLog(@"%@",articleMO.a_publish_date);
        self.publish_date=articleMO.a_publish_date;
        self.is_read=[articleMO.a_is_read boolValue];
        self.is_collected=[articleMO.a_is_collected boolValue];
        self.channel_id=articleMO.a_channel_id;
        self.channel_name=articleMO.a_channel_name;
        self.attachments=articleMO.a_attachments;
        self.summary=articleMO.a_summary;
        self.thumbnail_url=articleMO.a_thumbnail_url;
        self.cover_image_url=articleMO.a_cover_image_url;
        self.is_push=[articleMO.a_is_push boolValue];
        self.video_url=articleMO.a_video_url;
        self.visit_number=articleMO.a_visit_number;
        self.like_number=articleMO.a_like_number;
        self.is_like=[articleMO.a_is_like boolValue];
        self.key_words=articleMO.a_key_words;
        self.comments_number=articleMO.a_comments_number;
        
    }
    return self;
}
-(void)toArticleMO:(ArticleMO *)articleMO{
    articleMO.a_article_id=self.article_id;
    articleMO.a_article_title=self.article_title;
    articleMO.a_page_url=self.page_url;
    articleMO.a_zip_url=self.zip_url;
    articleMO.a_publish_date=self.publish_date;
    articleMO.a_is_read=[NSNumber numberWithBool:self.is_read];
    //articleMO.a_is_collected=[NSNumber numberWithBool:self.is_collected];
    articleMO.a_channel_id=self.channel_id;
    articleMO.a_channel_name=self.channel_name;
    articleMO.a_attachments=self.attachments;
    articleMO.a_summary=self.summary;
    articleMO.a_thumbnail_url=self.thumbnail_url;
    articleMO.a_cover_image_url=self.cover_image_url;
    articleMO.a_is_push=[NSNumber numberWithBool:self.is_push];
    articleMO.a_video_url=self.video_url;
    articleMO.a_visit_number=self.visit_number;
    articleMO.a_like_number=self.like_number;
    //articleMO.a_is_like=[NSNumber numberWithBool:self.is_like];
    articleMO.a_key_words=self.key_words;
    articleMO.a_comments_number=self.comments_number;
}
@end
@implementation ArticlesForCVC
@synthesize header_article=_header_article;
@synthesize other_articles=_other_articles;
@end
@implementation ArticlesForHVC
@synthesize header_article=_header_article;
@synthesize other_articles=_other_articles;
-(NSString *)lastPublicDateInChannelWithChannelID:(NSString *)channel_id{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *future_time=[formatter stringFromDate:[NSDate distantFuture]];
    if(_other_articles==nil||[_other_articles count]==0)return future_time;
    for(int i=[_other_articles count]-1;i>=0;i--){
        if([((Article *)[_other_articles objectAtIndex:i]).channel_id isEqualToString:channel_id]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSDate *last_date=[dateFormatter dateFromString:((Article *)[_other_articles objectAtIndex:i]).publish_date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *last_one_time=[formatter stringFromDate:last_date];
            return last_one_time;
        }
    }
    return future_time;
}
@end
@implementation DailyArticles
@synthesize date;
@synthesize articles;
@synthesize previous_date;
@synthesize next_date;
@end
