//
//  JKNetworkActivityDemoController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli on 9/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <AFNetworking.h>
#import "JKNetworkActivityDemoController.h"
#import "JKRequestOptionsProviderUIViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "NSString+Utility.h"
#import "NSDictionary+Utility.h"
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
@property (strong, nonatomic) JKRequestOptionsProviderUIViewController* networkRequestParametersProvider;
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
    self.networkRequestParametersProvider = [[JKRequestOptionsProviderUIViewController alloc] initWithNibName:@"JKRequestOptionsProviderUIViewController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    self.networkRequestParametersProvider.dismissViewButtonAction = ^(BOOL isOkAction, NSArray* inputKeyValuePairCollection){
        __strong typeof(self) strongSelf = weakSelf;
        if(inputKeyValuePairCollection) {
            strongSelf.inputGetParameters.text = [NSString stringWithFormat:@"%@",  [[strongSelf getKeyedDictionaryFromArray:inputKeyValuePairCollection[GET]] jsonStringWithPrettyPrint]];
            strongSelf.inputDataToSend.text = [NSString stringWithFormat:@"%@",[[strongSelf getKeyedDictionaryFromArray:inputKeyValuePairCollection[POST]] jsonStringWithPrettyPrint]];
        }
        
        [strongSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    };
}

- (IBAction)resetButtonPressed:(id)sender {
    NSArray *subviewsInCurrentView = [self.view subviews];

    for (UIView *individualViewOnCurrentView in subviewsInCurrentView) {

        if ([individualViewOnCurrentView isKindOfClass:[UITextField class]]) {
            UITextField *inputTextField =
                (UITextField *)individualViewOnCurrentView;
            inputTextField.text = nil;
        } else if ([individualViewOnCurrentView isKindOfClass:[UITextView class]]) {
            if(individualViewOnCurrentView != self.serverResponse) {
                UITextView *inputTextView = (UITextView *)individualViewOnCurrentView;
                inputTextView.text = nil;
            }
        }
    }
}

- (IBAction)sendAPIRequestButtonPressed:(id)sender {

    NSDictionary *inputPOSTData = nil;
    NSDictionary *inputGETParameters = nil;
    NSError *error = nil;

    self.requestSendTime = [NSDate date];


    if ([self.inputDataToSend.text length]) {
        inputPOSTData = [self.inputDataToSend.text convertJSONStringToDictionaryWithErrorObject:&error];
    }
    if ([self.inputGetParameters.text length]) {
        inputGETParameters = [self.inputGetParameters.text convertJSONStringToDictionaryWithErrorObject:&error];
    }

    NSString* errorMessage = @"";
    
    if (![self.inputURLField.text length]) {
        errorMessage = @"Please input the valid URL in given field";
    }
    
    if(error != nil) {
        errorMessage = [errorMessage stringByAppendingString:@"\n Please enter valid values of GET/POST parameters in the given fields. E.g. Input parameters strictly follow standard JavaScript array and dictionary notations"];
    }
    
    if(errorMessage.length) {
        [self showErrorViewWithMessage:errorMessage
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
        [NSString stringWithFormat:@"%@",
                                   responseMessage];
}


- (IBAction)errorOkButtonPressed:(id)sender {
    [self hideErrorViewWithAnimationDuration:animationTimeframe];
}

- (void)showErrorViewWithMessage:(NSString *)errorMessage
            andAnimationDuration:(CGFloat)animationDuration {

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

- (void)hideErrorViewWithAnimationDuration:(CGFloat)animationDuration {
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

- (IBAction)addMoreOptionsButtonPressed:(id)sender {
    NSError* getParamersConversionError = nil;
    NSError* postParamersConversionError = nil;
    NSDictionary* getParamertsKeyValueHolderDictionary = @{};
    NSDictionary* postParametersHolderDictionary = @{};
    
    if(self.inputGetParameters.text.length) {
        getParamertsKeyValueHolderDictionary = [self.inputGetParameters.text convertJSONStringToDictionaryWithErrorObject:&getParamersConversionError];
    }
    if(self.inputDataToSend.text.length) {
        postParametersHolderDictionary = [self.inputDataToSend.text convertJSONStringToDictionaryWithErrorObject:&postParamersConversionError];
    }
    
    
    if(getParamertsKeyValueHolderDictionary.count || postParametersHolderDictionary.count) {
        [self.networkRequestParametersProvider initializeKeyValueHolderArray];
        [self.networkRequestParametersProvider accumulateKeyValuesInParameterHolder:@[getParamertsKeyValueHolderDictionary, postParametersHolderDictionary]];
    }
    
    [self presentPopupViewController:self.networkRequestParametersProvider animationType:MJPopupViewAnimationSlideTopTop];
}

- (NSDictionary *) getKeyedDictionaryFromArray:(NSArray *)array {
    NSDictionary* outputDictionary;

    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (outputDictionary in array){
        NSString* key = [[outputDictionary allKeys] firstObject];
        [mutableDictionary setObject:outputDictionary[key] forKey:key];
    }
    return mutableDictionary;
}

@end
