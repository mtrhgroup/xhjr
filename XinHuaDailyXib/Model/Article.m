//
//  Article.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Article.h"

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
-(NSString *)page_path{
    
}
-(NSString *)zip_path{
    
}
-(BOOL)is_cached{
    
}
-(id)initWithArticleMO:(ArticleMO *)articleMO{
    self=[super init];
    if(self){
        self.article_id=articleMO.a_article_id;
        self.article_title=articleMO.a_article_title;
        self.page_url=articleMO.a_page_url;
        self.zip_url=articleMO.a_zip_url;
        self.publish_date=articleMO.a_publish_date;
        self.is_read=(BOOL)[articleMO.a_is_read intValue];
        self.is_collected=(BOOL)[articleMO.a_is_collected intValue];
        self.channel_id=articleMO.a_channel_id;
        self.channel_name=articleMO.a_channel_name;
        self.attachments=articleMO.a_attachments;
        self.summary=articleMO.a_summary;
        self.thumbnail_url=articleMO.a_thumbnail_url;
        self.cover_image_url=articleMO.a_cover_image_url;
        self.is_push=(BOOL)[articleMO.a_is_push intValue];
        self.video_url=articleMO.a_video_url;
        self.visit_number=articleMO.a_visit_number;
        self.like_number=articleMO.a_like_number;
        
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
    articleMO.a_is_collected=[NSNumber numberWithBool:self.is_collected];
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
}
@end
