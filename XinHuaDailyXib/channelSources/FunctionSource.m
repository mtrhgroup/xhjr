//
//  functionSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-15.
//
//

#import "FunctionSource.h"

@implementation FunctionSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* str = @"cellid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellAccessoryNone;
    if (indexPath.row == 0){
        UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 60,60)];
        UIImage *favor_image=[UIImage imageNamed:@"favor.png"];
        [favorBtn setImage:favor_image forState:UIControlStateNormal];
        favorBtn.showsTouchWhenHighlighted=YES;
        [favorBtn  addTarget:self action:@selector(showFavors) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:favorBtn];
        
        UILabel *FavorLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 25)];
        FavorLbl.text=@"我的收藏";
        FavorLbl.textColor = [UIColor blackColor];
        FavorLbl.font = [UIFont fontWithName:@"System" size:17];
        FavorLbl.textAlignment=NSTextAlignmentCenter;
        FavorLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:FavorLbl];
        
        UIButton* settingsBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 15, 60,60)];
        UIImage *settings_image=[UIImage imageNamed:@"settings.png"];
        [settingsBtn setImage:settings_image forState:UIControlStateNormal];
        settingsBtn.showsTouchWhenHighlighted=YES;
        [settingsBtn  addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:settingsBtn];
        
        UILabel *SettingsLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 75, 80, 25)];
        SettingsLbl.text=@"管理设置";
        SettingsLbl.textAlignment=NSTextAlignmentCenter;
        SettingsLbl.textColor = [UIColor blackColor];
        SettingsLbl.font = [UIFont fontWithName:@"System" size:17];
        SettingsLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:SettingsLbl];

    }else if(indexPath.row == 1){
        UIButton* feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 60,60)];
        UIImage *feedback_image=[UIImage imageNamed:@"ext_feedback.png"];
        [feedbackBtn setImage:feedback_image forState:UIControlStateNormal];
        feedbackBtn.showsTouchWhenHighlighted=YES;
        [feedbackBtn  addTarget:self action:@selector(showPushNews) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:feedbackBtn];
        
        UILabel *feedbackLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 25)];
        feedbackLbl.text=@"消息汇总";
        feedbackLbl.textAlignment=NSTextAlignmentCenter;
        feedbackLbl.textColor = [UIColor blackColor];
        feedbackLbl.font = [UIFont fontWithName:@"System" size:17];
        feedbackLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:feedbackLbl];
        
        UIButton* aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 15, 60,60)];
        UIImage *about_image=[UIImage imageNamed:@"about.png"];
        [aboutBtn setImage:about_image forState:UIControlStateNormal];
        aboutBtn.showsTouchWhenHighlighted=YES;
        [aboutBtn  addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:aboutBtn];
        
        UILabel *aboutLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 75, 80, 25)];
        aboutLbl.text=@"客服电话";
        aboutLbl.textAlignment=NSTextAlignmentCenter;
        aboutLbl.textColor = [UIColor blackColor];
        aboutLbl.font = [UIFont fontWithName:@"System" size:17];
        aboutLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:aboutLbl];
    }else if(indexPath.row==2){
    }
    return cell;
}
-(void)showFavors{
    NSNotification *note=[NSNotification notificationWithName:ShowFavorNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)showPushNews{
    NSNotification *note=[NSNotification notificationWithName:ShowPushNewsNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)showSettings{
    NSNotification *note=[NSNotification notificationWithName:ShowSettingsNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)showAbout{
    NSNotification *note=[NSNotification notificationWithName:ShowAboutNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

NSString *ShowAboutNotification=@"ShowAboutNotification";
NSString *ShowFavorNotification=@"ShowFavorNotification";
NSString *ShowFeedBackNotification=@"ShowFeedBackNotification";
NSString *ShowSettingsNotification=@"ShowSettingsNotification";
NSString *ShowPushNewsNotification=@"ShowPushNewsNotification";

@end
