//
//  JKRequestOptionsProviderUIViewController.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "UITableView+Utility.h"
#import "JKRequestOptionsProviderUIViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "JKOptionSelectorTableViewCell.h"
#import "JKAppearanceProvider.h"

static NSString* cellIdentifier = @"optionSelectorCell";
static const NSInteger totalNumberOfSections = 3;

@interface JKRequestOptionsProviderUIViewController ()
@property (strong, nonatomic) NSArray* sectionHeaderNamesCollection;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableViewFooter;
@property (strong, nonatomic) IBOutlet UIView *tableViewHeader;
@property (strong, nonatomic) NSMutableArray* sectionHeaderViewsCollection;
@property (strong, nonatomic) NSMutableArray* numberOfRowsInRespectiveSection;
@property (strong, nonatomic) NSMutableArray* keyValueParametersCollectionInArray;
@end

@implementation JKRequestOptionsProviderUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionHeaderViewsCollection = [NSMutableArray new];
    self.numberOfRowsInRespectiveSection = [[NSMutableArray alloc] initWithArray:@[@(1),@(1),@(1)]];
    
    if(!self.keyValueParametersCollectionInArray) {
        [self initializeKeyValueHolderArray];
    }
    
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)initializeKeyValueHolderArray {
    if(self.keyValueParametersCollectionInArray){
        [self.keyValueParametersCollectionInArray removeAllObjects];
    }
    else {
        self.keyValueParametersCollectionInArray = [NSMutableArray new];
    }
        NSInteger totalNumberOfSection = totalNumberOfSections;
        while (totalNumberOfSection--) {
            [self.keyValueParametersCollectionInArray addObject:[NSMutableArray new]];
        }
}

