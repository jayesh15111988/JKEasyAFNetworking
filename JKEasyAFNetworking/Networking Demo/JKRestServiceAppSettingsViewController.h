//
//  JKRestServiceAppSettingsViewController.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/7/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKRestServiceAppSettingsViewController : UIViewController
typedef void (^SettingsOkButtonPressedBlock)();
@property (strong, nonatomic) SettingsOkButtonPressedBlock dismissViewButtonAction;
@end
