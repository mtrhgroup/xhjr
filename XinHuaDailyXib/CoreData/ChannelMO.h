//
//  ChannelMO.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChannelMO : NSManagedObject

@property (nonatomic, retain) NSString * a_channel_id;
@property (nonatomic, retain) NSString * a_channel_name;
@property (nonatomic, retain) NSString * a_discription;
@property (nonatomic, retain) NSNumber * a_home_number;
@property (nonatomic, retain) NSNumber * a_is_leaf;
@property (nonatomic, retain) NSString * a_parent_id;
@property (nonatomic, retain) NSNumber * a_publish_date;
@property (nonatomic, retain) NSNumber * a_show_type;
@property (nonatomic, retain) NSNumber * a_sort_number;

@end