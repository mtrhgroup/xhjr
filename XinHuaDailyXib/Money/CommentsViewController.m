//
//  CommentsViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import "CommentsViewController.h"
#import "NavigationController.h"
#import "CommentCell.h"
#import "Comment.h"
#import "AMBlurView.h"
#import "UIPlaceHolderTextView.h"
#import "UIButton+Bootstrap.h"
@interface CommentsViewController ()
@property(nonatomic,strong)NSArray *comments;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)AMBlurView *blurView;
@property(nonatomic,strong)UITextView *contentTV;
@property(nonatomic,strong)UIButton *send_btn;
@property(nonatomic,strong)UIButton *cancel_btn;
@property (nonatomic,strong)AMBlurView *bottom_view;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评论";
    self.view.backgroundColor=[UIColor whiteColor];
    if(lessiOS7){
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    }else{
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self reloadCommentsFromNET];
    
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(0, self.view.frame.size.height-180-20, self.view.bounds.size.width, 180)];
    self.blurView.hidden=YES;
    [self.view addSubview:[self blurView]];
    self.bottom_view=[AMBlurView new];
    NSLog(@"view bounds height:%f   frame height:%f",self.view.bounds.size.height,self.view.frame.size.height);
    self.bottom_view.frame=CGRectMake(0, self.view.bounds.size.height-88-20, 320, 44);
    NSLog(@"%f",self.bottom_view.frame.origin.y);
    [self.view addSubview:self.bottom_view];
    
    UIButton *feedback_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    feedback_btn.frame = CGRectMake(5, 5, self.bottom_view.bounds.size.width-10, 34);
    [feedback_btn setTitle:@"写评论" forState:UIControlStateNormal];
    feedback_btn.backgroundColor=[UIColor whiteColor];
    feedback_btn.tintColor=[UIColor grayColor];
    [feedback_btn.layer setMasksToBounds:YES];
    [feedback_btn.layer setCornerRadius:10.0];
    [feedback_btn.layer setBorderWidth:0.2];
    feedback_btn.tintColor=[UIColor blackColor];
    UIImageView *bg_tip_imgview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 22, 22)];
    bg_tip_imgview.image=[UIImage imageNamed:@"pic_writecomments_default.png"];
    [feedback_btn addSubview:bg_tip_imgview];
    [feedback_btn addTarget:self action:@selector(showEditCommentView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom_view addSubview:feedback_btn];
    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 50, 280, 120)];
    // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 0.2f;
    content.backgroundColor=[UIColor clearColor];
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"请文明发言";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.delegate=self;
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    self.contentTV=content;
    [self.blurView addSubview:content];

    self.cancel_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancel_btn.frame =CGRectMake(20, 5, 100, 40);
    self.cancel_btn.backgroundColor=[UIColor whiteColor];
    [self.cancel_btn.layer setMasksToBounds:YES];
    [self.cancel_btn.layer setCornerRadius:10.0];
    [self.cancel_btn.layer setBorderWidth:0.2];
    self.cancel_btn.tintColor=[UIColor blackColor];

    [self.cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel_btn addTarget:self action:@selector(hideEditCommentView) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.cancel_btn];
    self.send_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.send_btn.frame =CGRectMake(self.blurView.frame.size.width-100-20,5, 100, 40);
    self.send_btn.backgroundColor=[UIColor whiteColor];
    [self.send_btn.layer setMasksToBounds:YES];
    [self.send_btn.layer setCornerRadius:10.0];
    [self.send_btn.layer setBorderWidth:0.2];
    self.send_btn.tintColor=[UIColor blackColor];
    [self.send_btn setTitle:@"发送" forState:UIControlStateNormal];
    [self.send_btn addTarget:self action:@selector(send_Message) forControlEvents:UIControlEventTouchUpInside];
    self.send_btn.enabled=NO;
    [self.blurView addSubview:self.send_btn];
    
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}
-(void)handleSwipeFromRight:(id)sender{
    [self back];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self regNotification];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithService:(Service *)service article:(Article *)article{
    self = [super init];
    if (self) {
        self.service=service;
        self.article=article;
    }
    return self;
}

-(void)reloadCommentsFromNET{
    [self.service fetchLatestCommentsFromNETWithArticle:self.article successHandler:^(NSArray *comments) {
        self.comments=comments;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        // <#code#>
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
    }
    cell.comment=[self.comments objectAtIndex:indexPath.row];
    return [cell preferHeight];
}
static NSString *TileCellID = @"cellname";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
    }
    cell.comment=[self.comments objectAtIndex:indexPath.row];
    return cell;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self unregNotification];
    
}
-(void)showEditCommentView{
    self.contentTV.text=@"";
    self.blurView.hidden=NO;
    [self.contentTV becomeFirstResponder];
    
}
-(void)hideEditCommentView{
    [self.contentTV resignFirstResponder];
}
- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
float keyBoardHeight;
-(void)keyboardWillShow:(NSNotification *)notification{
    self.blurView.hidden=NO;
    CGRect keyBoardRect=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height+36.0f;
    NSLog(@"%f",deltaY);
    keyBoardHeight=deltaY;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.blurView.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.blurView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    self.blurView.hidden=YES;
}
-(void)send_Message{
    NSString *contentStr=self.contentTV.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
        //[self showAlertText:@"请输入内容"];
        return;
    }
    [self.service feedbackArticleWithContent:contentStr article:self.article successHandler:^(BOOL is_ok) {
        [self.contentTV resignFirstResponder];
        [self.view.window showHUDWithText:@"发送成功" Type:ShowPhotoYes Enabled:YES];
        [self reloadCommentsFromNET];
    } errorHandler:^(NSError *error) {
        [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}
- (void)textViewDidChange:(UITextView *)textView{
    NSString *contentStr=self.contentTV.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
        // [self showAlertText:@"请输入内容"];
        self.send_btn.enabled=NO;
        return;
    }
    self.send_btn.enabled=YES;
}

@end
