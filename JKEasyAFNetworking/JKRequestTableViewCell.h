//
//  JKRequestTableViewCell.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/20/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKRequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestURLLabel;

@end
