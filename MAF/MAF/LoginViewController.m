//
//  LoginViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init {
    self = [super init];
    if (self) {
        self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton;
        self.emailAsUsername = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
