//
//  NSData+AES.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#define gIv          @"0102030405060708" //可以自行修改

@implementation NSData (Encryption)

//(key和iv向量这里是16位的) 这里是CBC加密模式，安全性更高

- (NSData *)AES128EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
//    char ivPtr[kCCKeySizeAES128+1];
//    memset(ivPtr, 0, sizeof(ivPtr));
//    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//    

    NSUInteger dataLength = [self length];
    NSUInteger EncryptLength = 16 - dataLength%16;
    if(dataLength%16!=0){
        dataLength = dataLength + EncryptLength;
    }
    
    //NSString *result  =[[ NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    
    Byte* testByte = malloc(dataLength);
    bzero(testByte,dataLength);
    memcpy(testByte,[self bytes],[self length]);
    
    
    
    
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          nil,
                                          testByte,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    free(testByte);
    return nil;
}


- (NSData *)AES128DecryptWithKey:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//
//    char ivPtr[kCCKeySizeAES128+1];
//    memset(ivPtr, 0, sizeof(ivPtr));
//    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//    
    NSString* str =[[ NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    
    NSData* cipherData = [GTMBase64 decodeString:str];
    
    //    NSString *returnStr = [[NSString alloc] initWithData:[GTMBase64 decodeString:str] encoding:NSUTF8StringEncoding];
//    NSData* DataBytes = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    Byte* ReturnByte = (Byte *)[DataBytes bytes];
//    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end
