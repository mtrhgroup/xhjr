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
#import "TouchViewDelegate.h"
@interface ChannelViewController : UIViewController<TouchViewDelegate>
@property(nonatomic,strong)Channel *channel;
@property(nonatomic,strong)Service *service;
-(void)buildUI;
@end