#pragma MARK tableView dataSource and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return totalNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numberOfRowsInRespectiveSection[section] integerValue];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath  *)indexPath {
    JKOptionSelectorTableViewCell* currentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(currentCell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"JKOptionSelectorTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        currentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    NSArray* keyValuePairDetailsForCurrentSection = self.keyValueParametersCollectionInArray[indexPath.section];
    if(indexPath.row < keyValuePairDetailsForCurrentSection.count) {
        NSDictionary* currentKeyValuePairDictionary = keyValuePairDetailsForCurrentSection[indexPath.row];
        currentCell.keyField.text = [currentKeyValuePairDictionary allKeys][0];
        currentCell.valueField.text = [currentKeyValuePairDictionary objectForKey:currentCell.keyField.text];
        currentCell.didAddKeyValuePairToArray = YES;
        currentCell.currentKeyValuePairArrayIndex = indexPath.row;
        DLog(@"%@ - Key %@ - Value and current index %d",currentCell.keyField.text,currentCell.valueField.text,indexPath.row);
    }
    else {
        currentCell.keyField.text = @"";
        currentCell.valueField.text = @"";
        currentCell.didAddKeyValuePairToArray = NO;
    }
    
    __weak typeof(JKOptionSelectorTableViewCell*) weakCellInstance = currentCell;
    currentCell.KeyValueAddedBlock = ^(NSString* parameterKey, NSString* parameterValue) {
        __strong typeof(JKOptionSelectorTableViewCell*) strongCellInstance = weakCellInstance;
        if(strongCellInstance.didAddKeyValuePairToArray) {
            [self.keyValueParametersCollectionInArray[indexPath.section] replaceObjectAtIndex:strongCellInstance.currentKeyValuePairArrayIndex withObject:@{parameterKey : parameterValue}];
        }
        else {
            [self.keyValueParametersCollectionInArray[indexPath.section] addObject:@{parameterKey : parameterValue}];
            strongCellInstance.currentKeyValuePairArrayIndex = [self.keyValueParametersCollectionInArray[indexPath.section] count] - 1;
            strongCellInstance.didAddKeyValuePairToArray = YES;
        }
        DLog(@"Current value of key value pair %@",self.keyValueParametersCollectionInArray);
        
    };
    
    
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
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel* headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 40)];
        headerTitleLabel.text = self.sectionHeaderNamesCollection[sectionNumber];
        CGFloat titleLabelWidth = [headerTitleLabel.text
                                   boundingRectWithSize:headerTitleLabel.frame.size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{ NSFontAttributeName:headerTitleLabel.font }
                                   context:nil].size.width;
        
        UIButton* addRowButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + titleLabelWidth , 20, 25, 25)];
        [addRowButton setBackgroundImage:[UIImage imageNamed:@"button_plus_green"] forState:UIControlStateNormal];
        addRowButton.tag = sectionNumber;
        
        UIButton* deleteRowButton = [[UIButton alloc] initWithFrame:CGRectMake(addRowButton.center.x + 25 , 20, 25, 25)];
        [deleteRowButton setBackgroundImage:[UIImage imageNamed:@"button_minus_red"] forState:UIControlStateNormal];
        deleteRowButton.tag = sectionNumber;
        
        [addRowButton addTarget:self action:@selector(addRowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [deleteRowButton addTarget:self action:@selector(deleteRowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headerTitleLabel];
        [headerView addSubview:addRowButton];
        [headerView addSubview:deleteRowButton];
        [self.sectionHeaderViewsCollection setObject:headerView atIndexedSubscript:sectionNumber];
    }
    return self.sectionHeaderViewsCollection[sectionNumber];
}

- (IBAction)cancelButtonPressed:(id)sender {
    if(self.dismissViewButtonAction) {
        self.dismissViewButtonAction(0, nil);
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if(self.dismissViewButtonAction) {
        self.dismissViewButtonAction(1, self.keyValueParametersCollectionInArray);
    }
}



-(IBAction)addRowButtonPressed:(UIButton*)sender {
    [self.view endEditing:YES];
    NSInteger sectionNumberToAddRowsTo = sender.tag;
    NSInteger newNumberOfRowsInSection = [self.numberOfRowsInRespectiveSection[sectionNumberToAddRowsTo] integerValue] + 1;
    [self.numberOfRowsInRespectiveSection setObject:@(newNumberOfRowsInSection) atIndexedSubscript:sectionNumberToAddRowsTo];
    [self.tableView reloadSectionDU:sectionNumberToAddRowsTo withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(IBAction)deleteRowButtonPressed:(UIButton*)sender {
    [self.view endEditing:YES];
    NSInteger sectionNumberToDeleteRowFrom = sender.tag;
    NSInteger newNumberOfRowsInSection = [self.numberOfRowsInRespectiveSection[sectionNumberToDeleteRowFrom] integerValue] - 1;
    
    if(newNumberOfRowsInSection == 0) {
        [self.keyValueParametersCollectionInArray[sectionNumberToDeleteRowFrom] removeAllObjects];
        [self.tableView reloadSectionDU:sectionNumberToDeleteRowFrom withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    DLog(@"%@ ",self.keyValueParametersCollectionInArray[sectionNumberToDeleteRowFrom]);
    if(newNumberOfRowsInSection < [self.keyValueParametersCollectionInArray[sectionNumberToDeleteRowFrom] count]) {
        [self.keyValueParametersCollectionInArray[sectionNumberToDeleteRowFrom] removeLastObject];
    }
    DLog(@"%@ ",self.keyValueParametersCollectionInArray[sectionNumberToDeleteRowFrom]);
    [self.numberOfRowsInRespectiveSection setObject:@(newNumberOfRowsInSection) atIndexedSubscript:sectionNumberToDeleteRowFrom];
    [self.tableView reloadSectionDU:sectionNumberToDeleteRowFrom withRowAnimation:UITableViewRowAnimationNone];
}

-(void)accumulateKeyValuesInParameterHolder:(NSArray*)inputParametersHolderArray {
    NSInteger currentIndex = 1;
    for(NSDictionary* individualKeyValueDictionary in inputParametersHolderArray) {
        for(NSString* key in individualKeyValueDictionary) {
            [self.keyValueParametersCollectionInArray[currentIndex] addObject:@{key : individualKeyValueDictionary[key]}];
        }
        currentIndex++;
    }
    DLog(@"Key value pair collection %@",self.keyValueParametersCollectionInArray);
}

@end
