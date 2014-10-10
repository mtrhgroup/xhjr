//
//  DailyNews.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DailyNews : NSManagedObject

@property (nonatomic, retain) NSNumber * article_id;
@property (nonatomic, retain) NSString * attachments;
@property (nonatomic, retain) UNKNOWN_TYPE attribute;
@property (nonatomic, retain) NSString * channel_id;
@property (nonatomic, retain) NSString * channel_name;
@property (nonatomic, retain) NSNumber * is_push;
@property (nonatomic, retain) NSNumber * is_read;
@property (nonatomic, retain) NSNumber * like_number;
@property (nonatomic, retain) NSString * page_url;
@property (nonatomic, retain) NSNumber * publish_date;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * article_title;
@property (nonatomic, retain) UNKNOWN_TYPE video_url;
@property (nonatomic, retain) NSString * zip_url;
@property (nonatomic, retain) UNKNOWN_TYPE visit_number;
@property (nonatomic, retain) UNKNOWN_TYPE cover_image_url;

@end
