//
//  JKStoredHistoryOperationUtility.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKStoredHistoryOperationUtility : NSObject
+(void)createDefaultWorkSpace;
+(NSString*)generateRandomStringWithLength:(NSInteger)randomStringLength;
+(NSString*)createWorkspaceWithName:(NSString*)workspaceName;
@end
