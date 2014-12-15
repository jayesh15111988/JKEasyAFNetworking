//
//  JKNetworkRequestHistoryViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/14/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkRequestHistoryViewController.h"

@interface JKNetworkRequestHistoryViewController ()

@end

@implementation JKNetworkRequestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (IBAction)hideHistoryViewButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
