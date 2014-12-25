//
//  JKNetworkRequestHistoryViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/14/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <RLMRealm.h>
#import "JKNetworkRequestHistoryViewController.h"
#import "JKRequestTableViewCell.h"
#import "JKAlertViewProvider.h"

@interface JKNetworkRequestHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *historyTitle;
@property (assign, nonatomic) NSInteger actualNumberOfPastRequests;
@end


@implementation JKNetworkRequestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyTitle.text = [NSString stringWithFormat:@"Request History for %@",self.currentWorkspace.workSpaceName];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)hideHistoryViewButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableView datasource and delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKNetworkingRequest* selectedRequestFromHistory = self.requestsForCurrentWorkspace[self.actualNumberOfPastRequests - indexPath.row - 1];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.pastRequestSelectedAction) {
        self.pastRequestSelectedAction(selectedRequestFromHistory);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger maximumNumberOfResults = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxHistory"] integerValue];
    
    self.actualNumberOfPastRequests = self.requestsForCurrentWorkspace.count;
    if(self.requestsForCurrentWorkspace.count > maximumNumberOfResults) {
        return maximumNumberOfResults;
    }
    
    return self.actualNumberOfPastRequests;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKRequestTableViewCell* requestInfoCell = (JKRequestTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"requestcell" forIndexPath:indexPath];
    JKNetworkingRequest* currentRequest = self.requestsForCurrentWorkspace[self.actualNumberOfPastRequests - indexPath.row - 1];
    requestInfoCell.identifierLabel.text = currentRequest.requestIdentifier;
    requestInfoCell.creationDateLabel.text = currentRequest.dateOfRequestCreation;
    requestInfoCell.requestURLLabel.text = currentRequest.remoteURL;
    requestInfoCell.requestMethodLabel.text = [self getHTTPMethodNameFromIndex:currentRequest.requestMethodType];
    [self setTextColorForCellWithInputSuccessFlag:currentRequest.isRequestSuccessfull andInputCell:requestInfoCell];
    return requestInfoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(NSString*)getHTTPMethodNameFromIndex:(NSInteger)methodIndex {
    return  [@[ @"GET", @"POST", @"PUT", @"DELETE" ] objectAtIndex:methodIndex];
}

-(void)setTextColorForCellWithInputSuccessFlag:(BOOL)wasRequestSuccessful andInputCell:(JKRequestTableViewCell*)inputCell {
    UIColor* textColor = wasRequestSuccessful? [UIColor blackColor] : [UIColor redColor];
    for(UIView* subview in inputCell.contentView.subviews) {
        if([subview isKindOfClass:[UILabel class]]) {
            [(UILabel*)subview setTextColor:textColor];
        }
    }
}

#pragma TableView edit delegate methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    JKNetworkingRequest* currentRequestToRemove = self.requestsForCurrentWorkspace[self.actualNumberOfPastRequests - indexPath.row - 1];
    
    [JKAlertViewProvider showAlertWithTitle:@"Delete Request" andMessage:@"Are you sure you want to remove this request from history?" isSingleButton:NO andParentViewController:self andOkAction:^{
        
        RLMRealm* realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:currentRequestToRemove];
        [realm commitWriteTransaction];
        self.tableView.editing = !self.tableView.editing;
        [self getDataAndReloadTable];
        
    } andCancelAction:^{
        DLog(@"Request removal operation cancelled");
    }];
}


- (IBAction)editRequestsTableButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.editing = !self.tableView.editing;
    }
    completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{

}


- (IBAction)clearAllRequestsButtonPressed:(id)sender {
    [JKAlertViewProvider showAlertWithTitle:@"Requests History" andMessage:@"Are you sure you want to clear all history items?" isSingleButton:NO andParentViewController:self andOkAction:^{
        //Remove all History Items for current workspace
        RLMRealm* realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [self.currentWorkspace.requests removeAllObjects];
        [realm commitWriteTransaction];
        [self getDataAndReloadTable];
    } andCancelAction:^{
        DLog(@"Clear History Cancelled");
    }];
}

-(void)getDataAndReloadTable {
    self.requestsForCurrentWorkspace = self.currentWorkspace.requests;
    if(self.requestsForCurrentWorkspace.count > 0){
        [self.tableView reloadData];
    }
    else {
        [JKAlertViewProvider showAlertWithTitle:@"History" andMessage:@"No Requests to display for this workspace" isSingleButton:YES andParentViewController:self andOkAction:^{
            DLog(@"Ok Button Pressed");
        } andCancelAction:nil];
    }
}

@end
