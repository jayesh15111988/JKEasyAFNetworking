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

@end

@implementation JKNetworkRequestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    if(self.pastRequestSelectedAction) {
        self.pastRequestSelectedAction(selectedRequestFromHistory);
    }
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
    requestInfoCell.contentView.backgroundColor = [self getBackgroundColorForCellWithInputSuccessFlag:currentRequest.isRequestSuccessfull];
    return requestInfoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(NSString*)getHTTPMethodNameFromIndex:(NSInteger)methodIndex {
    return  [@[ @"GET", @"POST", @"PUT", @"DELETE" ] objectAtIndex:methodIndex];
}

-(UIColor*)getBackgroundColorForCellWithInputSuccessFlag:(BOOL)wasRequestSuccessful {
    if(wasRequestSuccessful) {
        return [UIColor whiteColor];
    }
    else {
        return [UIColor redColor];
    }
}
@end
