//
//  JKRequestOptionsProviderUIViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKRequestOptionsProviderUIViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "JKOptionSelectorTableViewCell.h"
#import "JKAppearanceProvider.h"


static NSString* cellIdentifier = @"optionSelectorCell";

@interface JKRequestOptionsProviderUIViewController ()
@property (strong, nonatomic) NSArray* sectionHeaderNamesCollection;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableViewFooter;
@property (strong, nonatomic) IBOutlet UIView *tableViewHeader;
@property (strong, nonatomic) NSMutableArray* sectionHeaderViewsCollection;


@end

@implementation JKRequestOptionsProviderUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionHeaderViewsCollection = [NSMutableArray new];
    self.sectionHeaderNamesCollection = @[@"Headers",@"GET Parameters",@"POST Parameters"];
    self.tableView.tableFooterView = self.tableViewFooter;
    UIView* tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 512, 60)];
    UILabel* headerViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 350, 35)];
    headerViewTitleLabel.center = tableHeaderView.center;
    [headerViewTitleLabel setText:@"Available Request Parameter Options"];
    [headerViewTitleLabel setBackgroundColor:[JKAppearanceProvider DarkOrangeColor]];
    headerViewTitleLabel.textAlignment = NSTextAlignmentCenter;
    [tableHeaderView addSubview:headerViewTitleLabel];
    self.tableView.tableHeaderView = tableHeaderView;
}

#pragma MARK tableView dataSource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath  *)indexPath {
    JKOptionSelectorTableViewCell* currentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(currentCell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"JKOptionSelectorTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        currentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return currentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getHeaderForSectionWithIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

-(UIView*)getHeaderForSectionWithIndex:(NSInteger)sectionNumber {

    
    if (([self.sectionHeaderViewsCollection count] < sectionNumber + 1)) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 512, 60)];
        UILabel* headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 40)];
        headerTitleLabel.text = self.sectionHeaderNamesCollection[sectionNumber];
        CGFloat titleLabelWidth = [headerTitleLabel.text
                                   boundingRectWithSize:headerTitleLabel.frame.size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{ NSFontAttributeName:headerTitleLabel.font }
                                   context:nil].size.width;
        
        UIButton* addRowsButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + titleLabelWidth , 20, 25, 25)];
        [addRowsButton setBackgroundImage:[UIImage imageNamed:@"button_plus_green"] forState:UIControlStateNormal];
        addRowsButton.tag = sectionNumber;
        [addRowsButton addTarget:self action:@selector(addRowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headerTitleLabel];
        [headerView addSubview:addRowsButton];
        [self.sectionHeaderViewsCollection setObject:headerView atIndexedSubscript:sectionNumber];
    }
    return self.sectionHeaderViewsCollection[sectionNumber];
}

- (IBAction)cancelButtonPressed:(id)sender {
    if(self.dismissViewButtonAction) {
        self.dismissViewButtonAction(0);
    }
}



-(IBAction)addRowButtonPressed:(UIButton*)sender {
    DLog(@"Sender Button tag is %d",sender.tag);
}


@end
