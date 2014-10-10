//
//  Label.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Label : NSManagedObject

@property (nonatomic, retain) NSString * channel_id;
@property (nonatomic, retain) NSString * channel_name;
@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSNumber * home_number;
@property (nonatomic, retain) NSNumber * is_leaf;
@property (nonatomic, retain) NSString * parent_id;
@property (nonatomic, retain) NSNumber * publish_date;
@property (nonatomic, retain) NSNumber * show_type;
@property (nonatomic, retain) NSNumber * sort_number;

@end
