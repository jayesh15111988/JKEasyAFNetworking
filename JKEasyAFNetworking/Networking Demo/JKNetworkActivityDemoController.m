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
#import "JKRestServiceAppSettingsViewController.h"
#import "JKNetworkActivity.h"
#import "JKNetworkingRequest.h"
#import <RLMRealm.h>
#import <RLMResults.h>
#import "JKNetworkingWorkspace.h"
#import "JKStoredHistoryOperationUtility.h"
#import "JKNetworkRequestHistoryViewController.h"
#import "JKWorkspacesListViewController.h"
#import "JKURLConstants.h"

#define animationTimeframe 0.5

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
@property(strong, nonatomic) UIPasteboard* generalPasteboard;
@property (strong, nonatomic) NSDateFormatter* formatter;

@property (weak, nonatomic) IBOutlet UIButton *currentWorkspaceLabel;
@property (strong, nonatomic) NSString* headersToSend;
@property (strong, nonatomic) JKRequestOptionsProviderUIViewController* networkRequestParametersProvider;
@property (strong, nonatomic) JKRestServiceAppSettingsViewController* settingsViewController;
@property (strong, nonatomic) JKWorkspacesListViewController* workSpaceList;
@property (strong, nonatomic) JKNetworkRequestHistoryViewController* requestHistory;
@property(weak, nonatomic)
    IBOutlet UIActivityIndicatorView *activityIndicatorView;


- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)sendAPIRequestButtonPressed:(id)sender;
- (IBAction)errorOkButtonPressed:(id)sender;


@end

@implementation JKNetworkActivityDemoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [NSDateFormatter new];
    [self.formatter setDateFormat:@"EEEE MMMM d, YYYY"];
    self.headersToSend = @"";
    [JKStoredHistoryOperationUtility createDefaultWorkSpace];
    
    [self.currentWorkspaceLabel setTitle:[NSString stringWithFormat:@"Workspace : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultWorkspace"]] forState:UIControlStateNormal];

    [self hideErrorViewWithAnimationDuration:0];
    self.networkRequestParametersProvider = [[JKRequestOptionsProviderUIViewController alloc] initWithNibName:@"JKRequestOptionsProviderUIViewController" bundle:nil];
    self.settingsViewController = [[JKRestServiceAppSettingsViewController alloc] initWithNibName:@"JKRestServiceAppSettingsViewController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    self.settingsViewController.dismissViewButtonAction = ^() {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    };
    
    self.networkRequestParametersProvider.dismissViewButtonAction = ^(BOOL isOkAction, NSArray* inputKeyValuePairCollection){
        __strong typeof(self) strongSelf = weakSelf;
        if(inputKeyValuePairCollection) {
            strongSelf.inputGetParameters.text = [NSString stringWithFormat:@"%@",  [[strongSelf getKeyedDictionaryFromArray:inputKeyValuePairCollection[GET]] jsonStringWithPrettyPrint]];
            strongSelf.inputDataToSend.text = [NSString stringWithFormat:@"%@",[[strongSelf getKeyedDictionaryFromArray:inputKeyValuePairCollection[POST]] jsonStringWithPrettyPrint]];
            strongSelf.headersToSend = [NSString stringWithFormat:@"%@",[[strongSelf getKeyedDictionaryFromArray:inputKeyValuePairCollection[HEADER]] jsonStringWithPrettyPrint]];
        }
        [strongSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    };
}

- (IBAction)resetButtonPressed:(id)sender {
    
    //Remove all previous entries from key-value pair array
    [self.networkRequestParametersProvider initializeKeyValueHolderArray];
    
    NSArray *subviewsInCurrentView = [self.view subviews];

    for (UIView *individualViewOnCurrentView in subviewsInCurrentView) {

        if ([individualViewOnCurrentView isKindOfClass:[UITextField class]]) {
            UITextField *inputTextField =
                (UITextField *)individualViewOnCurrentView;
            inputTextField.text = nil;
        } else if ([individualViewOnCurrentView isKindOfClass:[UITextView class]]) {
            UITextView *inputTextView = (UITextView *)individualViewOnCurrentView;
            if(individualViewOnCurrentView == self.serverResponse) {
                inputTextView.text = @"Non-Editable";
            }
            else {
                inputTextView.text = nil;
            }
        }
    }
}

- (IBAction)sendAPIRequestButtonPressed:(id)sender {

    
    NSError *error = nil;
    self.requestSendTime = [NSDate date];
    NSDictionary* inputPOSTData = nil;
    NSDictionary* inputGETParameters = nil;
 
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
            [self storeRequestInDataBaseWithSuccessValue:YES];
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
            [self storeRequestInDataBaseWithSuccessValue:NO];
        }];
}

