//
//  Cryptor.m
//  XinHuaDailyXib
//
//  Created by apple on 15/3/26.
//
//

#import "Cryptor.h"
#import "NSIks.h"
#import "BasicEncodingRules.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

uint8_t *plainBuffer;
uint8_t *cipherBuffer;
uint8_t *decryptedBuffer;


static const unsigned int kAesIVSize = 16;
static const unsigned int kAesKeySize = 32;
static const UInt8 publicKeyIdentifier[] = "com.apple.sample.publickey222\0";

@interface Cryptor ()
@property (nonatomic,assign) SecKeyRef publicKeyRef;
@property (nonatomic,assign) SecKeyRef privateKeyRef;
@end
@implementation Cryptor
@synthesize publicKeyRef,privateKeyRef;
NSData *publicTag;
-(id)init{
    if(self=[super init]){
        NSString *pubKeyXmlString=@"<RSAKeyValue><Modulus>vQHf8N6D/LESO2KEUn/VL5+hjcN4HWy6YSRTXRdKdjIBkNLOq4/FtFtTXwpQrYCdQL97SJ8XYVbWfwe/THXrwmURwbVY75jl0bolWonocfbQEf7dsEg8OvE7G6KlMBsxmOAuw6h01MEg5436Y5dCOP+7kdbu5wQYUcXT/JDxjOU=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
        self.publicKeyRef=[self getPublicKeyRefFromString:pubKeyXmlString];
    }
    return self;
}
- (SecKeyRef)getPublicKeyRef{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"public_cert" ofType:@"cer"];
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    if(certificateData==nil){
        NSLog(@"no certificate for RSA");
        return nil;
    }
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
        return SecTrustCopyPublicKey(myTrust);
    }else{
        return nil;
    }
    
}
- (void)deleteAsymmetricKeys {
    OSStatus sanityCheck = noErr;
    NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    // Delete the public key.
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
    if (publicKeyRef) CFRelease(publicKeyRef);
}
-(SecKeyRef)getPublicKeyRefFromString:(NSString *)xmlstring{
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  item = xml.xmlObject;
    NSString *ModulusString= [xml findValueFrom:item nodeName:@"Modulus"];
    NSString *ExponentString=[xml findValueFrom:item nodeName:@"Exponent"];
    if(ModulusString==nil||ExponentString==nil)return nil;
    NSData *pubKeyModData=[[NSData alloc] initWithBase64EncodedString:ModulusString options:0];
    NSData *pubKeyExpData=[[NSData alloc] initWithBase64EncodedString:ExponentString options:0];
    NSMutableArray *pubKeyArray=[[NSMutableArray alloc] init];
    [pubKeyArray addObject:pubKeyModData];
    [pubKeyArray addObject:pubKeyExpData];
    NSData *pubKeyData=[pubKeyArray berData];

    [self deleteAsymmetricKeys];
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
    [peerPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [peerPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [peerPublicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [peerPublicKeyAttr setObject:pubKeyData forKey:(__bridge id)kSecValueData];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    OSStatus sanityCheck = noErr;
    CFTypeRef  persistPeer = NULL;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);
    if (sanityCheck != noErr) {
        persistPeer = NULL;
    }
    OSStatus resultCode = noErr;
    SecKeyRef publicKeyReference = NULL;
    
    if(publicKeyRef == NULL) {
        NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
        // Set the public key query dictionary.
        [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        // Get the key.
        resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference);
        //NSLog(@"getPublicKey: result code: %ld", resultCode);
        if(resultCode != noErr)
        {
            publicKeyReference = NULL;
        }
        
        queryPublicKey =nil;
    } else {
        //NSLog(@"no use SecItemCopyMatching\n");
        publicKeyReference = publicKeyRef;
    }
    
    return publicKeyReference;
}


#pragma mark - encrypt/decrypt

- (NSData*)rsaEncryptWithData:(NSData*)data usingPublicKey:(BOOL)yes{
    SecKeyRef key = yes?self.publicKeyRef:self.privateKeyRef;
    if(self.publicKeyRef==NULL)return nil;
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = data;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        }else{
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    //  NSLog(@"Encrypted text (%d bytes): %@", [encryptedData length], [encryptedData description]);
    //  NSLog(@"Encrypted text base64: %@", [Base64 encode:encryptedData]);
    return encryptedData;
}

- (NSData*)rsaDecryptWithData:(NSData*)data usingPublicKey:(BOOL)yes{
    if(self.publicKeyRef==nil)return nil;
    NSData *wrappedSymmetricKey = data;
    SecKeyRef key = yes?self.publicKeyRef:self.privateKeyRef;
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize = [wrappedSymmetricKey length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [wrappedSymmetricKey bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %ld.", sanityCheck);
    
    [bits setLength:keyBufferSize];
    
    return bits;
}

- (NSString *) RSA_EncryptUsingPublicKeyWithData:(NSString *)strSource{
    if(strSource==nil)return nil;
    NSData* originData = [strSource dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"%@",[originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]);
    NSData* cipherData = [self rsaEncryptWithData:originData usingPublicKey:YES];
    return [cipherData base64EncodedStringWithOptions:0];
}

- (NSString *) RSA_EncryptUsingPrivateKeyWithData:(NSString*)strSource{
    if(strSource==nil)return nil;
    NSData* originData = [strSource dataUsingEncoding:NSASCIIStringEncoding];
    NSData* cipherData = [self rsaEncryptWithData:originData usingPublicKey:NO];
    return [cipherData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *) RSA_DecryptUsingPublicKeyWithData:(NSString *)strSource{
    if(strSource==nil)return nil;
    NSData* cipherData = [[NSData alloc] initWithBase64EncodedString:strSource options:0];
    NSData* decryptData=[self rsaDecryptWithData:cipherData usingPublicKey:YES];
    return [[NSString alloc] initWithData:decryptData encoding:NSASCIIStringEncoding];
}

- (NSString *) RSA_DecryptUsingPrivateKeyWithData:(NSString*)strSource{
    if(strSource==nil)return nil;
    NSData* cipherData = [[NSData alloc] initWithBase64EncodedString:strSource options:0];
    NSData* decryptData=[self rsaDecryptWithData:cipherData usingPublicKey:NO];
    return [[NSString alloc] initWithData:decryptData encoding:NSASCIIStringEncoding];
}



-(NSString *)md5:(NSString *)strSource{
    const char *cStrValue=[strSource UTF8String];
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue,strlen(cStrValue),theResult);
    NSData *data=[NSData dataWithBytes:theResult length:sizeof(theResult)];
    NSString * aa=[data base64EncodedStringWithOptions:0];
    NSLog(@"%@",aa);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",theResult[0],theResult[1],theResult[2],theResult[3],theResult[4],theResult[5],theResult[6],theResult[7],theResult[8],theResult[9],theResult[10],theResult[11],theResult[12],theResult[13],theResult[14],theResult[15]];
}
-(NSString *)Base64_Encode:(NSString *)strSource{
    NSData* originData = [strSource dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:0];
    return encodeResult;
}
-(NSString *)Base64_Decode:(NSString *)strSource{
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:strSource options:0];
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    return decodeStr;
}
-(NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}
-(unsigned int)host_network_order:(unsigned int)inval{
    unsigned int outval=0;
    for(int i=0;i<4;i++){
        outval=(outval<<8)+((inval>>(i*8))&255);
    }
    return outval;
}
- (NSString *)AES256_Encrypt:(NSString *)strSource{
    return [self AES256_Encrypt:strSource withKey:@"zhangjian"];
}
-(NSString *)AES256_Encrypt:(NSString *)strSource withKey:(NSString *)key{
    NSLog(@"%s", __func__);
    NSString *keyMD5=[self md5:key];
    
    //randcode
    NSData *bRand=[self randomDataOfLength:16];
    
    //data
    NSData *dataSource= [strSource dataUsingEncoding:NSASCIIStringEncoding];
    unsigned int int_len=[self host_network_order:dataSource.length];
    NSData *data_len=[NSData dataWithBytes:&int_len length:sizeof(unsigned int)];
    NSMutableData *bMsg=[NSMutableData alloc];
    [bMsg appendData:bRand];
    [bMsg appendData:data_len];
    [bMsg appendData:dataSource];
   
    NSLog(@"data before cryptor: %@",[bMsg base64EncodedStringWithOptions:0]);
    // Key
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [keyMD5 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    // IV
    NSString *iv = [keyMD5 substringToIndex:8];
    char ivPtr[kCCBlockSizeAES128];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    
    NSUInteger dataLength = [bMsg length];
    unsigned  int padding = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    unsigned long int newSize = 0;
    newSize = dataLength + padding;
    char dataPtr[newSize];
    memcpy(dataPtr, [bMsg bytes], [bMsg length]);
    memset( dataPtr + dataLength, padding, padding );

    
    size_t bufferSize = [bMsg length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, 0x0000,
                                            keyPtr, kCCKeySizeAES256,
                                            ivPtr,
                                            dataPtr, sizeof(dataPtr),
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess){
        NSLog(@"cryptorStatus == kCCSuccess");
        
        return [[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] base64EncodedStringWithOptions:0];
    }else{
        NSLog(@"cryptorStatus != kCCSuccess");
    }
    
    free(buffer);
    return nil;
}

-(NSString*)AES256_Decrypt:(NSString *)strSource withKey:(NSString*)key{
    NSString *keyMD5=[self md5:key];
    //data
    NSData *dataSource=[[NSData alloc] initWithBase64EncodedString:strSource options:0];
    // Key
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [keyMD5 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    NSString *iv = [keyMD5 substringToIndex:8];
    char ivPtr[kCCBlockSizeAES128];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [dataSource length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 0x0000,
                                          keyPtr, kCCKeySizeAES256,
                                          ivPtr, /* initialization vector (optional) */
                                          [dataSource bytes], [dataSource length], /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
         NSLog(@"decryptStatus == kCCSuccess");
        NSLog(@"data after decrypt =%@",[[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] base64EncodedStringWithOptions:0]);
        return  @"aa";
    }else{
        NSLog(@"decryptStatus != kCCSuccess");
    }
    
    free(buffer); //free the buffer;
    return nil;
}


@end
