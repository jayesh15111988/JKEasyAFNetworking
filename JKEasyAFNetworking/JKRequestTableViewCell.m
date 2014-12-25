//
//  JKRequestTableViewCell.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/20/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKRequestTableViewCell.h"

@implementation JKRequestTableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.contentView setNeedsUpdateConstraints];
    [UIView animateWithDuration:5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      
        [self.contentView layoutIfNeeded];
        }
    completion:nil];
}

@end
