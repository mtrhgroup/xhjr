//
//  SettingViewController.m
//  XinHuaDailyXib
//
//  Created by 耀龙 马 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "XDAboutViewController.h"
#import "XinHuaAppDelegate.h"
#import "XDailyItem.h"
#import "NewsBufferSettingViewController.h"
#import "NewsFontSettingViewController.h"
#import "NewsStatistsViewController.h"
#import "NewsDbOperator.h"
#import "ContactUsViewController.h"
#import "Toast+UIView.h"
#import "NewsDbOperatorForChildThread.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize table;
@synthesize labBuff;
@synthesize labFont;
@synthesize byteslostLabel;
@synthesize waitingAlert;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:KSettingChange object:nil];        
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [table release];
    [labBuff release];
    [labFont release];
    [byteslostLabel release];
    // Release any retained subviews of the main view.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"系统设置";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    [self.view addSubview:bimgv];
    [bimgv release];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0)) style:UITableViewStyleGrouped];
    
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self makeWaitingAlert];
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
        return 1;
    }else if(section==2){
        return 1;
    }else if(section==3){
        return 2;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* str = @"cellid";
    UITableViewCell* cell = [table dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
       
    }
    
      cell.textLabel.textColor = [UIColor blackColor];
      cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            
            labBuff = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
            NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
            if (setdate == NULL || [setdate intValue] == 30) {
                labBuff.text = @"30条";        
            }else if([setdate  intValue] ==  20){
                labBuff.text =  @"20条";        
            }else if([setdate intValue] == 10){
                labBuff.text = @"10条";
            }
            labBuff.textColor = [UIColor blackColor];
            labBuff.font = [UIFont fontWithName:@"System" size:17];
            labBuff.backgroundColor = [UIColor clearColor];
            [cell addSubview:labBuff];
            cell.textLabel.text = @"保留数据条数";
            
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"清理缓存";    
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            labFont = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
            NSString* strFontSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
            if(strFontSize==nil){
                labFont.text=@"中";
            }else{
                labFont.text=strFontSize;
            }
            labFont.textColor = [UIColor blackColor];
            labFont.font = [UIFont fontWithName:@"System" size:17];
            labFont.backgroundColor = [UIColor clearColor];
            [cell addSubview:labFont];
            cell.textLabel.text = @"字体大小"; 
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            byteslostLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
            NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
            NSLog(@"byteslostDic %@",byteslostDic);
            NSLog(@"当前月份是 %@",[self currentMonth]);
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
        if(indexPath.row==1){
            cell.textLabel.text =  @"关于";
        }
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
            NewsBufferSettingViewController* nsv = [[NewsBufferSettingViewController alloc] init];
            [self.navigationController pushViewController:nsv animated:YES];
            [nsv release];
        }else if(indexPath.row == 1){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"清除缓存提醒！" message:@"您确定清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            NewsFontSettingViewController* nsv = [[NewsFontSettingViewController alloc] init];
            [self.navigationController pushViewController:nsv animated:YES];
            [nsv release];
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
             NewsStatistsViewController*statists=[[NewsStatistsViewController alloc]init];
            [self.navigationController pushViewController:statists animated:YES];
            [statists release];
        }
    }else if(indexPath.section==3){
        if(indexPath.row==1){
            XDAboutViewController *about=[[XDAboutViewController alloc]init];
            about.mode=1;
            [self.navigationController pushViewController:about animated:YES];
            [about release];
        }
        if(indexPath.row==0){
            ContactUsViewController *contact=[[ContactUsViewController alloc]init];
            contact.mode=1;
            [self.navigationController pushViewController:contact animated:YES];
            [contact release];
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self showWaitingAlert];
        NSMutableArray * array = [AppDelegate.db  GetAllNewsExceptImgAndKuaiXun];
        [self performSelectorInBackground:@selector(clearfilesWithXdailys:) withObject:array];
        [AppDelegate.db DelAllNews];
        [AppDelegate.db SaveDb];
        [self hideWaitingAlert];
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                            object: self];
    }
    
}
-(void)clearfilesWithXdailys:(NSMutableArray *)array{
    for (XDailyItem *daily in array) {
        NSString* url = [daily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSString* fileName = [[url lastPathComponent] stringByDeletingPathExtension] ;
        NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
        NSLog(@"%@",filePath);
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:filePath error:nil];
        NSLog(@"filePath______==%@",filePath);
    }
}
-(void)autoClearBuffer{
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    NSMutableArray* item2Delete=   [AppDelegate.db DelNewsByRetainCount:[setdate intValue]];
    [self performSelectorInBackground:@selector(clearfilesWithXdailys:) withObject:item2Delete];
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                        object: self];
    
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
    [self autoClearBuffer];
    NSString* strFontSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
    labFont.text = strFontSize;        
}
-(void)returnclick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
UIActivityIndicatorView*activeView;
-(void)makeWaitingAlert{
    self.waitingAlert = [[[UIAlertView alloc]initWithTitle:@"请等待"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil] autorelease];
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
