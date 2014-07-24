//
//  LoginViewController.m
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "DashboardViewController.h"
#import "SignupViewController.h"
#import "OpenSansLightTextField.h"
#import "Utilities.h"
#import "User.h"
#import "SimpleTransactionViewController.h"

@interface SignupViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet OpenSansLightTextField *nameTextField;
@property (weak, nonatomic) IBOutlet OpenSansLightTextField *emailTextField;
@property (weak, nonatomic) IBOutlet OpenSansLightTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *inactiveSignupButton;
@property (weak, nonatomic) IBOutlet UIButton *activeSignupButton;

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.nameTextField.tag = 1;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.delegate = self;
    self.emailTextField.tag = 2;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.delegate = self;
    self.passwordTextField.tag=3;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.activeSignupButton.alpha = 0;
    [[self.inactiveSignupButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:self.activeSignupButton.titleLabel.font.pointSize]];
    [[self.activeSignupButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:self.activeSignupButton.titleLabel.font.pointSize]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Utilities setupRoundedButton:self.inactiveSignupButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
    [Utilities setupRoundedButton:self.activeSignupButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButtonTouched:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *name = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    PFUser *user = [PFUser user];
    user.username = email;
    user.email = email;
    user.password = password;
    user[@"name"] = name;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"failed to signup user: %@", [error userInfo][@"error"]);
        } else {
            [self.delegate successfulSignup];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 3 && [textField.text length]) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.activeSignupButton.alpha = 1;
            self.inactiveSignupButton.alpha = 0;
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

@end
