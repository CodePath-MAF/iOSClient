//
//  SignupViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (id)init {
    self = [super init];
    if (self) {
        self.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsAdditional | PFSignUpFieldsDismissButton;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signUpView.usernameField setPlaceholder:@"Email"];
    [self.signUpView.additionalField setPlaceholder:@"Phone Number"];
}

@end
