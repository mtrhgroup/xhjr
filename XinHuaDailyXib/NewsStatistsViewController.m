//
//  NewsStatistsViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsStatistsViewController.h"

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
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"系统设置";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [self.view addSubview:bimgv];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0)) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
	// Do any additional setup after loading the view.
    
    NSDictionary *cellbytesDict= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    NSDictionary *wifibytesDict= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];
    
    self.currentMonth3G = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int cellOfThisMonth=((NSString *)[cellbytesDict objectForKey:[self currentMonth]]).intValue;
    if(cellOfThisMonth==0){
        currentMonth3G.text=@"无";
    }else{
        currentMonth3G.text=[self bytesFormater:cellOfThisMonth];
    }
    currentMonth3G.textColor = [UIColor blackColor];
    currentMonth3G.font = [UIFont fontWithName:@"System" size:17];
    currentMonth3G.backgroundColor = [UIColor clearColor];
    
    self.currentMonthWifi = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int wifiOfThisMonth=((NSString *)[wifibytesDict objectForKey:[self currentMonth]]).intValue;
    if(wifiOfThisMonth==0){
        currentMonthWifi.text=@"无";
    }else{
        currentMonthWifi.text=[self bytesFormater:wifiOfThisMonth];
    }  
    currentMonthWifi.textColor = [UIColor blackColor];
    currentMonthWifi.font = [UIFont fontWithName:@"System" size:17];
    currentMonthWifi.backgroundColor = [UIColor clearColor];
    
    self.lastMonth3G = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int cellOflastMonth=((NSString *)[cellbytesDict objectForKey:[self lastMonth]]).intValue;
    if(cellOflastMonth==0){
        lastMonth3G.text=@"无";
    }else{
        lastMonth3G.text=[self bytesFormater:cellOflastMonth];
    }      
    lastMonth3G.textColor = [UIColor blackColor];
    lastMonth3G.font = [UIFont fontWithName:@"System" size:17];
    lastMonth3G.backgroundColor = [UIColor clearColor];
    
    self.lastMonthWifi= [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int wifiOflastMonth=((NSString *)[wifibytesDict objectForKey:[self lastMonth]]).intValue;
    if(wifiOflastMonth==0){
        lastMonthWifi.text=@"无";
    }else{
        lastMonthWifi.text=[self bytesFormater:wifiOflastMonth];
    }
    lastMonthWifi.textColor = [UIColor blackColor];
    lastMonthWifi.font = [UIFont fontWithName:@"System" size:17];
    lastMonthWifi.backgroundColor = [UIColor clearColor];
    
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
            [cell addSubview:currentMonth3G];
            cell.textLabel.text = @"本月2G/3G流量";            
        }else if(indexPath.row == 1){
            [cell addSubview:currentMonthWifi];
            cell.textLabel.text = @"本月Wifi流量";  
        }
    }else if(indexPath.section==1){
        if (indexPath.row == 0){
            [cell addSubview:lastMonth3G];
            cell.textLabel.text = @"上月2G/3G流量";
            
        }else if(indexPath.row == 1){
            [cell addSubview:lastMonthWifi];
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
    NSDictionary *byteslostDicby3G= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    NSDictionary *byteslostDicbyWifi= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];

    int bytesLostOfThisMonthBy3G=((NSString *)[byteslostDicby3G objectForKey:[self currentMonth]]).intValue;
    if(bytesLostOfThisMonthBy3G==0){
        currentMonth3G.text=@"无";
    }else{
        currentMonth3G.text=[self bytesFormater:bytesLostOfThisMonthBy3G];
    }
    int bytesLostOflastMonthBy3G=((NSString *)[byteslostDicby3G objectForKey:[self lastMonth]]).intValue;
    if(bytesLostOflastMonthBy3G==0){
        lastMonth3G.text=@"无";
    }else{
        lastMonth3G.text=[self bytesFormater:bytesLostOflastMonthBy3G];
    }  
    

    int bytesLostOfThisMonthByWifi=((NSString *)[byteslostDicbyWifi objectForKey:[self currentMonth]]).intValue;
    if(bytesLostOfThisMonthByWifi==0){
        currentMonthWifi.text=@"无";
    }else{
        currentMonthWifi.text=[self bytesFormater:bytesLostOfThisMonthByWifi];
    }
    
    int bytesLostOflastMonthByWifi=((NSString *)[byteslostDicbyWifi objectForKey:[self lastMonth]]).intValue;
    if(bytesLostOflastMonthByWifi==0){
        lastMonthWifi.text=@"无";
    }else{
        lastMonthWifi.text=[self bytesFormater:bytesLostOflastMonthByWifi];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: KSettingChange
                                                        object: self];
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
