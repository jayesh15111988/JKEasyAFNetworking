//
//  JKAlertViewProvider.m
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/25/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKAlertViewProvider.h"

@implementation JKAlertViewProvider

+(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message isSingleButton:(BOOL)singleButton andParentViewController:(UIViewController*)parent andOkAction:(void (^)())okAction  andCancelAction:(void (^)( ))cancelAction {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *ok = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Ok", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   okAction();
                               }];
    
    if(!singleButton) {
        UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action) {
                                 cancelAction();
                             }];
        [alertController addAction:cancel];
    }
    [alertController addAction:ok];
    [parent presentViewController:alertController animated:YES completion:nil];
}
@end
