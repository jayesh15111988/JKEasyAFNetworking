//
//  JKRestServiceAppSettingsViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKRestServiceAppSettingsViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UIView+Utility.h"

#define TOTAL_SETTING_OPTIONS 2
@interface JKRestServiceAppSettingsViewController ()
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *toSaveRequestsSwitch;
@property (weak, nonatomic) IBOutlet UITextField *maximumNumberOfHistoryItemsField;
@property (strong, nonatomic) IBOutlet UITableViewCell *toSaveRequestsSettingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *maximumHistoryItemsToDisplayCell;
@property (strong, nonatomic) UIView* footerViewForTable;

@end

@implementation JKRestServiceAppSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [self getFooterViewForTable];
    [self.tableView reloadData];
}

-(UIView*)getFooterViewForTable {
    if(!self.footerViewForTable) {
        self.footerViewForTable = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 44)];
        [self.footerViewForTable setBackgroundColor:[UIColor whiteColor]];
        UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,150, 44)];
        okButton.center = self.footerViewForTable.center;
        [okButton setBackgroundColor:[UIColor whiteColor]];
        okButton.layer.borderWidth = 1.0f;
        okButton.layer.borderColor = [UIColor blackColor].CGColor;
        [okButton setTitle:@"Ok" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(closeSettingsDialogue:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerViewForTable addSubview:okButton];
    }
    return self.footerViewForTable;
}

-(IBAction)closeSettingsDialogue:(id)sender {
    if(self.dismissViewButtonAction) {
        self.dismissViewButtonAction();
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"toSaveRequests"]) {
        BOOL toSaveAPIRequestsLocally = [[[NSUserDefaults standardUserDefaults]
                                      objectForKey:@"toSaveRequests"] boolValue];
        [self.toSaveRequestsSwitch setOn:toSaveAPIRequestsLocally];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"maxHistory"]) {
        NSInteger maximumNumberOfRequestsToShow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxHistory"] integerValue];
        self.maximumNumberOfHistoryItemsField.text= [NSString stringWithFormat:@"%d",maximumNumberOfRequestsToShow];
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
    [currentCell addBorderWithColor:[UIColor blackColor] andBorderWidth:1.0f];
    return currentCell;
}

- (IBAction)toSavePreviousRequestsSwitchChanged:(UISwitch*)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.isOn) forKey:@"toSaveRequests"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:self.maximumNumberOfHistoryItemsField.text forKey:@"maxHistory"];
}


@end
