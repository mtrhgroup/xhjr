//
//  XDAboutViewController.m
//  XDailyNews
//
//  Created by peiqiang li on 11-12-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "DeviceInfo.h"
#import "NavigationController.h"

@implementation AboutViewController
@synthesize table;
@synthesize mode;

- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"客服电话";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    UIView* uiv = [[UIView alloc] initWithFrame:CGRectMake(5, 88, 310, 230)];
    uiv.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"about_gray.png"]];
    UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 64, 64)];
    logo.image=[UIImage imageNamed:@"Icon@2x.png"];
    [uiv addSubview:logo];
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    NSString* appversion =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    UILabel* lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 90, 20)];
    lab1.backgroundColor = [UIColor clearColor];
    lab1.font = [UIFont fontWithName:@"Arial" size:16];
    lab1.textColor = [UIColor whiteColor];
    lab1.text =  @"序列号:";
    [uiv addSubview:lab1];
    
    
    UILabel* lab2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 220, 20)];
    lab2.backgroundColor = [UIColor clearColor];
    lab2.font = [UIFont fontWithName:@"Arial" size:16];
    lab2.textColor = [UIColor whiteColor];
//    lab2.text=[UIDevice customUdid];
    if (authcode == nil) {
        lab2.text = @"";
    }else {
        lab2.text = authcode;
    }
    
    [uiv addSubview:lab2];
    
    
    UILabel* lab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 90, 20)];
    lab3.backgroundColor = [UIColor clearColor];
    lab3.font = [UIFont fontWithName:@"Arial" size:16];
    lab3.textColor = [UIColor whiteColor];
    lab3.text =  @"版本信息:";
    [uiv addSubview:lab3];
    
    
    UILabel* lab4 = [[UILabel alloc] initWithFrame:CGRectMake(90, 120, 220, 20)];
    lab4.backgroundColor = [UIColor clearColor];
    lab4.font = [UIFont fontWithName:@"Arial" size:16];
    lab4.textColor = [UIColor whiteColor];
    lab4.text =  appversion;
    [uiv addSubview:lab4];
    UILabel* lab7 = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 90, 20)];
    lab7.backgroundColor = [UIColor clearColor];
    lab7.font = [UIFont fontWithName:@"Arial" size:16];
    lab7.textColor = [UIColor whiteColor];
    lab7.text =  @"客服电话:";
    [uiv addSubview:lab7];
    UILabel* lab8 = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 220, 20)];
    lab8.backgroundColor = [UIColor clearColor];
    lab8.font = [UIFont fontWithName:@"Arial" size:16];
    lab8.textColor = [UIColor blueColor];
    lab8.text =  @"024-23822598";
    [uiv addSubview:lab8];
    lab8.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telToMe:)];
    [lab8 addGestureRecognizer:singleTap];

    UILabel* labRight = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 250, 20)];
    labRight.backgroundColor = [UIColor clearColor];
    labRight.font = [UIFont fontWithName:@"Arial" size:16];
    labRight.textColor = [UIColor whiteColor];
    labRight.text =  @"©新华时讯通移动信息服务平台";
    [uiv addSubview:labRight];
    [self.view addSubview:uiv];
    
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)returnclick:(id)sender{
    if(mode==1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"设备标识";
            cell.detailTextLabel.text = [DeviceInfo udid];
            //cell.textLabel.text =  [NSString stringWithFormat:NSLocalizedString(@"device_identify", nil),[UIDevice customUdid]];
        }
            break;
          case 1:
        {
            NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
            cell.textLabel.text = @"授权码";
            cell.detailTextLabel.text =  authcode;
        }
            break;
        case 2:
        {
            NSString* appversion =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
            cell.textLabel.text = @"版本";
            cell.detailTextLabel.text =  appversion;
        }
            break;
        case 3:
        {
            //:010-63076092
            cell.textLabel.text =  @"联系电话";
            cell.detailTextLabel.text =  @"024-23828522";
        }
            break;
        default:
            break;

    }
    // Configure the cell...
    
    return cell;
}
-(void)telToMe2:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://089868527552"]];
}
-(void)telToMe:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://02423828522"]];
}
- (void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
