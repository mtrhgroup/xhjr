//
//  DBManager.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import <Foundation/Foundation.h>
#import "DBOperator.h"
@interface DBManager : NSObject
-(DBOperator *)theForegroundOperator;
-(DBOperator *)aBackgroundOperator;
@end
