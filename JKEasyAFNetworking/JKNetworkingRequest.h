//
//  JKNetworkingRequest.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "RLMObject.h"

@interface JKNetworkingRequest : RLMObject
@property NSString* parentWorkspaceName;
@property NSString* authHeaderValue;
@property NSString* getParameters;
@property NSString* postParameters;
@property NSString* headers;
@property NSInteger requestMethodType;
@property NSString* remoteURL;
@property NSString* requestCreationTimestamp;
@property BOOL isRequestSuccessfull;
@property NSString* requestIdentifier;
@end

RLM_ARRAY_TYPE(JKNetworkingRequest)
