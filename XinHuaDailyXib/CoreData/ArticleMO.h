//
//  ArticleMO.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArticleMO : NSManagedObject

@property (nonatomic, retain) NSString * a_article_id;
@property (nonatomic, retain) NSString * a_article_title;
@property (nonatomic, retain) NSString * a_attachments;
@property (nonatomic, retain) NSString * a_channel_id;
@property (nonatomic, retain) NSString * a_channel_name;
@property (nonatomic, retain) NSString * a_cover_image_url;
@property (nonatomic, retain) NSNumber * a_is_push;
@property (nonatomic, retain) NSNumber * a_is_read;
@property (nonatomic, retain) NSNumber * a_like_number;
@property (nonatomic, retain) NSString * a_page_url;
@property (nonatomic, retain) NSString * a_publish_date;
@property (nonatomic, retain) NSString * a_summary;
@property (nonatomic, retain) NSString * a_thumbnail_url;
@property (nonatomic, retain) NSString * a_video_url;
@property (nonatomic, retain) NSNumber * a_visit_number;
@property (nonatomic, retain) NSString * a_zip_url;
@property (nonatomic, retain) NSNumber * a_is_collected;

@end
