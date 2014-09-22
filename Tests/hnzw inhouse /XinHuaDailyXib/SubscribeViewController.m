//
//  SubscribeViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubscribeViewController.h"
#import "NewsChannel.h"
#import "XinHuaAppDelegate.h"
#import "NewsDbOperator.h"
#import "ASIHTTPRequest.h"
#import "NSIks.h"
#import "UICustomSwitch.h"
@interface SubscribeViewController ()

@end

@implementation SubscribeViewController
@synthesize channel_list=_channel_list;
@synthesize table;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"订阅管理";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    [self.view addSubview:bimgv];
    [bimgv release];
    
    [self getListFromDB];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,44,320,416+(iPhone5?88:0))];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self setExtraCellHidden:self.table];
}
-(void)backAction:(id)sender{
    [self commitToServer];
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                        object: self];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [_channel_list release];
    [table release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    return [_channel_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"channelSubscribeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

        if ( cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
    
    NewsChannel *channelAtIndex = [self.channel_list objectAtIndex:indexPath.row];

    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 120, 30)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = channelAtIndex.title;
    labtext.font = [UIFont fontWithName:@"system" size:15];
    [cell addSubview:labtext];
    [labtext release];
    
    UICustomSwitch* sw = [[UICustomSwitch alloc] initWithFrame:CGRectMake(226,5,60,27)];
    [cell addSubview:sw];
    
    UICustomSwitch *switcher = sw;
    [switcher addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"%@",channelAtIndex.subscribe);
    if(channelAtIndex.subscribe.intValue==0){
        [switcher setOn:false];
    }else if(channelAtIndex.subscribe.intValue==1){
        [switcher setOn:true];
    }else if(channelAtIndex.subscribe.intValue==2){
//        [switcher setOn:true];
//        
//        [switcher setOnTintColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
//        [switcher setEnabled:false];
    }
    
    if(channelAtIndex.imgPath != nil){
        NSString* pathImg = [CommonMethod fileWithDocumentsPath:[[channelAtIndex.imgPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
        NSFileManager* fm = [[NSFileManager alloc] init];
        if ([fm fileExistsAtPath:pathImg]) {
            UIImageView* uiv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
            uiv.image = [[[UIImage alloc] initWithContentsOfFile:pathImg] autorelease];
            [cell addSubview:uiv];
            [uiv release];
        }else{
            UIImageView* uiv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
            uiv.image = [UIImage imageNamed:@"Icon.png"];
            [cell addSubview:uiv];
            [uiv release];
        }
        [fm release];

    }
    [sw release];
    return cell;
}
-(void)getListFromDB{
    self.channel_list=nil;
    self.channel_list=[[[NSMutableArray alloc]init] autorelease];
    NSMutableArray *tempArray=[AppDelegate.db allChannels];
    for(NewsChannel * channel in tempArray){
        if(channel.subscribe.intValue<2){
            [self.channel_list addObject:channel];
        }
    }
    [self.table reloadData]; 
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)changeStatus:(id)sender {
    UISwitch * whichSwitch = (UISwitch *)sender;
    NSNumber* setting;
    if(whichSwitch.isOn){
        setting=[NSNumber numberWithInt:1]  ;
    }else{
        setting=0;
    }
    UITableViewCell *cell=(UITableViewCell *)whichSwitch.superview;
    NewsChannel * channel=(NewsChannel *)[self.channel_list objectAtIndex:[[self.table visibleCells] indexOfObject:cell]];
    NSLog(@" channel_id %@",channel.channel_id);
    [AppDelegate.db ModifyChannelSubscribe:channel.channel_id sub:setting];
}

- (void)returnBtn:(id)sender {

}
-(void)commitToServer{
    NSMutableArray * channel_subscribe_list=[AppDelegate.db ChannelsSubscrib];
    if([channel_subscribe_list count]>0){
    NSMutableString * result = [[NSMutableString alloc] init];
    for (NewsChannel * channel_subscribe in channel_subscribe_list)
    {        
        [result appendString:channel_subscribe.channel_id];
        [result appendString:@","];
    }
    NSString * sub_list_str=[result substringToIndex:result.length-1];  
    [result release];
    NSString *sub_commit_url=[NSString stringWithFormat:KSubscribeCommitURL,[UIDevice customUdid],sub_list_str,[[UIDevice currentDevice] systemVersion]];
    NSLog(@"sub_commit_url = %@",sub_commit_url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:sub_commit_url]];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"sub_commit_url = %@",responseString);
        NSRange range=[responseString rangeOfString:@"OLD"];
        if(range.location!=NSNotFound){
            //　　
        }else{
            //
        }
        [request release];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error = %@",[error localizedDescription]);
        [request release];
    }];
    [request startAsynchronous];
    }
}

-(void)setExtraCellHidden:(UITableView *)tableview{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableview setTableFooterView:view];
    [view release];       
}
@end
