//
//  NewsUserInfo.h
//  CampusNewsLetter
//
//  Created by apple on 12-10-23.
//
//

#import <Foundation/Foundation.h>

@interface NewsUserInfo : NSObject
@property(nonatomic,copy)NSString *sn;
@property(nonatomic,copy)NSString *description;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *company;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *email;
@property(nonatomic)BOOL enabled;
@property(nonatomic,copy)NSString *enddate;
@property(nonatomic,copy)NSString *gpID;
@property(nonatomic,copy)NSString *updateTime;
@end
