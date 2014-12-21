//
//  JKObjectToStringConvertor.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/20/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKObjectToStringConvertor : NSObject
+(NSString*) jsonStringWithPrettyPrintWithObject:(id)inputObject;
@end
