//
//  MainViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>
#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "CreateGoalViewController.h"
#import "CreateTransactionViewController.h"
#import "GoalsTableViewController.h"
#import "TransactionsTableViewController.h"

@interface MainViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![PFUser currentUser]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [loginViewController setDelegate:self];
        
        SignupViewController *signupViewController = [[SignupViewController alloc] init];
        [signupViewController setDelegate:self];
        
        [loginViewController setSignUpController:signupViewController];
        
        [self presentViewController:loginViewController animated:NO completion:NULL];
    } else {
        [self presentDashboardViewController];
    }
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Please fill in all of the required fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    // TODO switch to TSMessages
    [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:[NSString stringWithFormat:@"%@", error.userInfo[@"error"]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // TODO send a notification via NotificationCenter that the user was logged in
    [logInController dismissViewControllerAnimated:YES completion:^{
        [self presentDashboardViewController];
    }];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    if (
        info[@"username"] && ((NSString *)info[@"username"]).length &&
        // TODO specify a min length for the password
        info[@"password"] && ((NSString *)info[@"password"]).length &&
        // TODO add validation around the phone number
        info[@"additional"]
    ) {
        return YES;
    }
  
    [[[UIAlertView alloc] initWithTitle:@"Signup Failed" message:@"Please fill in all of the required fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    
    return NO;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    // TODO switch to TSMessages
    [[[UIAlertView alloc] initWithTitle:@"Signup Failed" message:[NSString stringWithFormat:@"%@", error.userInfo[@"error"]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    // TODO send a notification via NotificationCenter that the user was signed up
    [signUpController dismissViewControllerAnimated:YES completion:^{
        [self presentDashboardViewController];
    }];
}
     
- (void)presentDashboardViewController {
    DashboardViewController *vc = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    [self.navigationController setViewControllers:@[vc]];
}

@end
