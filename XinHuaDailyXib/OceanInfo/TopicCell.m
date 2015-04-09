//
//  UITopicCell.m
//  XinHuaDailyXib
//
//  Created by 张健 on 15-2-9.
//
//

#import "TopicCell.h"
#import "ALImageView.h"
@implementation TopicCell{
    ALImageView *topic_channel_icon;
    float cell_width;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    cell_width=[[UIScreen mainScreen] applicationFrame].size.width;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        topic_channel_icon = [[ALImageView alloc] initWithFrame:CGRectMake(5, 5, cell_width-10, 94-10)];
        topic_channel_icon.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:topic_channel_icon];
        
    }
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 94, cell_width, 1)];
    line_view.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line_view];
    return self;
}
-(void)setTopChannel:(Channel *)channel{
    topic_channel_icon.imageURL=channel.icon_url;
}
+(CGFloat)preferHeight{
    return 95;
}
@end
