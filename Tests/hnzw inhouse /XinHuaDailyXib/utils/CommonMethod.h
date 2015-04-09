//
//  CommonMethod.h
//  Youlu
//
//  Created by William on 10-10-22.
//  Copyright 2010 Youlu . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethod : NSObject {

}

+(NSString*)fileWithUploadPath:(NSString*)filePath;
+(NSString*)fileWithTempPath:(NSString*)filePath;
+(NSString*)fileWithDocumentsPath:(NSString*)filePath;

+(NSInteger) fileSize:(NSString*) filePath;
@end
