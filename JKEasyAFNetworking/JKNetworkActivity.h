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
-(void)communicateWithServerWithMethod:(NSString*)method andPathToAPI:(NSString*)pathToAPI andParameters:(NSDictionary*)parameters completion:(void (^)(id JSON))completion failure:(void (^)(NSError * error))failure;
@end
