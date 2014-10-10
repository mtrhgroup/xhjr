//
//  Article.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>

@interface Article : NSManagedObject
//文章ID
@property(nonatomic,strong)NSString*      article_id;
//文章标题
@property(nonatomic,strong)NSString*      article_title;
//文章主页URL
@property(nonatomic,strong)NSString*      page_url;
//文章zip包URL
@property(nonatomic,strong)NSString*      zip_url;
//发布时间,文章排序用
@property(nonatomic,strong)NSString*      publish_date;
//已读未读
@property(nonatomic,assign)BOOL           is_read;
//是否收藏
@property(nonatomic,assign)BOOL           is_collected;
//所属频道id
@property(nonatomic,strong)NSString*      channel_id;
//所属频道名称
@property(nonatomic,strong)NSString*      channel_name;
//附件
@property(nonatomic,strong)NSString*      attachments;
//摘要
@property(nonatomic,strong)NSString*      summary;
//缩略图
@property(nonatomic,strong)NSString*      thumbnail_url;
//封面图
@property(nonatomic,strong)NSString*      cover_image_url;
//文章中视频文件URL
@property(nonatomic,assign)NSString*      video_url;
//是否为推送文章
@property(nonatomic,assign)BOOL           is_push;
//文章访问数量
@property(nonatomic,strong)NSNumber*      visit_number;
//文章点赞数量
@property(nonatomic,strong)NSNumber*      like_number;

@end
