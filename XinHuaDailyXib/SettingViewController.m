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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"管理设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self makeWaitingAlert];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
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
        return 1;//2:夜间模式
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
    UITableViewCell* cell = [table dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
       
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
        }else if(indexPath.row==1){
            NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
            if(displayMode==nil)
                cell.textLabel.text = @"日间模式";
            else
                cell.textLabel.text=displayMode;
            cell.accessoryType=UITableViewCellAccessoryNone;
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
            NewsBufferSettingViewController* nsv = [[NewsBufferSettingViewController alloc] init];
            [self.navigationController pushViewController:nsv animated:YES];
        }else if(indexPath.row == 1){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"清除缓存提醒！" message:@"您确定清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            NewsFontSettingViewController* nsv = [[NewsFontSettingViewController alloc] init];
            [self.navigationController pushViewController:nsv animated:YES];
        }else if(indexPath.row==1){
            NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
            if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"夜间模式" forKey:@"displayMode"];
                [[NSNotificationCenter defaultCenter] postNotificationName: KDisplayMode
                                                                    object: self];
                [[NSNotificationCenter defaultCenter] postNotificationName: KSettingChange
                                                                    object: self];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"日间模式" forKey:@"displayMode"];
                [[NSNotificationCenter defaultCenter] postNotificationName: KDisplayMode
                                                                    object: self];
                [[NSNotificationCenter defaultCenter] postNotificationName: KSettingChange
                                                                    object: self];
            }
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self showWaitingAlert];
        [self performSelectorInBackground:@selector(delAllNews) withObject:nil];
        [self hideWaitingAlert];      
    }
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
    [table reloadData];
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
