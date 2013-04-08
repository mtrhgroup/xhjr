//
//  NewsLocateView.m
//  CampusNewsLetter
//
//  Created by apple on 12-10-23.
//
//

#import "NewsLocateView.h"
#define kDuration 0.3
@implementation NewsLocateView
@synthesize collageTitle=_collageTitle;
@synthesize collageCode=_collageCode;
-(id)initWithFrame:(CGRect)rect delegate:(id)delegate
{
	if ((self=[super initWithFrame:CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)]))
	{		
		[self awakeFromNib];
	}
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        collages = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Universities.plist" ofType:nil]];
        //初始化默认数据
        self.collageTitle = [[collages objectAtIndex:0] objectForKey:@"title"];
        self.collageCode=[[collages objectAtIndex:0] objectForKey:@"code"];
    }
	return self;
}
-(void)awakeFromNib{
  [super awakeFromNib];
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
   // bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    
    UIButton* btnCnl = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    btnCnl.showsTouchWhenHighlighted=YES;
    [btnCnl addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [btnCnl setBackgroundImage:[UIImage imageNamed:@"btn_021.png"] forState:UIControlStateNormal];
    [bimgv addSubview:btnCnl];
    [btnCnl release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    lab.text = @"选择学校";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    UIButton* btnOK = [[UIButton alloc] initWithFrame:CGRectMake(280, 5, 35, 35)];
    btnOK.showsTouchWhenHighlighted=YES;
    [btnOK addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    [btnOK setBackgroundImage:[UIImage imageNamed:@"btn_020.png"] forState:UIControlStateNormal];
    [bimgv addSubview:btnOK];
    [btnOK release];
    
    [self addSubview:bimgv];
    [bimgv release];
    
    UIPickerView *picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44)];
    picker.showsSelectionIndicator=YES; 
    picker.dataSource=self;
    picker.delegate=self;
    [self addSubview:picker];
    [picker release];

}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [collages count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[collages objectAtIndex:row] objectForKey:@"title"];
            break;
        default:
            return nil;
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.collageCode = [[collages objectAtIndex:row] objectForKey:@"code"];
            self.collageTitle=[[collages objectAtIndex:row] objectForKey:@"title"];
            break;
        default:
            break;
    }
}
#pragma mark - Button lifecycle
-(void)removeFromView{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
}
- (void)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (void)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}
@end
