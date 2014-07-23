//
//  MainViewController.m
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
#import "DashboardViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "Utilities.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)loginButtonTouched:(id)sender;
- (IBAction)signupButtonTouched:(id)sender;

@end

@implementation MainViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set Up Navigation Bar
    self.navigationController.navigationBar.barTintColor = [Utilities colorFromHexString:@"#342F33"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:18]};
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:3.5f forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"btn_leftarrow_white_up"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_leftarrow_white_up"]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [[self.signupButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:self.signupButton.titleLabel.font.pointSize]];
    [[self.loginButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:self.loginButton.titleLabel.font.pointSize]];
    [Utilities setupRoundedButton:self.signupButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
    [Utilities setupRoundedButton:self.loginButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([User currentUser]) {
        [self.navigationController setViewControllers:@[[[DashboardViewController alloc] init]]];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTouched:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}

- (IBAction)signupButtonTouched:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:[[SignupViewController alloc] init] animated:YES];
}

@end
