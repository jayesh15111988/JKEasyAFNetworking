//
//  JKNetworkActivity.m
//
//
//  Created by Jayesh Kawli on 09/07/14.
//  Copyright (c) 2014 Jayesh Kawli All rights reserved.
//

#import "JKNetworkActivity.h"
#import <AFNetworking/AFNetworking.h>
#import "JKURLConstants.h"

@interface JKNetworkActivity ()

@property(nonatomic,strong)  NSDictionary* dataToPost;
@property (nonatomic,strong) NSString* authToken;

@end

@implementation JKNetworkActivity
-(id)initWithData:(NSDictionary*)dataToPost andAuthorizationToken:(NSString*)authorizationToken{
    if (!self.dataToPost) {
        self.dataToPost = [[NSDictionary alloc] init];
    }

    if (self = [super init]) {
        self.dataToPost = dataToPost;
        self.authToken = authorizationToken;
    }

    return self;
}

- (void)communicateWithServerWithMethod:(NSString*)method andPathToAPI:(NSString*)pathToAPI andParameters:(NSDictionary*)parameters completion:(void (^)(id JSON))completion failure:(void (^)(NSError* error))failure {

    //Log any error occurred while converting from nsdictionary to nsdata
    NSError* errorRegistrationInfo;

    //Convert dictionary data into NSdata representation
    // get full url from tail keyword

    NSURL* registerUrl = [self getUrlFromString:pathToAPI];

    /* Initialsing httpclient with profiles url to send registration data and set paramter encoding to json format */

    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:registerUrl];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Authorization"
                           value:self.authToken];
    NSMutableURLRequest* request = [httpClient requestWithMethod:method
                                                            path:@""
                                                      parameters:parameters];

    //Request timeout parameter - Decided time after which raises an error code -1001
    //We are increasing timout interval to combat out super slow internet connection

    [request setTimeoutInterval:10];
    if (([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) && self.dataToPost) {
        NSData* journalInfo = [NSJSONSerialization dataWithJSONObject:self.dataToPost
                                                              options:NSJSONWritingPrettyPrinted
                                                                error:&errorRegistrationInfo];

        NSString* userRegistrationDetailsJsondata = [[NSString alloc] initWithData:journalInfo
                                                                          encoding:NSUTF8StringEncoding];
        [request setHTTPBody:[userRegistrationDetailsJsondata dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([method isEqualToString:@"DELETE"]) {

        // Send delete request to remove child history
        [httpClient deletePath:@""
            parameters:nil
            success:^(AFHTTPRequestOperation* operation, id response) {
                       
                       if (completion){
                           completion(response);
                       }
            }
            failure:
                ^(AFHTTPRequestOperation* operation, NSError* error) {
             
             if(failure){
                 failure(error);
             }
             
             DLog(@"Failure while invalidating user auth token");
                }];

    } else {
        AFHTTPRequestOperation* journalRegistrationOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest* request, NSHTTPURLResponse* response, id JSON) {
        if (completion)
            completion(JSON);
            }
            failure:^(NSURLRequest* request, NSURLResponse* response, NSError* error, id JSON) {
                    if(failure){
                    failure(error);
                    }
                               DLog(@"Failed with an error: %@",JSON);
            }];

        [journalRegistrationOperation start];
    }
}

- (NSURL*)getUrlFromString:(NSString*)tailEndAPIPath {

    NSString* fullAPIPath = [NSString stringWithFormat:@"%@/%@/%@", BaseURL, URLExtension, tailEndAPIPath];
    return [NSURL URLWithString:fullAPIPath];
}


@end
