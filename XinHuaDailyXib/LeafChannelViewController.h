//
//  LeafChannelViewController.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-14.
//
//

#import <UIKit/UIKit.h>
#import "ChannelViewController.h"
@interface LeafChannelViewController : ChannelViewController
@property(nonatomic,strong)NSMutableArray *articles;
-(void)reloadArticlesFromDB;
-(void)reloadArticlesFromNET;
-(void)loadMoreArticlesFromNET;
-(void)refreshUI;
@end
