//
//  NetStreamStatistics.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetStreamStatistics.h"
#import "Reachability.h"
static NetStreamStatistics *instance=nil;
@implementation NetStreamStatistics
- (id)init
{
    if (self = [super init]) {
        if([[NSUserDefaults standardUserDefaults]  dictionaryForKey:@"CELLBYTES"]==nil){
            NSDictionary *byteslostDic=[[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"0",@"0",@"1",@"0",@"2",@"0",@"3",@"0",@"4",@"0",@"5",@"0",@"6",@"0",@"7",@"0",@"8",@"0",@"9",@"0",@"10",@"0",@"11",@"0",@"12",nil];
            [[NSUserDefaults standardUserDefaults] setObject:byteslostDic forKey:@"CELLBYTES"];
        }
        if([[NSUserDefaults standardUserDefaults]  dictionaryForKey:@"WIFIBYTES"]==nil){
            NSDictionary *byteslostDic=[[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"0",@"0",@"1",@"0",@"2",@"0",@"3",@"0",@"4",@"0",@"5",@"0",@"6",@"0",@"7",@"0",@"8",@"0",@"9",@"0",@"10",@"0",@"11",@"0",@"12",nil];
            [[NSUserDefaults standardUserDefaults] setObject:byteslostDic forKey:@"WIFIBYTES"];
        }
    }    
    return self;    
}
+(NetStreamStatistics *)sharedInstance{
    if(instance==nil){
        instance=[[NetStreamStatistics alloc]init];
    }
    return instance;
}
-(void)appendBytesToDictionary:(int)bytes{
    if([self is2GOr3GConnected]){
        [self appendBytesTo3GDictionary:bytes];
    }else{
        [self appendBytesToWifiDictionary:bytes];
    }
}
-(void)appendBytesTo3GDictionary:(int)bytes{
    NSLog(@"appendBytesToDictionary %d",bytes);
    NSMutableDictionary *byteslostDic= [[[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"] mutableCopy];
    NSLog(@"THISMONTH %@",byteslostDic);
    NSString *monthStr= [[NSUserDefaults standardUserDefaults] objectForKey:@"THISMONTH"];
    NSLog(@"monthStr %@",monthStr);
    NSString *thisMonthStr=[self currentMonth];
    NSLog(@"%@",thisMonthStr);
    if(![thisMonthStr isEqualToString:monthStr]){
        [[NSUserDefaults standardUserDefaults] setObject:thisMonthStr forKey:@"THISMONTH"];
        [byteslostDic setObject:[NSString stringWithFormat:@"%d",0] forKey:thisMonthStr];
        [[NSUserDefaults  standardUserDefaults] setObject:byteslostDic forKey:@"BYTES"];
    }
    int bytesLostOfThisMonth=[[byteslostDic valueForKey:thisMonthStr] intValue];
    bytesLostOfThisMonth+=bytes;
    
    NSString *bytesLostStr=[NSString stringWithFormat:@"%d",bytesLostOfThisMonth];
    [byteslostDic  setValue:bytesLostStr forKey:thisMonthStr];
    [[NSUserDefaults  standardUserDefaults] setObject:byteslostDic forKey:@"CELLBYTES"];
}
-(void)appendBytesToWifiDictionary:(int)bytes{
    NSLog(@"appendBytesToDictionary %d",bytes);
    NSMutableDictionary *byteslostDic= [[[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"] mutableCopy];
    NSLog(@"THISMONTH %@",byteslostDic);
    NSString *monthStr= [[NSUserDefaults standardUserDefaults] objectForKey:@"THISMONTH"];
    NSLog(@"monthStr %@",monthStr);
    NSString *thisMonthStr=[self currentMonth];
    NSLog(@"%@",thisMonthStr);
    if(![thisMonthStr isEqualToString:monthStr]){
        [[NSUserDefaults standardUserDefaults] setObject:thisMonthStr forKey:@"THISMONTH"];
        [byteslostDic setObject:[NSString stringWithFormat:@"%d",0] forKey:thisMonthStr];
        [[NSUserDefaults  standardUserDefaults] setObject:byteslostDic forKey:@"BYTES"];
    }
    int bytesLostOfThisMonth=[[byteslostDic valueForKey:thisMonthStr] intValue];
    bytesLostOfThisMonth+=bytes;    
    NSString *bytesLostStr=[NSString stringWithFormat:@"%d",bytesLostOfThisMonth];
    [byteslostDic  setValue:bytesLostStr forKey:thisMonthStr];
    [[NSUserDefaults  standardUserDefaults] setObject:byteslostDic forKey:@"WIFIBYTES"];
}
-(NSString *)thisMonthWifiBytesLost{
    NSDictionary *byteslostDicbyWifi= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];
    int bytesLostOfThisMonthByWifi=((NSString *)[byteslostDicbyWifi objectForKey:[self currentMonth]]).intValue;
    NSString *str;
    if(bytesLostOfThisMonthByWifi==0){
        str=@"无";
    }else{
        str=[self bytesFormater:bytesLostOfThisMonthByWifi];
    }
    return str;
}
-(NSString *)lastMonthWifiBytesLost{
    NSDictionary *byteslostDicbyWifi= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];
    int bytesLostOfLastMonthByWifi=((NSString *)[byteslostDicbyWifi objectForKey:[self lastMonth]]).intValue;
    NSString *str;
    if(bytesLostOfLastMonthByWifi==0){
        str=@"无";
    }else{
        str=[self bytesFormater:bytesLostOfLastMonthByWifi];
    }
    return str;
}
-(NSString *)thisMonthCellBytesLost{
    NSDictionary *byteslostDicbyCell= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    int bytesLostOfThisMonthByCell=((NSString *)[byteslostDicbyCell objectForKey:[self currentMonth]]).intValue;
    NSString *str;
    if(bytesLostOfThisMonthByCell==0){
        str=@"无";
    }else{
        str=[self bytesFormater:bytesLostOfThisMonthByCell];
    }
    return str;
}
-(NSString *)lastMonthCellBytesLost{
    NSDictionary *byteslostDicbyCell= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    int bytesLostOfLastMonthByCell=((NSString *)[byteslostDicbyCell objectForKey:[self lastMonth]]).intValue;
    NSString *str;
    if(bytesLostOfLastMonthByCell==0){
        str=@"无";
    }else{
        str=[self bytesFormater:bytesLostOfLastMonthByCell];
    }
    return str;
    
}
-(NSString *)currentMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%d",components.month];
}
-(NSString *)lastMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    int last=0;
    if(components.month>1)last=components.month-1;
    else
        last=12;
    return [NSString stringWithFormat:@"%d",last];
}
-(NSString *)bytesFormater:(int)bytes{
    NSString * str=@"";
    NSLog(@"bytesFormater %d",bytes);
    if(bytes>1024*1024){
        str=[NSString stringWithFormat:@"%.2f M",bytes/(1024.0*1024.0)];
    }else if(bytes>1024){
        str=[NSString stringWithFormat:@"%.2f K",bytes/1024.0];   
    }else{
        str=[NSString stringWithFormat:@"%d B",bytes];   
    }
    return str;
}
-(BOOL)is2GOr3GConnected{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    if([r currentReachabilityStatus]==ReachableViaWWAN){
        return true;
    }else{
        return false;
    }
}
@end
