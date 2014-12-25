//
//  JKAlertViewProvider.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/25/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKAlertViewProvider : NSObject
+(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message isSingleButton:(BOOL)singleButton andParentViewController:(UIViewController*)parent andOkAction:(void (^)())okAction  andCancelAction:(void (^)( ))cancelAction;
@end
