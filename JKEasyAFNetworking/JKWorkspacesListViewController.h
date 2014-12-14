//
//  JKWorkspacesListViewController.h
//  JKEasyAFNetworking
//
//  Created by Jayesh Kawli Backup on 12/14/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKWorkspacesListViewController : UIViewController
@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, strong) NSString* topLabelTitle;
typedef void (^HideWorkSpaceListsBlock)(NSString* updatedWorkspaceName);
@property (strong, nonatomic) HideWorkSpaceListsBlock hideWorkSpaceListsBlockSelected;
@end
