//
//  JKRestServiceAppSettingsViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKRestServiceAppSettingsViewController.h"

#define TOTAL_SETTING_OPTIONS 2
@interface JKRestServiceAppSettingsViewController ()
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *toSaveRequestsSwitch;
@property (weak, nonatomic) IBOutlet UITextField *maximumNumberOfHistoryItemsField;
@property (strong, nonatomic) IBOutlet UITableViewCell *toSaveRequestsSettingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *maximumHistoryItemsToDisplayCell;
@end

@implementation JKRestServiceAppSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"toSaveRequests"]) {
        BOOL toSaveAPIRequestsLocally = [[[NSUserDefaults standardUserDefaults]
                                      objectForKey:@"toSaveRequests"] boolValue];
        [self.toSaveRequestsSwitch setOn:toSaveAPIRequestsLocally];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"maxHistory"]) {
        NSString* maximumNumberOfRequestsToShow = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxHistory"];
        self.maximumNumberOfHistoryItemsField.text= maximumNumberOfRequestsToShow.length? maximumNumberOfRequestsToShow : @"100";
    }
    
}

#pragma MARK tableView dataSource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TOTAL_SETTING_OPTIONS;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath  *)indexPath {
    UITableViewCell* currentCell = nil;

    switch (indexPath.row) {
        case 0:
             currentCell = self.toSaveRequestsSettingCell;
            break;
        case 1:
            currentCell = self.maximumHistoryItemsToDisplayCell;
            break;
        default:
            break;
    }
    DLog(@"%@ current Cell",currentCell);
    return currentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0;
}

- (IBAction)toSavePreviousRequestsSwitchChanged:(UISwitch*)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.isOn) forKey:@"toSaveRequests"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:self.maximumNumberOfHistoryItemsField.text forKey:@"maxHistory"];
}


@end