-(void)storeRequestInDataBaseWithSuccessValue:(BOOL)isRequestSuccessfull {
    BOOL toSaveRequestInHistory = [[[NSUserDefaults standardUserDefaults] objectForKey:@"toSaveRequests"] boolValue];
    NSString* currentWorkspace = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultWorkspace"];
    
    if(toSaveRequestInHistory) {
        JKNetworkingRequest* newAPIRequest = [JKNetworkingRequest new];
        newAPIRequest.parentWorkspaceName = currentWorkspace;
        newAPIRequest.getParameters = self.inputGetParameters.text? : @"";
        newAPIRequest.postParameters = self.inputDataToSend.text? : @"";
        newAPIRequest.authHeaderValue = self.authorizationHeader.text? : @"";
        newAPIRequest.requestMethodType = self.requestType.selectedSegmentIndex;
        newAPIRequest.remoteURL = self.inputURLField.text;
        newAPIRequest.headers = self.headersToSend;
        newAPIRequest.requestCreationTimestamp = [self.formatter stringFromDate:[NSDate date]];
        newAPIRequest.isRequestSuccessfull = isRequestSuccessfull;
        newAPIRequest.requestIdentifier = [JKStoredHistoryOperationUtility generateRandomStringWithLength:7];
        newAPIRequest.serverResponseMessage = self.serverResponse.text;
        
        JKNetworkingWorkspace* workspace = [[JKNetworkingWorkspace objectsWhere:[NSString stringWithFormat:@"workSpaceName = '%@'",currentWorkspace]] firstObject];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [workspace.requests addObject:newAPIRequest];
        [realm commitWriteTransaction];
        
        DLog(@"%d ***",workspace.requests.count);
        
    }
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
                                   [((NSDictionary*)responseMessage) jsonStringWithPrettyPrint]];
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
                             CGAffineTransformMakeScale(0.001, 0.001);
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

-(IBAction)settingsButtonPressed:(id)sender {
    [self presentPopupViewController:self.settingsViewController animationType:MJPopupViewAnimationSlideTopTop];
    
}

-(IBAction)copyServerResponseButtonPressed:(id)sender {
    if(!self.generalPasteboard) {
        self.generalPasteboard = [UIPasteboard generalPasteboard];
    }
    [self.generalPasteboard setString:self.serverResponse.text];
    [self showErrorViewWithMessage:@"Response Successfully Copied to clipboard" andAnimationDuration:0.5];
}

- (IBAction)removeWorkspaceButtonPressed:(id)sender {
    [self showWorkSpaceListViewControllerWithRead:NO];
}


- (IBAction)addWorkspaceButtonPressed:(id)sender {
    [self showInputPopupBoxForNewWorkspace];
}

- (IBAction)viewWorkspaceButtonPressed:(id)sender {
    [self showWorkSpaceListViewControllerWithRead:YES];
    
}

-(void)showWorkSpaceListViewControllerWithRead:(BOOL)isReading {
    if(!self.workSpaceList) {
        self.workSpaceList = [[JKWorkspacesListViewController alloc] initWithNibName:@"JKWorkspacesListViewController" bundle:nil];
        __weak typeof(self) weakSelf = self;

        self.workSpaceList.hideWorkSpaceListsBlockSelected = ^(NSString* updatedWorkspaceName) {
            __strong typeof(self) strongSelf = weakSelf;
            if(updatedWorkspaceName) {
                [strongSelf.currentWorkspaceLabel setTitle:[NSString stringWithFormat:@"Workspace : %@",updatedWorkspaceName] forState:UIControlStateNormal];
            }
            [strongSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
        };
    }
    self.workSpaceList.isReading = isReading;
    self.workSpaceList.topLabelTitle = isReading? @"List Of Available Workspaces" : @"Please Swipe or press edit to remove workspace";
    [self presentPopupViewController:self.workSpaceList animationType:MJPopupViewAnimationSlideTopTop];
    
}

-(void)showInputPopupBoxForNewWorkspace {
    /* Ref : http://stackoverflow.com/questions/26074475/uialertview-vs-uialertcontroller-no-keyboard-in-ios-8 */
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Enter New Workspace Name"
                               message:@"Keep it short and sweet"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
        
                                                   UITextField *textField = alert.textFields[0];
                                                   NSString* newWorkspaceName = textField.text;
                                                   //create new workspace with this name
                                                   if(newWorkspaceName.length > 4) {
                                                       [self showErrorViewWithMessage:[JKStoredHistoryOperationUtility createWorkspaceWithName:newWorkspaceName] andAnimationDuration:0.25];
                                                   }
                                                   else {
                                                       [self showErrorViewWithMessage:@"Workspace name must be at least 5 letters long" andAnimationDuration:0.25];
                                                   }
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       DLog(@"cancel btn");
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Workspace Name";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)showHistoryForCurrentWorkspace:(id)sender {
    if(!self.requestHistory) {
        self.requestHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"requesthistory"];
    }
    
    
    
    
    JKNetworkingWorkspace* currentWorkspaceObject = [[JKNetworkingWorkspace objectsWhere:[NSString stringWithFormat:@"workSpaceName = '%@'",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultWorkspace"]]] firstObject];
    self.requestHistory.requestsForCurrentWorkspace = currentWorkspaceObject.requests;
    
    __weak typeof(self) weakSelf = self;
    self.requestHistory.pastRequestSelectedAction = ^(JKNetworkingRequest* selectedRequest) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
        [strongSelf resetButtonPressed:nil];
        [strongSelf populateInputFieldsWithPreviousRequest:selectedRequest];
    };
    [self presentViewController:self.requestHistory animated:YES completion:nil];
}

-(void)populateInputFieldsWithPreviousRequest:(JKNetworkingRequest*)pastRequestObject {
    self.inputURLField.text = pastRequestObject.remoteURL;
    self.authorizationHeader.text = pastRequestObject.authHeaderValue;
    [self.inputURLScheme setSelectedSegmentIndex:1];
    [self.requestType setSelectedSegmentIndex:pastRequestObject.requestMethodType];
    self.inputGetParameters.text = pastRequestObject.getParameters;
    self.inputDataToSend.text = pastRequestObject.postParameters;
    self.headersToSend = pastRequestObject.headers;
    self.serverResponse.text = pastRequestObject.serverResponseMessage;
    if(pastRequestObject.isRequestSuccessfull) {
        self.serverResponse.textColor = [UIColor blackColor];
    }
    else {
        self.serverResponse.textColor = [UIColor redColor];
    }

}



@end
