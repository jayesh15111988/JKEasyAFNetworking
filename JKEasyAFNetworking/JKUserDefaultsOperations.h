//
//  JKUserDefaultsOperations.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/25/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKUserDefaultsOperations : NSObject
+(void)setObjectInDefaultForValue:(id)value andKey:(NSString*)key;
+(id)getObjectFromDefaultForKey:(NSString*)key;
@end
