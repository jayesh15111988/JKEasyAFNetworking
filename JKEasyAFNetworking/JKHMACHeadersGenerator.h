//
//  JKHMACHeadersGenerator.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/20/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {PUBLIC_KEY, HASH, NONCE, MICROTIME} HMACHeaderLabels;

@interface JKHMACHeadersGenerator : NSObject
+(NSArray*)getDesiredHMACHeaderFields;
@end
