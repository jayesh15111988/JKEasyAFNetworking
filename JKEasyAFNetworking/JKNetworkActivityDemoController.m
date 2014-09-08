//
//  JKNetworkActivityDemoController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli on 9/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkActivityDemoController.h"
#import "JKNetworkActivity.h"
#import "JKURLConstants.h"

#define animationTimeframe 2.0f

@interface JKNetworkActivityDemoController ()
@property (weak, nonatomic) IBOutlet UITextField *inputURLField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inputURLScheme;
@property (weak, nonatomic) IBOutlet UISegmentedControl *requestType;
@property (weak, nonatomic) IBOutlet UITextView *inputDataToSend;
@property (weak, nonatomic) IBOutlet UITextView *serverResponse;
@property (weak, nonatomic) IBOutlet UITextView *inputGetParameters;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

- (IBAction)sendAPIRequestButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *inputToolbar;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)errorOkButtonPressed:(id)sender;


@end

@implementation JKNetworkActivityDemoController



-(void)viewDidLoad{
    [super viewDidLoad];
    [self hideErrorViewWithAnimationDuration:0];
    self.inputDataToSend.inputAccessoryView =self.inputToolbar;
    self.inputURLField.inputAccessoryView=self.inputToolbar;
    self.inputGetParameters.inputAccessoryView=self.inputToolbar;
    

}

- (IBAction)sendAPIRequestButtonPressed:(id)sender {
    DLog(@"%d %dselected indices",self.inputURLScheme.selectedSegmentIndex,self.requestType.selectedSegmentIndex);
    [self.view endEditing:YES];
    NSDictionary* inputPOSTData=nil;
    NSDictionary* inputGETParameters=nil;
    NSError* error;
    

    if([self.inputDataToSend.text length]){
        inputPOSTData = [NSJSONSerialization JSONObjectWithData:[self.inputDataToSend.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];

    }
    if([self.inputGetParameters.text length]){
        inputGETParameters = [NSJSONSerialization JSONObjectWithData:[self.inputGetParameters.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
    }
    
    if(![self.inputURLField.text length]){
        [self showErrorViewWithMessage:@"Please input the valid URL in given field" andAnimationDuration:animationTimeframe];
        return;
    }
    
    JKNetworkActivity* newAPIRequest = [[JKNetworkActivity alloc] initWithData:inputPOSTData andAuthorizationToken:AuthorizationToken];
    
    
    [newAPIRequest communicateWithServerWithMethod:self.requestType.selectedSegmentIndex andIsFullURL:self.inputURLScheme.selectedSegmentIndex
                               andPathToAPI:self.inputURLField.text
                                andParameters:inputGETParameters
                              completion:^(id successResponse) {
                                  self.serverResponse.text=[NSString stringWithFormat:@"Server Returned successful response : %@",successResponse];
                                  
                              }
                                 failure:^(NSError* errorResponse) {
                                     
                                     
                                     
                                 }];
}
- (IBAction)doneButtonPressed:(id)sender {
    [self.view endEditing:YES];

    
}

- (IBAction)errorOkButtonPressed:(id)sender {
    [self hideErrorViewWithAnimationDuration:animationTimeframe];
}

-(void)showErrorViewWithMessage:(NSString*)errorMessage andAnimationDuration:(float)animationDuration{
    
    self.errorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.errorMessageLabel.text=errorMessage?:@"No Error Generated";
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
     
                     animations:^(){
                         
                         self.errorView.transform = CGAffineTransformMakeScale(1.0, 1.0);

                     }
                     completion:nil];
    
}

-(void)hideErrorViewWithAnimationDuration:(float)animationDuration{
        self.errorView.transform = CGAffineTransformMakeScale(1, 1);

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
     
                     animations:^(){
                         self.errorView.transform = CGAffineTransformMakeScale(0.0, 0.0);

                     }
                     completion:nil];
    
}
@end
