//
//  JKOptionSelectorTableViewCell.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKOptionSelectorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *keyField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (nonatomic, assign) NSInteger currentKeyValuePairArrayIndex;
@property (nonatomic, assign) BOOL didAddKeyValuePairToArray;
typedef void (^KeyValueAdded)(NSString* key, NSString* value);
@property (strong, nonatomic) KeyValueAdded KeyValueAddedBlock;
@end
