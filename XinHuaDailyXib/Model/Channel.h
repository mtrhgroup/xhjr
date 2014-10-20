//
//  Channel.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import "ChannelMO.h"
typedef NS_ENUM(NSInteger, ShowType)
{
    List = 0,
    Tile = 1,
    Grid = 2
    
};
@interface Channel : NSObject
//频道ID
@property(nonatomic,strong)NSString* channel_id;
//频道名称
@property(nonatomic,strong)NSString* channel_name;
//频道描述信息
@property(nonatomic,strong)NSString* description;
//频道排序权值，数字越小，显示位置越靠前
@property(nonatomic,strong)NSNumber* sort_number;
//叶子频道的文章显示样式，非叶子频道属性无效
@property(nonatomic,assign)ShowType show_type;
//首页显示文章的条数
@property(nonatomic,strong)NSNumber *home_number;
//上层频道ID
@property(nonatomic,strong)NSString *parent_id;
//是否为叶子频道
@property(nonatomic,assign)BOOL is_leaf;
//是否有新的文章
@property(nonatomic,assign)BOOL has_new_article;
//栏目内的文章，非叶子频道属性无效
@property(nonatomic,strong)NSArray *articles;
//是否需要授权
@property(nonatomic,assign)BOOL need_be_authorized;

-(id)initWithChannelMO:(ChannelMO *)channelMO;
-(void)toChannelMO:(ChannelMO *)channelMO;
@end
@interface ChannelsForHVC : NSObject
@property(nonatomic,strong)NSArray *header_articles;
@property(nonatomic,strong)NSArray *other_channels;
@end
