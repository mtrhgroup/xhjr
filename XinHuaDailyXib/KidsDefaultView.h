//
//  KidsDefaultView.h
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsService.h"
@protocol KidsCoverViewDelegate <NSObject>
-(void)loadDataForMainVC;
-(void)openADWithURL:(NSString *)url;
@end

@interface KidsDefaultView : UIView
@property(nonatomic,strong)KidsService *service;
@property(nonatomic,assign)id<KidsCoverViewDelegate>delegate;
-(void)show;
-(void)hide;
@end
