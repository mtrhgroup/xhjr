//
//  ChannelViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/14.
//
//

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "Service.h"
@interface ChannelViewController : UIViewController
@property(nonatomic,strong)Channel *channel;
-(void)buildUI;
@end
