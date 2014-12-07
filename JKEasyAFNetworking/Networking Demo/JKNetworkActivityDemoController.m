//
//  JKNetworkActivityDemoController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli on 9/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkActivityDemoController.h"
#import <AFNetworking.h>
#import "JKNetworkActivity.h"
#import "JKURLConstants.h"

#define animationTimeframe 2.0f

@interface JKNetworkActivityDemoController ()
@property(weak, nonatomic) IBOutlet UITextField *inputURLField;
@property(weak, nonatomic) IBOutlet UISegmentedControl *inputURLScheme;
@property(weak, nonatomic) IBOutlet UISegmentedControl *requestType;
@property(weak, nonatomic) IBOutlet UITextView *inputDataToSend;
@property(weak, nonatomic) IBOutlet UITextView *serverResponse;
@property(weak, nonatomic) IBOutlet UITextView *inputGetParameters;
@property(weak, nonatomic) IBOutlet UIView *errorView;
@property(weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property(weak, nonatomic) IBOutlet UILabel *executionTime;
@property(strong, nonatomic) NSDate *requestSendTime;
@property(weak, nonatomic) IBOutlet UITextField *authorizationHeader;
@property(weak, nonatomic)
    IBOutlet UIActivityIndicatorView *activityIndicatorView;


- (IBAction)resetButtonPressed:(id)sender;

- (IBAction)sendAPIRequestButtonPressed:(id)sender;
- (IBAction)errorOkButtonPressed:(id)sender;


@end

@implementation JKNetworkActivityDemoController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideErrorViewWithAnimationDuration:0];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
}

- (IBAction)resetButtonPressed:(id)sender {
    NSArray *subviewsInCurrentView = [self.view subviews];

    for (UIView *individualViewOnCurrentView in subviewsInCurrentView) {

        if ([individualViewOnCurrentView isKindOfClass:[UITextField class]]) {
            UITextField *inputTextField =
                (UITextField *)individualViewOnCurrentView;
            inputTextField.text = nil;
        } else if ([individualViewOnCurrentView
                       isKindOfClass:[UITextView class]]) {
            UITextView *inputTextView =
                (UITextView *)individualViewOnCurrentView;
            inputTextView.text = nil;
        }
    }
}

- (IBAction)sendAPIRequestButtonPressed:(id)sender {

    NSDictionary *inputPOSTData = nil;
    NSDictionary *inputGETParameters = nil;
    NSError *error;

    self.requestSendTime = [NSDate date];


    if ([self.inputDataToSend.text length]) {
        inputPOSTData = [NSJSONSerialization
            JSONObjectWithData:[self.inputDataToSend.text
                                   dataUsingEncoding:NSUTF8StringEncoding]
                       options:NSJSONReadingMutableContainers
                         error:&error];
    }
    if ([self.inputGetParameters.text length]) {
        inputGETParameters = [NSJSONSerialization
            JSONObjectWithData:[self.inputGetParameters.text
                                   dataUsingEncoding:NSUTF8StringEncoding]
                       options:NSJSONReadingMutableContainers
                         error:&error];
    }

    if (![self.inputURLField.text length]) {
        [self showErrorViewWithMessage:
                  @"Please input the valid URL in given field"
                  andAnimationDuration:animationTimeframe];
        return;
    }

    // We will check if user had already entered Auth token in the field - If
    // not, we will use the default ones setup
    // Through #defines


    JKNetworkActivity *newAPIRequest = [[JKNetworkActivity alloc]
                 initWithData:inputPOSTData
        andAuthorizationToken:
            self.authorizationHeader.text.length
                ? self.authorizationHeader.text
                : [[NSBundle mainBundle]
                      objectForInfoDictionaryKey:@"Authorization"]];

    [self.activityIndicatorView startAnimating];

    [newAPIRequest
        communicateWithServerWithMethod:self.requestType.selectedSegmentIndex
        andIsFullURL:self.inputURLScheme.selectedSegmentIndex
        andPathToAPI:self.inputURLField.text
        andParameters:inputGETParameters
        completion:^(id successResponse) {

            [self.activityIndicatorView stopAnimating];

            [self showResponseWithMessage:successResponse
                 andIsSuccessfullResponse:YES];
        }
        failure:^(NSError *errorResponse) {

            [self.activityIndicatorView stopAnimating];
            [self showResponseWithMessage:[errorResponse localizedDescription]
                 andIsSuccessfullResponse:NO];
            [self showErrorViewWithMessage:@"Error Occurred in processing the "
                                           @"request. Please try again with "
                                           @"valid URL, Auth token and "
                                           @"parameters"
                      andAnimationDuration:animationTimeframe];
        }];
}

- (void)showResponseWithMessage:(id)responseMessage
       andIsSuccessfullResponse:(BOOL)isRequestSuccessfull {
    NSDate *requestCompletionTime;
    NSTimeInterval executionTime;
    requestCompletionTime = [NSDate date];
    executionTime =
        [requestCompletionTime timeIntervalSinceDate:self.requestSendTime];
    self.executionTime.text =
        [NSString stringWithFormat:@"Executed in %.3f Seconds", executionTime];

    self.serverResponse.text =
        [NSString stringWithFormat:@"\n\n %@",
                                   responseMessage];
}


- (IBAction)errorOkButtonPressed:(id)sender {
    [self hideErrorViewWithAnimationDuration:animationTimeframe];
}

- (void)showErrorViewWithMessage:(NSString *)errorMessage
            andAnimationDuration:(float)animationDuration {

    self.errorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.errorMessageLabel.text = errorMessage ?: @"No Error Generated";

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {

                         self.errorView.transform =
                             CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:nil];
}

- (void)hideErrorViewWithAnimationDuration:(float)animationDuration {
    self.errorView.transform = CGAffineTransformMakeScale(1, 1);

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         self.errorView.transform =
                             CGAffineTransformMakeScale(0.0, 0.0);
                     }
                     completion:nil];
}
@end
