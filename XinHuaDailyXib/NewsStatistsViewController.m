//
//  NewsStatistsViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsStatistsViewController.h"
#import "NavigationController.h"

@interface NewsStatistsViewController ()

@end

@implementation NewsStatistsViewController
@synthesize table;
@synthesize currentMonth3G;
@synthesize currentMonthWifi;
@synthesize lastMonth3G;
@synthesize lastMonthWifi;


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"流量统计";
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0){
        return 2;
    }else if(section==1){
        return 2;
    }else if(section==2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* str = @"cellid";
    UITableViewCell* cell = [table dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            UILabel *bytes_lost_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
            bytes_lost_lbl.text=AppDelegate.user_defaults.bytes_lost_of_cell_this_month;
            bytes_lost_lbl.textColor=[UIColor grayColor];
            bytes_lost_lbl.textAlignment=NSTextAlignmentRight;
            cell.accessoryView=bytes_lost_lbl;
            cell.textLabel.text = @"本月蜂窝数据流量";
        }else if(indexPath.row == 1){
            UILabel *bytes_lost_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
            bytes_lost_lbl.text=AppDelegate.user_defaults.bytes_lost_of_wifi_this_month;
            bytes_lost_lbl.textColor=[UIColor grayColor];
            bytes_lost_lbl.textAlignment=NSTextAlignmentRight;
            cell.accessoryView=bytes_lost_lbl;
            cell.textLabel.text = @"本月Wifi流量";  
        }
    }else if(indexPath.section==1){
        if (indexPath.row == 0){
            UILabel *bytes_lost_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
            bytes_lost_lbl.text=AppDelegate.user_defaults.bytes_lost_of_cell_last_month;
            bytes_lost_lbl.textColor=[UIColor grayColor];
            bytes_lost_lbl.textAlignment=NSTextAlignmentRight;
            cell.accessoryView=bytes_lost_lbl;
            cell.textLabel.text = @"上月蜂窝数据流量";
            
        }else if(indexPath.row == 1){
            UILabel *bytes_lost_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
            bytes_lost_lbl.text=AppDelegate.user_defaults.bytes_lost_of_wifi_lost_month;
            bytes_lost_lbl.textColor=[UIColor grayColor];
            bytes_lost_lbl.textAlignment=NSTextAlignmentRight;
            cell.accessoryView=bytes_lost_lbl;
            cell.textLabel.text = @"上月Wifi流量";  
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            cell.textLabel.text = @"清空本月统计";  
        }
    }   
    return cell;
}
-(NSString *)currentMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%d",components.month];
}
-(NSString *)lastMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    int last=0;
    if(components.month>1)last=components.month-1;
    else
        last=12;
    return [NSString stringWithFormat:@"%d",last];
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
-(void)update{
    [self.table reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2){
        if (indexPath.row == 0){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"清空统计提醒！" message:@"您确定清空统计数据吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSMutableDictionary *byteslostDicby3G= [[[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"] mutableCopy];
        NSMutableDictionary *byteslostDicbyWifi= [[[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"] mutableCopy];
        NSString *monthStr= [[NSUserDefaults standardUserDefaults] objectForKey:@"THISMONTH"];
        NSLog(@"monthStr %@",monthStr);
        NSString *thisMonthStr=[self currentMonth];
        [byteslostDicby3G  setValue:[NSString stringWithFormat:@"%d",0] forKey:thisMonthStr];
        [byteslostDicbyWifi  setValue:[NSString stringWithFormat:@"%d",0] forKey:thisMonthStr];
        [[NSUserDefaults  standardUserDefaults] setObject:byteslostDicby3G forKey:@"CELLBYTES"];
        [[NSUserDefaults  standardUserDefaults] setObject:byteslostDicbyWifi forKey:@"WIFIBYTES"];
        [self update];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=@"";
    if(section==0){
        temp=[NSString stringWithFormat:@"本月流量统计(%@月)",[self currentMonth]] ;
    }else if(section==1){
        temp=[NSString stringWithFormat:@"上月流量统计(%@月)",[self lastMonth]];
    }else if(section==2){
        temp=@"清空本月统计";
    }
    return temp;
}
#pragma mark - Table view delegate
-(void)returnclick:(id)sender{    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
