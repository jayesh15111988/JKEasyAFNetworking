//
//  UIView+Utility.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/24/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)
- (void)addBorderWithColor:(UIColor*)borderColor andBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)resetViewHierarchy {
    for (UIView *individualViewOnCurrentView in self.subviews) {
        
        if ([individualViewOnCurrentView isKindOfClass:[UITextField class]]) {
            UITextField *inputTextField =
            (UITextField *)individualViewOnCurrentView;
            inputTextField.text = nil;
        } else if ([individualViewOnCurrentView isKindOfClass:[UITextView class]]) {
            UITextView *inputTextView = (UITextView *)individualViewOnCurrentView;
            if(!inputTextView.isEditable) {
                inputTextView.text = @"Non-Editable";
            }
            else {
                inputTextView.text = nil;
            }
        }
        [individualViewOnCurrentView resetViewHierarchy];
    }
}
@end
