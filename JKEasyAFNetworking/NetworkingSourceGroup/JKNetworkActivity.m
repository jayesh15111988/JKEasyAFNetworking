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
@property(strong, nonatomic) NSArray *APIRequestMethodsCollection;


@property(strong, nonatomic) NSString *BaseURL;
@property(strong, nonatomic) NSString *APIVersion;

@property(assign, nonatomic) NSInteger TimeoutPeriod;

@end

@implementation JKNetworkActivity
- (id)initWithData:(NSDictionary *)dataToPost
     {
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
    }

    return self;
}

- (void)communicateWithServerWithMethod:(NSInteger)method
                           andHeaderFields:(NSDictionary*)headerFields
                           andPathToAPI:(NSString *)pathToAPI
                          andParameters:(NSDictionary *)parameters
                             completion:(void (^)(id successResponse))completion
                                failure:
                                    (void (^)(NSError *errorResponse))failure {

    // Convert dictionary data into NSdata representation
    // get full url from tail keyword

   NSString *destinationUrlString = pathToAPI;

    self.remoteURL = destinationUrlString;
    NSString* encodedRemoteURL = [destinationUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString* headerKey in headerFields) {
        [manager.requestSerializer setValue:headerFields[headerKey] forHTTPHeaderField:headerKey];
    }
    
    //[manager.requestSerializer setva]
    if(method == GET) {
        [manager GET:encodedRemoteURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else if(method == POST){
        [manager POST:encodedRemoteURL parameters:self.dataToPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else if (method == PUT) {
        [manager PUT:encodedRemoteURL parameters:self.dataToPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completion(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
    else if (method == DELETE) {
        [manager DELETE:encodedRemoteURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
