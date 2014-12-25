//
//  JKUserDefaultsOperations.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/25/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKUserDefaultsOperations.h"

@implementation JKUserDefaultsOperations

+(void)setObjectInDefaultForValue:(id)value andKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getObjectFromDefaultForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
