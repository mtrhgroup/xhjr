//
//  SettingViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "SettingViewController.h"
#import "NavigationController.h"
#import "NewsFontSettingViewController.h"


@interface SettingViewController ()
@property(nonatomic,strong)UITableView *table_view;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation SettingViewController
@synthesize table_view=_table_view;
@synthesize timer=_timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _table_view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _table_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_waterwave.png"]];
    _table_view.delegate = self;
    _table_view.dataSource = self;
    [self.view addSubview:_table_view];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.table_view reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* str = @"cellid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            UILabel *font_lbl=(UILabel *)[[cell contentView] viewWithTag:1];
            if(font_lbl==nil)font_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.table_view.bounds.size.width-95,0,  60, 44)];
            font_lbl.text=AppDelegate.user_defaults.font_size;
            font_lbl.textColor=[UIColor grayColor];
            font_lbl.backgroundColor=[UIColor clearColor];
            font_lbl.textAlignment=NSTextAlignmentRight;
            font_lbl.tag=1;
            [[cell contentView] addSubview:font_lbl];
            cell.textLabel.text = @"字号";
        }else if(indexPath.row == 1){
            UILabel *font_lbl=(UILabel *)[[cell contentView] viewWithTag:1];
            if(font_lbl==nil)font_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.table_view.bounds.size.width-95,0,  60, 44)];
            font_lbl.text=[AppDelegate.service.fs_manager sizeOfArticleCache];
            font_lbl.textColor=[UIColor grayColor];
            font_lbl.backgroundColor=[UIColor clearColor];
            font_lbl.textAlignment=NSTextAlignmentRight;
            font_lbl.tag=1;
            cell.textLabel.text = @"清理缓存";
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.accessoryView = font_lbl;
        }else if(indexPath.row==2){
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
        }else if(indexPath.row==3){
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            UILabel *font_lbl=(UILabel *)[[cell contentView] viewWithTag:1];
            if(font_lbl==nil)font_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.table_view.bounds.size.width-95,0,  60, 44)];
            font_lbl.text=app_Version;
            font_lbl.textColor=[UIColor grayColor];
            font_lbl.backgroundColor=[UIColor clearColor];
            font_lbl.textAlignment=NSTextAlignmentRight;
            font_lbl.tag=1;
            [[cell contentView] addSubview:font_lbl];
            cell.textLabel.text = @"检查新版本";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if (indexPath.row == 0){
            NewsFontSettingViewController* nsv = [[NewsFontSettingViewController alloc] init];
            [self.navigationController pushViewController:nsv animated:YES];
        }else if(indexPath.row == 1){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"清除缓存提醒！" message:@"您确定清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else if(indexPath.row ==3){
            [AppDelegate.service checkVersion:^(BOOL isOK) {
                if(!isOK){
                    [self.view.window showHUDWithText:@"已是最新版本" Type:ShowPhotoYes Enabled:YES];
                }else{
                    [self.view.window goTimeInit];
                }
            } errorHandler:^(NSError *error) {
                [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
            }];
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

-(void)delAllNews{
    [AppDelegate.service.fs_manager clearArticleCache];
    [self.table_view reloadData];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
