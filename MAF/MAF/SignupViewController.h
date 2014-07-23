//
//  LoginViewController.h
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignupViewControllerDelegate <NSObject>

- (void)successfulSignup;

@end

@interface SignupViewController : UIViewController

@property (nonatomic, strong) id<SignupViewControllerDelegate> delegate;

@end
