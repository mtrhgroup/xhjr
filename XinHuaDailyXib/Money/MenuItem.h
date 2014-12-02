//
//  MenuItem.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/26.
//
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ItemType)
{
    HomeChannelItem = 0,
    StandardChannelItem = 1,
    Item = 3,
    FatherItem = 4
};
@interface MenuItem : NSObject
@property(nonatomic,strong)NSString *display_name;
@property(nonatomic,assign)ItemType type;
@property(nonatomic,strong)UIViewController *vc;
@property(nonatomic,strong)NSArray *childItem;
@property(nonatomic,assign)BOOL father_is_open;
@end
