//
//  JKRequestOptionsProviderUIViewController.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum { HEADER, GET, POST } parametersType;

@interface JKRequestOptionsProviderUIViewController : UIViewController

typedef void (^OkButtonPressedBlock)(BOOL isOkAction, NSArray* inputKeyValuePairCollection, BOOL isHMACRequest);
@property (strong, nonatomic) OkButtonPressedBlock dismissViewButtonAction;
@property (assign, nonatomic) BOOL didAddHMACHeaders;
@property (strong, nonatomic) NSMutableArray* numberOfRowsInRespectiveSection;
-(void)initializeKeyValueHolderArray;
-(void)accumulateKeyValuesInParameterHolder:(NSArray*)inputParametersHolderArray;
@end
