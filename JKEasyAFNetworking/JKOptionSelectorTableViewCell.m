//
//  JKOptionSelectorTableViewCell.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKOptionSelectorTableViewCell.h"
#import "NSString+Utility.h"

@interface JKOptionSelectorTableViewCell ()
@end

@implementation JKOptionSelectorTableViewCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(self.keyField.text.length && self.valueField.text.length) {
        if(self.KeyValueAddedBlock) {
                self.KeyValueAddedBlock(self.keyField.text, self.valueField.text);
        }
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
