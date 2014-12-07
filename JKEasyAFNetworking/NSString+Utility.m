//
//  NSString+Utility.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
-(NSDictionary*)convertJSONStringToDictionaryWithErrorObject:(NSError **)error {

    NSDictionary* dictionaryRepresentationOfJSONString = [NSJSONSerialization
            JSONObjectWithData:[self
                                dataUsingEncoding:NSUTF8StringEncoding]
            options:NSJSONReadingMutableContainers
            error:error];
    
    if(*error) {
        return @{};
    }
    return dictionaryRepresentationOfJSONString;
}
@end
