//
//  KeywordMO.h
//  XinHuaDailyXib
//
//  Created by apple on 14/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KeywordMO : NSManagedObject

@property (nonatomic, retain) NSString * a_keyword_id;
@property (nonatomic, retain) NSNumber * a_keyword_sort;
@property (nonatomic, retain) NSString * a_keyword_name;

@end
