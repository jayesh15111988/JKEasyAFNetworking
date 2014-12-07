//
//  JKRequestOptionsProviderUIViewController.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/6/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JKRequestOptionsProviderUIViewController : UIViewController

typedef void (^OkButtonPressedBlock)(BOOL isOkAction);
@property (strong, nonatomic) OkButtonPressedBlock dismissViewButtonAction;

@end
