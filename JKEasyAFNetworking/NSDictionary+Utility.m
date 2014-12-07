//
//  NSDictionary+Utility.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)
-(NSString*) jsonStringWithPrettyPrint {
    
    if(!self.count) {
        return @"";
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
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
