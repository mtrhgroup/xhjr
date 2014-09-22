//
//  NewsUserInfo.h
//  CampusNewsLetter
//
//  Created by apple on 12-10-23.
//
//

#import <Foundation/Foundation.h>

@interface NewsUserInfo : NSObject
@property(nonatomic,strong)NSString *sn;
@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *email;
@property(nonatomic)BOOL enabled;
@property(nonatomic,strong)NSString *enddate;
@property(nonatomic,strong)NSString *gpID;
@property(nonatomic,strong)NSString *updateTime;
@end
