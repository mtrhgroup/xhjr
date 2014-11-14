#import "DatePickerViewController.h"
#import "NavigationController.h"
#import "Color.h"

@interface DatePickerViewController ()
{
    
    
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
    //    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}

@end

@implementation DatePickerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"往期刊物";
    [self setAirPlaneToDay:-365 ToDateforString:nil];
    self.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);

    };
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}





#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}



#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{
    
    [self.navigationItem setTitle:calendartitle];
    
}


@end
