//
//  JKNetworkingResponseLargeDisplayViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/25/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkingResponseLargeDisplayViewController.h"
#import "UIView+Utility.h"

@interface JKNetworkingResponseLargeDisplayViewController ()

@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@end

@implementation JKNetworkingResponseLargeDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView addBorderWithColor:[UIColor blackColor] andBorderWidth:1.0f];
    [self.responseTextView addBorderWithColor:[UIColor blackColor] andBorderWidth:1.0f];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.urlLabel.text = self.remoteURL;
    self.responseTextView.text = self.serverResponse;
}

- (IBAction)dismissViewButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
