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

@interface MainViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, DashBoardViewControllerDelegate>

@property (nonatomic, strong) DashboardViewController *dashboardViewController;
@property (nonatomic, strong) UIViewController *currentViewController;

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

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
  NSLog(@"Presenting Dashboard");
  if (!self.dashboardViewController) {
    self.dashboardViewController = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    
    self.dashboardViewController.delegate = self;
    
    //  self.title = @"CONTAINER";
    
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
    
    self.navigationItem.leftBarButtonItem = profileButton;
    
    UIBarButtonItem *goalButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createGoal:)];
    
    self.navigationItem.rightBarButtonItem = goalButton;
  }
  [self displayContentController:self.dashboardViewController];
}

#pragma mark - Container View Methods

- (void)displayContentController:(UIViewController*)content
{
  NSLog(@"Displaying Content");
  [self addChildViewController:content];            // 1
  CGRect frame = self.view.frame;
#warning this may change if we customize the navigation bar
  CGFloat heightOffset = self.navigationController.navigationBar.frame.size.height;
  frame.origin.y += heightOffset;
  frame.size.height -= heightOffset;
  content.view.frame = frame;             // 2
  [self.view addSubview:content.view];
  self.currentViewController = content;
  [content didMoveToParentViewController:self];          // 3
}

- (void)hideContentController:(UIViewController*)content
{
#warning this doesn't work as expected yet
  NSLog(@"Hiding Content");
  [content willMoveToParentViewController:nil];  // 1
  [content.view removeFromSuperview];            // 2
  [content removeFromParentViewController];      // 3
}

- (CGRect)frameForContentController{
  CGRect contentFrame = self.view.bounds;
  
  return contentFrame;
}

#pragma mark - DashBoard Delegate Methods
- (void)createGoal:(id)sender {
  NSLog(@"Loading Create Goal View");
  [self.navigationController pushViewController:[[CreateGoalViewController alloc] init] animated:YES];
}

- (void)createTransaction:(id)sender {
  NSLog(@"Loading Create Transaction View");
  [self.navigationController pushViewController:[[CreateTransactionViewController alloc] init] animated:YES];
}

- (void)viewGoals:(id)sender {
  NSLog(@"Loading Goals View");
  [self.navigationController pushViewController:[[GoalsTableViewController alloc] init] animated:YES];
}

- (void)viewTransactions:(id)sender {
  NSLog(@"Load Transactions View");
  [self.navigationController pushViewController:[[TransactionsTableViewController alloc] init] animated:YES];
}

- (void)showProfile:(id)sender {
#warning show profile view here
  NSLog(@"Show Profile");
}

@end
