//
//  JKWorkspacesListViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/14/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKWorkspacesListViewController.h"
#import "JKNetworkingWorkspace.h"
#import "JKAlertViewProvider.h"
#import "JKUserDefaultsOperations.h"
#import <RLMObject.h>
#import <RLMResults.h>
#import <RLMRealm.h>

@interface JKWorkspacesListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) RLMResults* workSpaceList;
@property (weak, nonatomic) IBOutlet UIButton *editWorkspacesButton;
@property (strong, nonatomic) NSString* currentWorkspaceName;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *titleView;


@end

@implementation JKWorkspacesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBorderToView:self.okButton];
    [self addBorderToView:self.titleView];
    [self addBorderToView:self.tableFooterView];
    self.tableView.tableFooterView = self.tableFooterView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.headerLabel.text = self.topLabelTitle;
    self.editWorkspacesButton.hidden = self.isReading;
    [self getDataAndReloadTable];
}

-(void)addBorderToView:(UIView*)viewToAddBorderTo {
    viewToAddBorderTo.layer.borderColor = [UIColor blackColor].CGColor;
    viewToAddBorderTo.layer.borderWidth = 1.0;
}

-(void)getDataAndReloadTable {
    self.workSpaceList = [JKNetworkingWorkspace allObjects];
    [self.tableView reloadData];
}

#pragma MARK tableView dataSource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workSpaceList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath  *)indexPath {
    UITableViewCell* currentCell = [tableView dequeueReusableCellWithIdentifier:@"workspaceNameCell"];
    if(!currentCell) {
        
        currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workspaceNameCell"];
        UILabel* workSpaceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        workSpaceNameLabel.textAlignment = NSTextAlignmentCenter;
        workSpaceNameLabel.textColor = [UIColor blackColor];
        workSpaceNameLabel.tag = 13;
        [currentCell addSubview:workSpaceNameLabel];
    }
    JKNetworkingWorkspace* currentWorkSpace = self.workSpaceList[indexPath.row];
    UILabel* workSpaceNameLabel = (UILabel*)[currentCell viewWithTag:13];
    workSpaceNameLabel.text = [NSString stringWithFormat:@"%@     %@",currentWorkSpace.workSpaceIdentifier, currentWorkSpace.workSpaceName];
    return currentCell;
}

//Since we do not want to remove default workspace from our table
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row > 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        JKNetworkingWorkspace* workspaceToDelete = self.workSpaceList[indexPath.row];
        //Though this has already been taken care of this check if only for safety in case anything changes
        //In future
        if(![workspaceToDelete.workSpaceName isEqualToString:@"default"]){
            
            [JKAlertViewProvider showAlertWithTitle:@"Remove Workspace" andMessage:[NSString stringWithFormat:@"Are you sure to remove workspace %@ from system?", workspaceToDelete.workSpaceName] isSingleButton:NO andParentViewController:self andOkAction:^{
                
                RLMRealm* realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm deleteObject:workspaceToDelete];
                [realm commitWriteTransaction];
                self.tableView.editing = !self.tableView.editing;
                [self getDataAndReloadTable];
                
            } andCancelAction:^{
                DLog(@"Not deleting workspace");
            }];
        }
        else {
            UIAlertController* alertMessage = [UIAlertController new];
            alertMessage.title = @"Workspace List";
            alertMessage.message = @"Cannot remove default workspace from database";
            [alertMessage addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertMessage animated:YES completion:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isReading) {
        JKNetworkingWorkspace* selectedWorkSpace = self.workSpaceList[indexPath.row];
        self.currentWorkspaceName = selectedWorkSpace.workSpaceName;
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (IBAction)okButtonPressed:(id)sender {
    if(self.hideWorkSpaceListsBlockSelected) {
        [JKUserDefaultsOperations setObjectInDefaultForValue:self.currentWorkspaceName andKey:@"defaultWorkspace"];
        self.hideWorkSpaceListsBlockSelected(self.currentWorkspaceName);
    }
}

- (IBAction)editWorkspaceButtonPressed:(id)sender {
        [self.tableView setEditing:!self.tableView.editing animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //In case tableView is already in editing mode
    self.tableView.editing = NO;
}



@end
