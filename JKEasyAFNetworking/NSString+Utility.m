//
//  NSString+Utility.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
-(NSDictionary*)convertJSONStringToDictionaryWithErrorObject:(NSError **)error {

    NSDictionary* dictionaryRepresentationOfJSONString = [NSJSONSerialization
            JSONObjectWithData:[self
                                dataUsingEncoding:NSUTF8StringEncoding]
            options:NSJSONReadingMutableContainers
            error:error];
    
    if(*error) {
        return @{};
    }
    return dictionaryRepresentationOfJSONString;
}

//Reference : http://stackoverflow.com/questions/1471201/how-to-validate-an-url-on-the-iphone
- (BOOL) isURLValid {
    
    NSString* inputString = self;
    
    if([inputString rangeOfString:@"?"].location != NSNotFound) {
        NSArray* tokenizedString = [inputString componentsSeparatedByString:@"?"];
        inputString = tokenizedString[0];
    }
    
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:inputString];
}
@end
