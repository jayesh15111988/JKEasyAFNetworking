//
//  JKNetworkingRequest.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkingRequest.h"

@implementation JKNetworkingRequest
-(NSString*)description {
    return [NSString stringWithFormat:@"%f",self.timestampForRequestCreation];
}
@end
