//
//  SettingViewController.m
//  XinHuaDailyXib
//
//  Created by 耀龙 马 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "NewsBufferSettingViewController.h"
#import "NewsFontSettingViewController.h"
#import "NewsStatistsViewController.h"
#import "ContactUsViewController.h"
#import "NavigationController.h"

@interface SettingViewController ()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation SettingViewController

@synthesize table_view;
@synthesize labBuff;
@synthesize labFont;
@synthesize byteslostLabel;
@synthesize waitingAlert;
@synthesize timer=_timer;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:KSettingChange object:nil];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"管理设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    table_view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    table_view.delegate = self;
    table_view.dataSource = self;
    [self.view addSubview:table_view];
    [self makeWaitingAlert];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.table_view reloadData];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=@"";
    if(section==0){
        temp=@"缓存管理";
    }else if(section==1){
        temp=@"显示管理";
    }else if(section==2){
        temp=@"流量统计";
    }else if(section==3){
        temp=@"其他";
    }
    return temp;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 2;
    }else if(section==1){
        return 2;//2:夜间模式
    }else if(section==2){
        return 1;
    }else if(section==3){
        return 1;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* str = @"cellid";
    UITableViewCell* cell = [table_view dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
       
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            
            UILabel *cache_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.table_view.bounds.size.width-100,0,  60, 44)];
            cache_lbl.text=AppDelegate.user_defaults.cache_article_number;
            cache_lbl.textColor=[UIColor grayColor];
            cache_lbl.textAlignment=NSTextAlignmentRight;
            [[cell contentView] addSubview:cache_lbl];
            cell.textLabel.text = @"缓存资讯条数";
            
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"清理缓存";    
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            labFont = [[UILabel alloc] initWithFrame:CGRectZero];
            labFont.text=AppDelegate.user_defaults.font_size;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView=labFont;
            cell.textLabel.text = @"字体大小"; 
        }else if(indexPath.row==1){
            NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
            if(displayMode==nil)
                cell.textLabel.text = @"夜间模式";
            else
                cell.textLabel.text=displayMode;
            cell.accessoryType=UITableViewCellAccessoryNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:AppDelegate.user_defaults.is_night_mode_on animated:YES];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            byteslostLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
            NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
            int bytesLostOfThisMonth=((NSString *)[byteslostDic objectForKey:[self currentMonth]]).intValue;
            if(bytesLostOfThisMonth==0){
                byteslostLabel.text=@"无";
            }else{
                byteslostLabel.text=[self bytesFormater:bytesLostOfThisMonth];
            }
            byteslostLabel.textColor = [UIColor blackColor];
            byteslostLabel.font = [UIFont fontWithName:@"System" size:17];
            byteslostLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:byteslostLabel];
            cell.textLabel.text =  @"本月2G/3G流量";
        }
    }else if(indexPath.section==3){
        if(indexPath.row==0){
            cell.textLabel.text=@"意见反馈";
        }
    }

   return cell;
}
-(NSString *)currentMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%d",components.month];
}
-(NSString *)bytesFormater:(int)bytes{
    NSString * str=@"";
    NSLog(@"bytesFormater %d",bytes);
    if(bytes>1024*1024){
        str=[NSString stringWithFormat:@"%.2f M",bytes/(1024.0*1024.0)];
    }else if(bytes>1024){
        str=[NSString stringWithFormat:@"%.2f K",bytes/1024.0];   
    }else{
        str=[NSString stringWithFormat:@"%d B",bytes];   
    }
    return str;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if (indexPath.row == 0){
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"保存资讯条数"
//                                                                     delegate:self
//                                                            cancelButtonTitle:@"取消"
//                                                       destructiveButtonTitle:nil
//                                                            otherButtonTitles:@"10条", @"20条", @"50条",nil];
//            [actionSheet showInView:self.view];
            NewsBufferSettingViewController *controller=[[NewsBufferSettingViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(indexPath.row == 1){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"清除缓存提醒！" message:@"您确定清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            NewsFontSettingViewController* nsv = [[NewsFontSettingViewController alloc] init];
            [self.navigationController pushViewController:nsv animated:YES];
        }else if(indexPath.row==1){
            
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
             NewsStatistsViewController*statists=[[NewsStatistsViewController alloc]init];
            [self.navigationController pushViewController:statists animated:YES];
        }
    }else if(indexPath.section==3){
        if(indexPath.row==1){
            AboutViewController *about=[[AboutViewController alloc]init];
            about.mode=1;
            [self.navigationController pushViewController:about animated:YES];
        }
        if(indexPath.row==0){
            ContactUsViewController *contact=[[ContactUsViewController alloc]init];
            contact.mode=1;
            [self.navigationController pushViewController:contact animated:YES];
        }
    }
}
- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if(switchControl.on){
        [[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(turnToNightMode:) userInfo:nil repeats:YES] fire];
    }else{
        [[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(turnToDayMode:) userInfo:nil repeats:YES] fire];
    }
    [self.timer fire];
    AppDelegate.user_defaults.is_night_mode_on=switchControl.on;
}
-(void)turnToNightMode:(id)sender{
    NSTimer *timer=sender;
    if([UIScreen mainScreen].brightness>0.1){
        [UIScreen mainScreen].brightness-=0.1;
    }else{
        [UIScreen mainScreen].brightness=0.1;
        [timer invalidate];
        timer=nil;
    }
}
-(void)turnToDayMode:(id)sender{
    NSTimer *timer=sender;
    if([UIScreen mainScreen].brightness<AppDelegate.user_defaults.outside_brightness_value){
        [UIScreen mainScreen].brightness+=0.1;
    }else{
        [UIScreen mainScreen].brightness=AppDelegate.user_defaults.outside_brightness_value;
        [timer invalidate];
        timer=nil;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self showWaitingAlert];
        [self performSelectorInBackground:@selector(delAllNews) withObject:nil];
        [self hideWaitingAlert];      
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%i", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: {
            AppDelegate.user_defaults.cache_article_number=@"10条";
            
            break;
        }
        case 1: {
            AppDelegate.user_defaults.cache_article_number=@"20条";
            break;
        }
        case 2: {
            AppDelegate.user_defaults.cache_article_number=@"50条";
            break;
        }
            
    }
    NSLog(@"%@",AppDelegate.user_defaults.cache_article_number);
    [self.table_view reloadData];
    
}

