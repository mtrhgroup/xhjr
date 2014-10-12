//
//  Communicator.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>

@interface Communicator : NSObject
-(void)fetchStringAtURL:(NSString *)url successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchFileAtURL:(NSString *)url toPath:(NSString *)path successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)postVariablesToURL:(NSString *)url variables:(NSDictionary *)variables successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
@end
