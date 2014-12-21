//
//  JKObjectToStringConvertor.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/20/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKObjectToStringConvertor.h"

@implementation JKObjectToStringConvertor

+(NSString*) jsonStringWithPrettyPrintWithObject:(id)inputObject {
    
    if(!inputObject) {
        return @"";
    }
    
    if([inputObject isKindOfClass:[NSString class]]) {
        return inputObject;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inputObject
                                                       options:(NSJSONWritingOptions) ( NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    if (!jsonData) {
        DLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
