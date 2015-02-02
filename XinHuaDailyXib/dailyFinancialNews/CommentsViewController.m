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
@interface CommentsViewController ()
@property(nonatomic,strong)NSArray *comments;
@property(nonatomic,strong)UITableView *tableView;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
@end
