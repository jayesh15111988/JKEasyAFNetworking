//
//  JKNetworkActivity.m
//
//
//  Created by Jayesh Kawli on 09/07/14.
//  Copyright (c) 2014 Jayesh Kawli All rights reserved.
//

#import "JKNetworkActivity.h"
#import <AFNetworking.h>
#import "JKURLConstants.h"

typedef enum { inputURLWithBase, inputURLWithoutBase } inputURLType;

typedef enum { GET, POST, PUT, DELETE } serverRequestMethod;


@interface JKNetworkActivity ()

@property(nonatomic, strong) NSDictionary *dataToPost;
@property(nonatomic, strong) NSString *authToken;
@property(strong, nonatomic) NSArray *APIRequestMethodsCollection;


@property(strong, nonatomic) NSString *BaseURL;
@property(strong, nonatomic) NSString *APIVersion;

@property(assign, nonatomic) NSInteger TimeoutPeriod;

@end

@implementation JKNetworkActivity
- (id)initWithData:(NSDictionary *)dataToPost
    andAuthorizationToken:(NSString *)authorizationToken {
    if (!self.dataToPost) {
        self.dataToPost = [[NSDictionary alloc] init];
    }

    if (self = [super init]) {

        self.BaseURL =
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BaseURL"];
        self.APIVersion =
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"APIVersion"];
        
        self.TimeoutPeriod = [[[NSBundle mainBundle]
            objectForInfoDictionaryKey:@"TimeoutPeriod"] integerValue];

        self.APIRequestMethodsCollection =
            @[ @"GET", @"POST", @"PUT", @"DELETE" ];
        self.dataToPost = dataToPost;
        self.authToken = authorizationToken;
    }

    return self;
}

- (void)communicateWithServerWithMethod:(NSInteger)method
                           andIsFullURL:(BOOL)isFullURL
                           andPathToAPI:(NSString *)pathToAPI
                          andParameters:(NSDictionary *)parameters
                             completion:(void (^)(id successResponse))completion
                                failure:
                                    (void (^)(NSError *errorResponse))failure {

    // Convert dictionary data into NSdata representation
    // get full url from tail keyword

   NSString *destinationUrlString;

    if (isFullURL) {
        destinationUrlString = pathToAPI;
    } else {
        destinationUrlString = [self getUrlFromString:pathToAPI];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if(self.authToken && self.authToken.length) {
        [manager.requestSerializer setValue:self.authToken forHTTPHeaderField:@"Authorization"];
    }
    if(method == GET) {
        [manager GET:destinationUrlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else if(method == POST){
        [manager POST:destinationUrlString parameters:self.dataToPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else if (method == PUT) {
        [manager PUT:destinationUrlString parameters:self.dataToPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else if (method == DELETE) {
        [manager DELETE:destinationUrlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else {
        //We have encountered a request that is not currently supported in the app
        NSError* methodNotSupportedError = [[NSError alloc] initWithDomain:@"JK Easy AFNetworking" code:404 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Method not currently supported in the application" , nil) }];
        failure(methodNotSupportedError);
    }
    
    
}

- (NSString *)getUrlFromString:(NSString *)tailEndAPIPath {

    NSString *fullAPIPath =
        [NSString stringWithFormat:@"%@/%@/%@", self.BaseURL, self.APIVersion, tailEndAPIPath];
    return fullAPIPath;
}


@end
