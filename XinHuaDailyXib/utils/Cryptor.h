//
//  Cryptor.h
//  XinHuaDailyXib
//
//  Created by apple on 15/3/26.
//
//

#import <Foundation/Foundation.h>
@interface Cryptor : NSObject
- (NSString *)md5:(NSString *)strSource;
- (NSString *)AES256_Encrypt:(NSString *)strSource;
- (NSString *)AES256_Encrypt:(NSString *)strSource withKey:(NSString *)key;
- (NSString *)AES256_Decrypt:(NSString *)strSource withKey:(NSString*)key;
- (NSString *)Base64_Encode:(NSString *)strSource;
- (NSString *)Base64_Decode:(NSString *)strSource;
- (NSString *)RSA_EncryptUsingPublicKeyWithData:(NSString  *)strSource;
- (NSString *)RSA_EncryptUsingPrivateKeyWithData:(NSString *)strSource;
- (NSString *)RSA_DecryptUsingPublicKeyWithData:(NSString *)strSource;
- (NSString *)RSA_DecryptUsingPrivateKeyWithData:(NSString *)strSource;
@end
