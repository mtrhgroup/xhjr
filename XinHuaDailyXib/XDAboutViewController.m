//
//  XDAboutViewController.m
//  XDailyNews
//
//  Created by peiqiang li on 11-12-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XDAboutViewController.h"


@implementation XDAboutViewController
@synthesize table;
@synthesize mode;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [table release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    butb.showsTouchWhenHighlighted=YES;
    [bimgv addSubview:butb];
    [butb release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"关于";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    [self.view addSubview:bimgv];
    [bimgv release];
         
    
    
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    NSString* appversion =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
//    
//    self.deviceid.text=[UIDevice customUdid];
//    self.version.text=appversion;
//    self.telephonenumber.text=@"010-63076092";
//    self.serialnumber.text=authcode;
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_bac.png"]];
    UIView* uiv = [[UIView alloc] initWithFrame:CGRectMake(5, 88, 310, 230)];
    uiv.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"about_gray.png"]];
    
    UILabel* lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 90, 20)];
    lab1.backgroundColor = [UIColor clearColor];
    lab1.font = [UIFont fontWithName:@"Arial" size:16];
    lab1.textColor = [UIColor whiteColor];
    lab1.text =  @"手机号:";
    [uiv addSubview:lab1];
    [lab1 release];
    
    
    UILabel* lab2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 220, 20)];
    lab2.backgroundColor = [UIColor clearColor];
    lab2.font = [UIFont fontWithName:@"Arial" size:16];
    lab2.textColor = [UIColor whiteColor];
    if (authcode == nil) {
        lab2.text = @"";
    }else {
        lab2.text = authcode;
    }
    
    [uiv addSubview:lab2];
    [lab2 release];
    
    
    UILabel* lab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 90, 20)];
    lab3.backgroundColor = [UIColor clearColor];
    lab3.font = [UIFont fontWithName:@"Arial" size:16];
    lab3.textColor = [UIColor whiteColor];
    lab3.text =  @"版本信息:";
    [uiv addSubview:lab3];
    [lab3 release];
    
    
    UILabel* lab4 = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 220, 20)];
    lab4.backgroundColor = [UIColor clearColor];
    lab4.font = [UIFont fontWithName:@"Arial" size:16];
    lab4.textColor = [UIColor whiteColor];
    lab4.text =  appversion;
    [uiv addSubview:lab4];
    [lab4 release];
    
    
    UILabel* lab5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 90, 20)];
    lab5.backgroundColor = [UIColor clearColor];
    lab5.font = [UIFont fontWithName:@"Arial" size:16];
    lab5.textColor = [UIColor whiteColor];
    lab5.text =  @"版权所有:";
    [uiv addSubview:lab5];
    [lab5 release];
    
    
    UILabel* lab6 = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 220, 20)];
    lab6.backgroundColor = [UIColor clearColor];
    lab6.font = [UIFont fontWithName:@"Arial" size:16];
    lab6.textColor = [UIColor whiteColor];
    lab6.text =  @"新华社经济信息编辑部";
    [uiv addSubview:lab6];
    [lab6 release];
    
//    UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectMake(254, 100, 32, 32)];
//    imgv.image = [UIImage imageNamed:@"icon.png"];
//    [uiv addSubview:imgv];
//    [imgv release];
    
    
    UILabel* lab7 = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 90, 20)];
    lab7.backgroundColor = [UIColor clearColor];
    lab7.font = [UIFont fontWithName:@"Arial" size:16];
    lab7.textColor = [UIColor whiteColor];
    lab7.text =  @"联系电话:";
    [uiv addSubview:lab7];
    [lab7 release];
    
    
    UILabel* lab8 = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 220, 20)];
    lab8.backgroundColor = [UIColor clearColor];
    lab8.font = [UIFont fontWithName:@"Arial" size:16];
    lab8.textColor = [UIColor whiteColor];
    lab8.text =  @"+86-010-63077787";
    [uiv addSubview:lab8];
    [lab8 release];
    
    UIButton* telBtn=[[UIButton alloc]initWithFrame:CGRectMake(254, 140, 32, 32)];
    [telBtn setBackgroundImage:[UIImage imageNamed:@"about_tel_pic.png"] forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(telToMe:) forControlEvents:UIControlEventTouchUpInside];
    [uiv addSubview:telBtn];
    [telBtn release];
    
    
    UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(125, 180, 175, 36);
    [but setBackgroundImage:[UIImage imageNamed:@"about_tel.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(telToMe:) forControlEvents:UIControlEventTouchUpInside];
    [uiv addSubview:but];
    
    [self.view addSubview:uiv];
    [uiv release];


}


-(void)returnclick:(id)sender{
    if(mode==1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"设备标识";
            cell.detailTextLabel.text = [UIDevice customUdid];
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
            cell.detailTextLabel.text =  @"010-63077787";

        }
            break;
        default:
            break;

    }
    // Configure the cell...
    
    return cell;
}

-(void)telToMe:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://01063077787"]];
}
- (void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
