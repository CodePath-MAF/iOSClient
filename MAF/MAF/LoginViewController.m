//
//  LoginViewController.m
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "OpenSansLightTextField.h"
#import "DashboardViewController.h"
#import "Utilities.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet OpenSansLightTextField *emailTextField;
@property (weak, nonatomic) IBOutlet OpenSansLightTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *inactiveLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *activeLoginButton;
- (IBAction)loginButtonTouched:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTextField.delegate = self;
    self.emailTextField.tag = 1;
    self.passwordTextField.delegate = self;
    self.passwordTextField.tag = 2;
    self.activeLoginButton.alpha = 0;
    [[self.activeLoginButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:self.activeLoginButton.titleLabel.font.pointSize]];
    [[self.inactiveLoginButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:self.inactiveLoginButton.titleLabel.font.pointSize]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Utilities setupRoundedButton:self.inactiveLoginButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
    [Utilities setupRoundedButton:self.activeLoginButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 2 && [textField.text length]) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.activeLoginButton.alpha = 1;
            self.inactiveLoginButton.alpha = 0;
        } completion:nil];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)loginButtonTouched:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"failed to login user: %@", [error userInfo][@"error"]);
        } else {
            [self.navigationController setViewControllers:@[[[DashboardViewController alloc] init]] animated:YES];
        }
    }];
    
}

@end
