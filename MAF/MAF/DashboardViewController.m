//
//  DashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//


#import <Parse/Parse.h>
#import "Bolts.h"

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

#import "TransactionsListViewController.h"
#import "TransactionManager.h"
#import "TransactionsSet.h"

#import "CreateGoalViewController.h"
#import "GoalDetailViewController.h"
#import "GoalCardView.h"
#import "GoalManager.h"
#import "GoalStatsView.h"
#import "CashOverView.h"
#import "User.h"
#import "Utilities.h"

#define PAGE_CONTROL_HEIGHT 40
#define ITEMS_IN_SECTION 2

@interface DashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CashOverViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet GoalStatsView *goalStatsView;
@property (weak, nonatomic) IBOutlet CashOverView *cashOverView;
@property (weak, nonatomic) IBOutlet UILabel *totalCashLabel;

- (IBAction)viewTransactions:(id)sender;

@property (nonatomic, strong) NSMutableArray *goals;
@property (nonatomic, assign) NSInteger page;

- (void)configureNavigationBar;

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
    [self configureNavigationBar];
    
    // Set Up Collection View delegate & data source
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    CGFloat w = self.collectionView.frame.size.width;
    CGFloat h = self.collectionView.frame.size.height;
    
    // Set up the page control
    CGRect frame = CGRectMake(0, h - PAGE_CONTROL_HEIGHT, w, PAGE_CONTROL_HEIGHT);
    self.pageControl = [[UIPageControl alloc]
                        initWithFrame:frame];
    
    // Add a target that will be invoked when the page control is
    // changed by tapping on it
    [self.pageControl
     addTarget:self.collectionView
     action:@selector(pageControlChanged:)
     forControlEvents:UIControlEventValueChanged
     ];
    
    // Set the number of pages to the number of pages in the paged interface
    // and let the height flex so that it sits nicely in its frame
    self.pageControl.numberOfPages = [self.goals count]/ITEMS_IN_SECTION + [self.goals count]%ITEMS_IN_SECTION;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pageControl];
    
    // Set Up Cash OverView
//    self.cashOverView.totalCash = [[User currentUser] totalCash];
//    self.cashOverView.delegate = self;
    self.totalCashLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", 206.50];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView:)];
    [self.cashOverView addGestureRecognizer:tapGestureRecognizer];
    
    // Stub Goals Cell
    UINib *cellNib = [UINib nibWithNibName:@"GoalCardView" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"GoalCardView"];
    
    // Load initial data
    [self.collectionView reloadData];
}

- (void)configureNavigationBar {
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_profile_up"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
    [profileButton setImageInsets:UIEdgeInsetsMake(10.0f, 0, 0, 0)];
    
    [profileButton setBackButtonBackgroundImage:[UIImage imageNamed:@"btn_profile_highlight"] forState:UIControlStateSelected | UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    self.navigationController.navigationBar.barTintColor = [Utilities colorFromHexString:@"#342F33"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:18]};
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:3.5f forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *goalButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_white_up"] style:UIBarButtonItemStylePlain target:self action:@selector(createGoal:)];
    [goalButton setImageInsets:UIEdgeInsetsMake(10.0f, 0, 0, 0)];
    [goalButton setBackButtonBackgroundImage:[UIImage imageNamed:@"btn_add_white_highlight"] forState:UIControlStateSelected | UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = goalButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"btn_leftarrow_white_up"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_leftarrow_white_up"]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![User currentUser]) {
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
}

#pragma mark - Data Loading Methods

- (BFTask *)fetchData {
    return [[[TransactionManager fetchTransactionsForUser:[User currentUser]] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error fetching transactions for user");
        } else {
            self.goalStatsView.transactionSet = [[TransactionsSet alloc] initWithTransactions:task.result];
        }
        return task;
    }] continueWithBlock:^id(BFTask *task) {
        return [GoalManager fetchGoalsForUser:[User currentUser]];
    }];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger totalSections = [self.goals count]/ITEMS_IN_SECTION + [self.goals count]%ITEMS_IN_SECTION;
    if ((section + 1) == totalSections && [self.goals count] % ITEMS_IN_SECTION) {
        return 1;
    }
    return ([self.goals count] <= 1)?[self.goals count]:ITEMS_IN_SECTION;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    NSInteger sections = [self.goals count]/ITEMS_IN_SECTION + [self.goals count]%ITEMS_IN_SECTION;
    return sections;
}

- (GoalCardView *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoalCardView *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GoalCardView" forIndexPath:indexPath];
    // TODO adjust for the section
    cell.goal = self.goals[(indexPath.section * ITEMS_IN_SECTION) + indexPath.item];
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

//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(-40, 10, 20, 10);
//}

#pragma mark - Collection View Layout Delegates

// TODO for custom movements and fun stuff

#pragma mark - CashOverView Delegate Methods

// YES THIS IS DUPLICATE, I'M LAZY
- (void)onTapView:(id)sender {
    NSLog(@"Loading Transactions View");
    [self viewTransactions:sender];
}

- (void)viewTransactions:(id)sender {
    NSLog(@"Load Transactions View");
    [self.navigationController pushViewController:[[TransactionsListViewController alloc] init] animated:YES];
}

#pragma mark - Page Controller

- (void)pageControlChanged:(id)sender
{
    NSLog(@"Page Control Changed");
    UIPageControl *pageControl = sender;
    // TODO bounce when move to new page
    CGFloat pageHeight = self.collectionView.frame.size.height;
    CGPoint scrollTo = CGPointMake(pageHeight * pageControl.currentPage, 0);
    [self.collectionView setContentOffset:scrollTo animated:YES];
}

// Paging with scoll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Slowing Down the scroll");
    CGFloat pageHeight = self.collectionView.frame.size.height;
    self.pageControl.currentPage = self.collectionView.contentOffset.y / pageHeight;
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

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(User *)user {
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

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(User *)user {
    // TODO send a notification via NotificationCenter that the user was signed up
  
    [signUpController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Sign Up Complete");
    }];
}

@end
