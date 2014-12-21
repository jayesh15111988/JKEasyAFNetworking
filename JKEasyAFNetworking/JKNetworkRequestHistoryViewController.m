//
//  JKNetworkRequestHistoryViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/14/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKNetworkRequestHistoryViewController.h"
#import "JKRequestTableViewCell.h"

@interface JKNetworkRequestHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *historyTitle;

@end


@implementation JKNetworkRequestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyTitle.text = [NSString stringWithFormat:@"Request History for %@",self.currentWorkspaceName];
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
    JKNetworkingRequest* selectedRequestFromHistory = self.requestsForCurrentWorkspace[indexPath.row];
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
    return self.requestsForCurrentWorkspace.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKRequestTableViewCell* requestInfoCell = (JKRequestTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"requestcell" forIndexPath:indexPath];
    JKNetworkingRequest* currentRequest = self.requestsForCurrentWorkspace[indexPath.row];
    requestInfoCell.identifierLabel.text = currentRequest.requestIdentifier;
    requestInfoCell.creationDateLabel.text = currentRequest.requestCreationTimestamp;
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
@end
