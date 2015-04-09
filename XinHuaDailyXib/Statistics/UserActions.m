//
//  UserActions.m
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import "UserActions.h"
#import "UserAction.h"
#import "URLDefine.h"
#import "XHDeviceInfo.h"
@implementation UserActions{
    NSMutableArray *marked_array;
    int window_width;
    NSURL *_fetchingURL;
    NSURLConnection *_fetchingConnection;
    NSMutableData *_receivedData;
    Communicator *_communicator;
}

@synthesize count;
- (id)initWithCommunicator:(Communicator *)communicator
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
        _communicator=communicator;
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
    NSDictionary* json_dic =[NSDictionary dictionaryWithObjectsAndKeys:
                                    [XHDeviceInfo osVersion],
                                    @"os",
                             [XHDeviceInfo udid],
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
-(void)reportActionsToServer:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=kUserActionsURL;
    NSString *postStr=[[NSString alloc]initWithData:[self markToReport] encoding:NSUTF8StringEncoding];
    NSDictionary *variables=[NSDictionary dictionaryWithObject:postStr forKey:@"json"];
    [_communicator postVariablesToURL:url variables:variables successHandler:^(NSString *responseStr) {
        if(successBlock){
            if([responseStr rangeOfString:@"SUCCESS"].location!=NSNotFound){
                [self dequeueMarked];
                successBlock(YES);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
@end
