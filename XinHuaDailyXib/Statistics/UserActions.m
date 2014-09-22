//
//  UserActions.m
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import "UserActions.h"
#import "UserAction.h"
#import "NewsDefine.h"
static  UserActions *_sharedInstance=nil;
static dispatch_once_t once_token=0;

@implementation UserActions{
    NSMutableArray *marked_array;
    int window_width;
    NSURL *_fetchingURL;
    NSURLConnection *_fetchingConnection;
    NSMutableData *_receivedData;
}

@synthesize count;
+(UserActions *)sharedInstance{
    dispatch_once(&once_token,^{
        if(_sharedInstance==nil){
            _sharedInstance=[[UserActions alloc] init];
        }
    });
    return _sharedInstance;
}
- (id)init
{
    if( self=[super init] )
    {
        m_array=[self fechActions];
        if(m_array==nil){
          m_array = [[NSMutableArray alloc] init];
        }
        marked_array=[[NSMutableArray alloc] init];
        count = 0;
        window_width=50;
    }
    return self;
}
-(void)enqueueAReadAction:(NSString *)article_id{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"read";
    action.action_target=article_id;
    action.action_time=[NSDate date];
    [self enqueue:action];
}
-(void)archiveActions:(NSMutableArray *)actions{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:actions];
    [[NSUserDefaults standardUserDefaults]   setObject:data  forKey:@"user_actions"];
}
-(NSMutableArray *)fechActions{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_actions"];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray * actions=[[NSMutableArray alloc]initWithArray:array];;
    return actions;
}
- (void)enqueue:(UserAction *)anObject
{
    [m_array addObject:anObject];
    count = m_array.count;
    [self archiveActions:m_array];
}
-(void)reportActionsToServer{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:KUserActionURL]];
    NSString *postStr=[[NSString alloc]initWithData:[self markToReport] encoding:NSUTF8StringEncoding];
    postStr=[NSString stringWithFormat:@"json=%@",postStr];
    NSLog(@"%@",postStr);
    NSData *postData=[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //NSData *postData=[self markToReport];
    NSString *postLength=[NSString stringWithFormat:@"%d",[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
- (NSData *)markToReport
{
    [marked_array removeAllObjects];
    for(int i=0;i<[m_array count]&&i<window_width;i++){
        UserAction *action=[m_array objectAtIndex:i];
        [marked_array addObject:action];
    }
    return [self buildReportJson:marked_array];
}
-(NSData *)buildReportJson:(NSArray *)array{
    NSMutableArray *items_arr=[[NSMutableArray alloc]init];
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    for(UserAction *action in array){
        NSInteger interval=[zone secondsFromGMTForDate:action.action_time];
        NSString *localDateString=[[[action.action_time dateByAddingTimeInterval:interval] description] substringToIndex:19];
        NSDictionary *item_dic=[NSDictionary dictionaryWithObjectsAndKeys:action.action_target,@"lid",localDateString,@"clienttime", nil];
        [items_arr addObject:item_dic];
    }
    NSString *os_str=[NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    NSDictionary* json_dic =[NSDictionary dictionaryWithObjectsAndKeys:
                                    os_str,
                                    @"os",
                             [UIDevice customUdid],
                             @"imei",
                                     items_arr,
                                     @"items",
                                    nil];
    __autoreleasing NSError *error=nil;
    id json_data=[NSJSONSerialization dataWithJSONObject:json_dic options:kNilOptions error:&error];
    if(error!=nil)return nil;
    NSLog(@"%@",[[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding]);
    return json_data;   
}
- (void)dequeueMarked
{
    [m_array removeObjectsInArray:marked_array];
    [marked_array removeAllObjects];
    count = [m_array count];
    [self archiveActions:m_array];
}

#pragma mark net callback

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _receivedData=nil;
    _fetchingConnection=nil;
    _fetchingURL=nil;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    NSLog(@"%d",[httpResponse statusCode]);
    if([httpResponse statusCode]==200){
        _receivedData=[[NSMutableData alloc] init];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"data :%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [_receivedData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _fetchingConnection=nil;
    _fetchingURL=nil;
    NSString *receivedText=[[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"##%@",receivedText);
    if([receivedText rangeOfString:@"SUCCESS"].location!=NSNotFound){
        [self dequeueMarked];
    }
    _receivedData=nil;
}
@end
