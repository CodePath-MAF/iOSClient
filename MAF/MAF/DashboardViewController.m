//
//  DashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//


#import "DashboardViewController.h"
#import "Bolts.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

#import "CreateGoalViewController.h"
#import "CreateTransactionViewController.h"
#import "GoalsTableViewController.h"
#import "TransactionsTableViewController.h"
#import "GoalDetailViewController.h"
#import "GoalCardView.h"
#import "GoalManager.h"
#import "GoalStatsView.h"
#import "CashOverView.h"

@interface DashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CashOverViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GoalStatsView *goalStatsView;
@property (weak, nonatomic) IBOutlet CashOverView *cashOverView;

@property (nonatomic, strong) NSMutableArray *goals;

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // TODO start download spinner
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentViewController.title = @"Dashboard";
    
    // Set up Nav Bar Buttons
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
    
    self.navigationItem.leftBarButtonItem = profileButton;
    
    UIBarButtonItem *goalButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createGoal:)];
    
    self.navigationItem.rightBarButtonItem = goalButton;
    
    // Set Up Collection View delegate & data source
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Set Up Goal Stats View
    self.goalStatsView.totalMonthlyGoal = @(92.20); // TODO set this for realz
    self.goalStatsView.totalSpentToday = @(16.23); // TODO set this for realz
    
    // Set Up Cash OverView
    self.cashOverView.delegate = self;
    
    // Stub Goals Cell
    UINib *cellNib = [UINib nibWithNibName:@"GoalCardView" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"GoalCardView"];
    
//    self.stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
//    [self.collectionView registerClass:[GoalCardView class] forCellWithReuseIdentifier:@"GoalCardView"];
    
    // Create Assets View (Collection Section Header)
    
    // Load initial data
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![PFUser currentUser]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [loginViewController setDelegate:self];
        
        SignupViewController *signupViewController = [[SignupViewController alloc] init];
        [signupViewController setDelegate:self];
        
        [loginViewController setSignUpController:signupViewController];
        
        [self presentViewController:loginViewController animated:NO completion:NULL];
    }
    else {
        [[self fetchData] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error fetching goals for user: %@", task.error);
            } else {
                self.goals = [NSMutableArray arrayWithArray:task.result];
                [self.collectionView reloadData];
            }
            // TODO warning end download spinner here
            return task;
        }];
    }
    
   
    // TODO calculate the total monthly goal and total spent today
}

#pragma mark - Data Loading Methods

- (BFTask *)fetchData {
    NSLog(@"Fetching the Dataz");
    return [GoalManager fetchGoalsForUser:[PFUser currentUser]];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.goals count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoalCardView *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GoalCardView" forIndexPath:indexPath];
    cell.goal = self.goals[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected %d Cell", indexPath.row);
    // Create the next view controller.
    GoalDetailViewController *detailViewController = [[GoalDetailViewController alloc] init];
    
    // Pass the selected object to the new view controller.
    detailViewController.goal = [self.goals objectAtIndex:indexPath.row];
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    // TODO custom transition into a Goal Detail View Controller
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Deselected %d Cell", indexPath.row);
    // TODO: Deselect item
}

//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    return NO;
//}

#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(-60, 10, 20, 10);
}

#pragma mark - Collection View Layout Delegates

// TODO for custom movements and fun stuff

#pragma mark - CashOverView Delegate Methods

- (void)viewTransactions:(id)sender {
    NSLog(@"Load Transactions View");
    [self.navigationController pushViewController:[[TransactionsTableViewController alloc] init] animated:YES];
}

#pragma mark - NavBar Methods

- (void)createGoal:(id)sender {
    NSLog(@"Loading Create Goal View");
    [self.navigationController pushViewController:[[CreateGoalViewController alloc] init] animated:YES];
}

- (void)showProfile:(id)sender {
#warning show profile view here
    NSLog(@"Show Profile");
}

#pragma mark - Custom Loading View Methods
- (void)displayContentController:(UIViewController*)content
{
    NSLog(@"Displaying Content");
    [self addChildViewController:content];            // 1
    
    content.view.frame = [self frameForContentController];             // 2
    [self.view addSubview:content.view];
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

- (CGRect)frameForContentController {
    CGRect contentFrame = self.view.bounds;
    CGFloat heightOffset = self.navigationController.navigationBar.frame.size.height;
    contentFrame.origin.y += heightOffset;
    contentFrame.size.height -= heightOffset;
    return contentFrame;
}

#pragma mark - Login/Sign Up Set Up Methods

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
        NSLog(@"Login Complete");
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
        NSLog(@"Sign Up Complete");
    }];
}

@end
