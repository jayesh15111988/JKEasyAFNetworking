//
//  JKHMACHeadersGenerator.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/20/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKHMACHeadersGenerator.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation JKHMACHeadersGenerator

+(NSArray*)getDesiredHMACHeaderFields {
    NSString* storedPublicKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PublicKey"];
    NSString* xMICROTIME = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString* xNONCE = [self generateNonceWithUniqueValue:@"" andCurrentTimestamp:xMICROTIME];
    NSString* hashValue = [self generateHashWithPublicKey:storedPublicKey andAppSecret:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppSecret"] andNonce:xNONCE andCurrentTimestamp:xMICROTIME];
    NSArray* allHMACHeaderNames = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"HMACHeaders"];
    return @[@{allHMACHeaderNames[0] : storedPublicKey}, @{allHMACHeaderNames[1] : hashValue}, @{allHMACHeaderNames[2] : xNONCE},@{allHMACHeaderNames[3] :  xMICROTIME}];
}

+(NSString*)generateNonceWithUniqueValue:(NSString*)uniqueValue andCurrentTimestamp:(NSString*)currentTimestamp {
    return [NSString stringWithFormat:@"%@ios%@",uniqueValue, currentTimestamp];
}

+(NSString*)generateHashWithPublicKey:(NSString*)publicKey andAppSecret:(NSString*)appSecret andNonce:(NSString*)nonce andCurrentTimestamp:(NSString*)currentTimestamp {
    NSString* inputString = [NSString stringWithFormat:@"%@%@%@",publicKey, currentTimestamp, nonce];
    //NSInteger digestLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    const char* inpString = [inputString cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger inputLength = [inputString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    //NSData* inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSInteger keyLength = [appSecret lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA256, (__bridge const void *)(appSecret), keyLength, inpString,inputLength, cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return hash;
}

@end
