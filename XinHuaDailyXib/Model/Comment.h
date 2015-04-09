//
//  Comment.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property(nonatomic,strong)NSString *comment_id;
@property(nonatomic,strong)NSString *comment_source;
@property(nonatomic,strong)NSString *comment_content;
@property(nonatomic,strong)NSString *comment_time;
@end
