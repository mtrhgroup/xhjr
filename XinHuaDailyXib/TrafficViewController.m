//
//  KidsTrafficViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/25.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "TrafficViewController.h"
#import "NavigationController.h"

@interface TrafficViewController ()

@end

@implementation TrafficViewController
@synthesize tableView=_tableView;
@synthesize currentMonth3G=_currentMonth3G;
@synthesize currentMonthWifi=_currentMonthWifi;
@synthesize lastMonth3G=_lastMonth3G;
@synthesize lastMonthWifi=_lastMonthWifi;

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
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
	// Do any additional setup after loading the view.
    
    NSDictionary *cellbytesDict= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    NSDictionary *wifibytesDict= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];
    
    self.currentMonth3G = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int cellOfThisMonth=((NSString *)[cellbytesDict objectForKey:[self currentMonth]]).intValue;
    if(cellOfThisMonth==0){
        _currentMonth3G.text=@"无";
    }else{
        _currentMonth3G.text=[self bytesFormater:cellOfThisMonth];
    }
    _currentMonth3G.textColor = [UIColor blackColor];
    _currentMonth3G.font = [UIFont fontWithName:@"System" size:17];
    _currentMonth3G.backgroundColor = [UIColor clearColor];
    
    self.currentMonthWifi = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int wifiOfThisMonth=((NSString *)[wifibytesDict objectForKey:[self currentMonth]]).intValue;
    if(wifiOfThisMonth==0){
        _currentMonthWifi.text=@"无";
    }else{
        _currentMonthWifi.text=[self bytesFormater:wifiOfThisMonth];
    }
    _currentMonthWifi.textColor = [UIColor blackColor];
    _currentMonthWifi.font = [UIFont fontWithName:@"System" size:17];
    _currentMonthWifi.backgroundColor = [UIColor clearColor];
    
    self.lastMonth3G = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int cellOflastMonth=((NSString *)[cellbytesDict objectForKey:[self lastMonth]]).intValue;
    if(cellOflastMonth==0){
        _lastMonth3G.text=@"无";
    }else{
        _lastMonth3G.text=[self bytesFormater:cellOflastMonth];
    }
    _lastMonth3G.textColor = [UIColor blackColor];
    _lastMonth3G.font = [UIFont fontWithName:@"System" size:17];
    _lastMonth3G.backgroundColor = [UIColor clearColor];
    
    self.lastMonthWifi= [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
    int wifiOflastMonth=((NSString *)[wifibytesDict objectForKey:[self lastMonth]]).intValue;
    if(wifiOflastMonth==0){
        _lastMonthWifi.text=@"无";
    }else{
        _lastMonthWifi.text=[self bytesFormater:wifiOflastMonth];
    }
    _lastMonthWifi.textColor = [UIColor blackColor];
    _lastMonthWifi.font = [UIFont fontWithName:@"System" size:17];
    _lastMonthWifi.backgroundColor = [UIColor clearColor];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
   [self dismissViewControllerAnimated:YES completion:nil];
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            [cell addSubview:_currentMonth3G];
            cell.textLabel.text = @"本月2G/3G流量";
        }else if(indexPath.row == 1){
            [cell addSubview:_currentMonthWifi];
            cell.textLabel.text = @"本月Wifi流量";
        }
    }else if(indexPath.section==1){
        if (indexPath.row == 0){
            [cell addSubview:_lastMonth3G];
            cell.textLabel.text = @"上月2G/3G流量";
            
        }else if(indexPath.row == 1){
            [cell addSubview:_lastMonthWifi];
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
        _currentMonth3G.text=@"无";
    }else{
        _currentMonth3G.text=[self bytesFormater:bytesLostOfThisMonthBy3G];
    }
    int bytesLostOflastMonthBy3G=((NSString *)[byteslostDicby3G objectForKey:[self lastMonth]]).intValue;
    if(bytesLostOflastMonthBy3G==0){
        _lastMonth3G.text=@"无";
    }else{
        _lastMonth3G.text=[self bytesFormater:bytesLostOflastMonthBy3G];
    }
    
    
    int bytesLostOfThisMonthByWifi=((NSString *)[byteslostDicbyWifi objectForKey:[self currentMonth]]).intValue;
    if(bytesLostOfThisMonthByWifi==0){
        _currentMonthWifi.text=@"无";
    }else{
        _currentMonthWifi.text=[self bytesFormater:bytesLostOfThisMonthByWifi];
    }
    
    int bytesLostOflastMonthByWifi=((NSString *)[byteslostDicbyWifi objectForKey:[self lastMonth]]).intValue;
    if(bytesLostOflastMonthByWifi==0){
        _lastMonthWifi.text=@"无";
    }else{
        _lastMonthWifi.text=[self bytesFormater:bytesLostOflastMonthByWifi];
    }
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


@end
