//
//  JKNetworkActivityDemoController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli on 9/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkActivityDemoController.h"
#import "JKNetworkActivity.h"


@interface JKNetworkActivityDemoController ()
@property (weak, nonatomic) IBOutlet UITextField *inputURLField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inputURLScheme;
@property (weak, nonatomic) IBOutlet UISegmentedControl *requestType;
@property (weak, nonatomic) IBOutlet UITextView *inputDataToSend;
@property (weak, nonatomic) IBOutlet UITextView *serverResponse;

@end

@implementation JKNetworkActivityDemoController



-(void)viewDidLoad{
    [super viewDidLoad];
}

@end
