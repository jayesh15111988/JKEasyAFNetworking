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
    return @[@{allHMACHeaderNames[PUBLIC_KEY] : storedPublicKey}, @{allHMACHeaderNames[HASH] : hashValue}, @{allHMACHeaderNames[NONCE] : xNONCE},@{allHMACHeaderNames[MICROTIME] :  xMICROTIME}];
}

+(NSString*)generateNonceWithUniqueValue:(NSString*)uniqueValue andCurrentTimestamp:(NSString*)currentTimestamp {
    return [NSString stringWithFormat:@"%@ios%@",uniqueValue, currentTimestamp];
}

+(NSString*)generateHashWithPublicKey:(NSString*)publicKey andAppSecret:(NSString*)appSecret andNonce:(NSString*)nonce andCurrentTimestamp:(NSString*)currentTimestamp {
    NSString* inputString = [NSString stringWithFormat:@"%@%@%@",publicKey, currentTimestamp, nonce];
    const char* inputCString = [inputString cStringUsingEncoding:NSUTF8StringEncoding];

    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    const char *cKey  = [appSecret cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned int inputLength = [inputString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

    NSInteger keyLen = strlen(cKey);
    CCHmac(kCCHmacAlgSHA256, cKey, keyLen, inputCString,inputLength, cHMAC);
    DLog(@"SHA Algorithm %d  Key %s Key length %d Input C String %s Input String length %d HMAC value %s",kCCHmacAlgSHA256, cKey, keyLen,inputCString, inputLength, cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];

    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return hash;
}

@end
