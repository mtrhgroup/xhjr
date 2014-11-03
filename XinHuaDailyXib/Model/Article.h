//
//  Article.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import "ArticleMO.h"
@interface Article : NSObject
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
@property(nonatomic,strong)NSString*      video_url;
//是否为推送文章
@property(nonatomic,assign)BOOL           is_push;
//文章访问数量
@property(nonatomic,strong)NSNumber*      visit_number;
//文章点赞数量
@property(nonatomic,strong)NSNumber*      like_number;
//计算属性 页面的本地存储地址
@property(nonatomic,readonly)NSString*    page_path;
//计算属性 zip包下载地址
@property(nonatomic,readonly)NSString*    zip_path;
//计算属性 是否有缓存
@property(nonatomic,readonly)BOOL         is_cached;
//是否点赞
@property(nonatomic,assign)BOOL           is_like;

-(id)initWithArticleMO:(ArticleMO *)articleMO;
-(void)toArticleMO:(ArticleMO *)articleMO;
@end
@interface ArticlesForCVC : NSObject
@property(nonatomic,strong)Article *header_article;
@property(nonatomic,strong)NSArray *other_articles;
@end
