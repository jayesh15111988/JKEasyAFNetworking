//
//  JKNetworkingWorkspace.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "RLMObject.h"
#import <RLMArray.h>
#import "JKNetworkingRequest.h"

@interface JKNetworkingWorkspace : RLMObject
@property NSString* workSpaceIdentifier;
@property NSString* workSpaceName;
@property NSString* creationTimestamp;
@property NSInteger successfullRequests;
@property NSInteger failedRequests;
@property RLMArray<JKNetworkingRequest> *requests;
@end
