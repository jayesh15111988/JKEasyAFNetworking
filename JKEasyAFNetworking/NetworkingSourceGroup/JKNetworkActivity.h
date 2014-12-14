//
//  JKNetworkActivity.h
//
//
//  Created by Jayesh Kawli on 09/07/14.
//  Copyright (c) 2014 Jayesh Kawli All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKNetworkActivity : NSObject
-(id)initWithData:(NSDictionary*)dataToSend andAuthorizationToken:(NSString*)authorizationToken;
-(void)communicateWithServerWithMethod:(NSInteger)method andIsFullURL:(BOOL)isFullURL andPathToAPI:(NSString*)pathToAPI andParameters:(NSDictionary*)parameters completion:(void (^)(id successResponse))completion failure:(void (^)(NSError * errorResponse))failure;
@property (nonatomic, strong) NSString* remoteURL;
@end
