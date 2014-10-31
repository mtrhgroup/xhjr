//
//  ChannelCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/21.
//
//

#import "ChannelCell.h"

@implementation ChannelCell{
    Channel *_channel;
    UIImageView *_new_view;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.textLabel setFont: [UIFont boldSystemFontOfSize:25]];
        self.textLabel.textColor=[UIColor whiteColor];
        self.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
        _new_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new.png"]];
        _new_view.frame=CGRectMake(100, 5, 16, 16);
        _new_view.hidden=YES;
        [[self contentView] addSubview:_new_view];
    }
    return self;
}
-(Channel *)channel{
    return _channel;
}
-(void)setChannel:(Channel *)channel{
    _channel=channel;
    self.textLabel.text=channel.channel_name;
    CGPoint lastPoint=[self lastPointWithLabel:self.textLabel];
    _new_view.frame=CGRectMake(lastPoint.x, 5, 16, 16);
    if(_channel.has_new_articles){
        _new_view.hidden=NO;
    }else{
        _new_view.hidden=YES;
    }
}
-(CGPoint)lastPointWithLabel:(UILabel *)label{
    CGSize sz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
    CGSize linesSz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if(sz.width <= linesSz.width){
      return  CGPointMake(label.frame.origin.x + sz.width, label.frame.origin.y);
    }
    else{
       return CGPointMake(label.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - sz.height);
    }
}

@end
