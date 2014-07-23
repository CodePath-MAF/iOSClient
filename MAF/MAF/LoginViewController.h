//
//  LoginViewController.h
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)successfulLogin;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, strong) id<LoginViewControllerDelegate> delegate;

@end