-(void)clearfilesWithXdailys:(NSMutableArray *)array{

}
-(void)delNewsWithSettingLimit{

}
-(void)delAllNews{

}
-(void)update{
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    if (setdate == NULL || [setdate intValue] == 30) {
        labBuff.text = @"30条";        
    }else if([setdate  intValue] ==  20){
        labBuff.text =  @"20条";        
    }else if([setdate intValue] == 10){
        labBuff.text = @"10条";
    }
    [self performSelectorInBackground:@selector(delNewsWithSettingLimit) withObject:nil];
    NSString* strFontSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
    labFont.text = strFontSize;
    NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    int bytesLostOfThisMonth=((NSString *)[byteslostDic objectForKey:[self currentMonth]]).intValue;
    if(bytesLostOfThisMonth==0){
        byteslostLabel.text=@"无";
    }else{
        byteslostLabel.text=[self bytesFormater:bytesLostOfThisMonth];
    }
    [table_view reloadData];
}
-(void)returnclick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
UIActivityIndicatorView*activeView;
-(void)makeWaitingAlert{
    self.waitingAlert = [[UIAlertView alloc]initWithTitle:@"请等待"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
    activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];    
    [waitingAlert addSubview:activeView];
    
}
-(void)showWaitingAlert{
    [self.waitingAlert show];    
    

}
-(void)hideWaitingAlert{
    [activeView stopAnimating];
    [self.waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    if([alertView isEqual:self.waitingAlert]){
        [activeView startAnimating];
    }
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"AlertView %f %f",self.waitingAlert.bounds.size.width/2.0f,self.waitingAlert.bounds.size.height-40.0f);
    if([alertView isEqual:self.waitingAlert]){
        activeView.center = CGPointMake(self.waitingAlert.bounds.size.width/2.0f, self.waitingAlert.bounds.size.height-40.0f);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
