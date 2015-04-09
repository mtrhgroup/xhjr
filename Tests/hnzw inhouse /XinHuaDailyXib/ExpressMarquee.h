//
//  MyMarquee.h
//  XinHuaDailyXib
//
//  Created by apple on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressMarquee : UIView
@property(nonatomic,retain)NSDictionary *showText;
@property(nonatomic,retain)UILabel *labelText;
@property(nonatomic,assign)int showLap;
@property(nonatomic,assign)int moveWidth;
-(void)calculateShowFrame;
@end
