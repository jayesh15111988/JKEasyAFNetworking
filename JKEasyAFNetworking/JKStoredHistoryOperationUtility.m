//
//  JKStoredHistoryOperationUtility.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKStoredHistoryOperationUtility.h"
#import "JKNetworkingWorkspace.h"
#import <RLMObject.h>
#import <RLMRealm.h>
#import <RLMResults.h>

static NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
static NSDateFormatter* dateFormatter;
static NSString* dateFormatterFormatString = @"EEEE MMMM d, YYYY";

@implementation JKStoredHistoryOperationUtility
+(void)createDefaultWorkSpace {
    
    if(![self doesWorkspaceExistsWithName:@"default"]) {
        [self createWorkspaceWithName:@"default"];
    }
}

+(BOOL)doesWorkspaceExistsWithName:(NSString*)inputWorkspaceName {
    RLMResults *defaultWorkspaceResult = [JKNetworkingWorkspace objectsWhere:[NSString stringWithFormat:@"workSpaceName = '%@'",inputWorkspaceName]];
    return ([defaultWorkspaceResult count] > 0);
}

+(NSString*)createWorkspaceWithName:(NSString*)workspaceName {
    
    if(![self doesWorkspaceExistsWithName:workspaceName]) {
        JKNetworkingWorkspace* appWorkSpace = [JKNetworkingWorkspace new];
        appWorkSpace.workSpaceName = workspaceName;
        appWorkSpace.workSpaceIdentifier = [self generateRandomStringWithLength:7];
        if(!dateFormatter) {
            dateFormatter = [NSDateFormatter new];
        }
        [dateFormatter setDateFormat:dateFormatterFormatString];
        appWorkSpace.creationTimestamp = [dateFormatter stringFromDate:[NSDate date]];
        appWorkSpace.successfullRequests = 0;
        appWorkSpace.failedRequests = 0;
    
        RLMRealm* realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:appWorkSpace];
        [realm commitWriteTransaction];
        return [NSString stringWithFormat:@"Workspace %@ successfully created",workspaceName];
    }
    else {
        return [NSString stringWithFormat:@"Workspace %@ already exists. New workspace is not created",workspaceName];
    }
}

+(NSString*)generateRandomStringWithLength:(NSInteger)randomStringLength {
    
    NSMutableString *s = [NSMutableString stringWithCapacity:randomStringLength];
    for (NSUInteger i = 0; i < randomStringLength; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}
@end
