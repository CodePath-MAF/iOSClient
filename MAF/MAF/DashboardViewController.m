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

#import "MultiInputViewController.h"

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
@property (strong, nonatomic) UIView *firstGoalView;
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
    [self toggleAlphaForViews:0];
    self.title = @"Dashboard";
    
    // Set Up Collection View delegate & data source
//    if ([self.goals count] == 0) {
//        [self loadNoGoalView];
//    }
//    else {
        [self loadGoalCollectionView];
//    }
    
    // Stub Goals Cell
    UINib *cellNib = [UINib nibWithNibName:@"GoalCardView" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"GoalCardView"];

    // Set Up Cash OverView - NOT USING FOR NOW
    self.cashOverView.totalCash = [[User currentUser] totalCash];
    self.cashOverView.delegate = self;
//    self.totalCashLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", 206.50];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView:)];
//    [self.cashOverView addGestureRecognizer:tapGestureRecognizer];
}

- (void)toggleAlphaForViews:(float)alpha {
    self.collectionView.alpha = alpha;
    self.goalStatsView.alpha = alpha;
    self.cashOverView.alpha = alpha;
}

- (void)configureNavigationBar {
    
    // Set Up Profile Button
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_profile_up"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
    [profileButton setImageInsets:UIEdgeInsetsMake(8.0f, 0, 0, 0)];
    
    [profileButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_highlight"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    // Set Up Add Goal Button
    UIBarButtonItem *goalButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_white_up"] style:UIBarButtonItemStylePlain target:self action:@selector(createGoal:)];
    [goalButton setImageInsets:UIEdgeInsetsMake(8.0f, 0, 0, 0)];
    [goalButton setBackgroundImage:[UIImage imageNamed:@"btn_add_white_highlight"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = goalButton;
}

- (void)loadGoalCollectionView {
    // Set Delegates
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.firstGoalView.hidden = YES;
    self.collectionView.hidden = NO;
    
    // Load initial data
    [self.collectionView reloadData];
}

- (void)loadNoGoalView {
    CGFloat originY = 280; // Not sure why I can't get this programmatically but everything else seems to be wrong.
    CGFloat height = self.view.frame.size.height - originY;
    CGFloat width = self.collectionView.frame.size.width;
    self.firstGoalView.hidden = NO;
    self.firstGoalView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, width, height)];
    self.firstGoalView.autoresizingMask = self.collectionView.autoresizingMask;
    self.firstGoalView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.firstGoalView];
    self.collectionView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cashOverView setTotalCash:[[User currentUser] totalCash]];

    if (![User currentUser]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
//        [loginViewController setDelegate:self];
        
//        SignupViewController *signupViewController = [[SignupViewController alloc] init];
//        [signupViewController setDelegate:self];
        
//        [loginViewController setSignUpController:signupViewController];
        self.title = @"Sign Up";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        [self.navigationController setViewControllers:@[loginViewController]];
//        [self presentViewController:loginViewController animated:NO completion:NULL];
    }
    else {
        [[self fetchData] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error fetching goals for user: %@", task.error);
            } else {
                self.goals = [NSMutableArray arrayWithArray:task.result];
                [self.collectionView reloadData];
                if([self.goals count] == 0) {
                    // TODO add logic for loading transitioning the first goal view
                }
                else {
                    [self.collectionView reloadData];
                    // TODO load
                }
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [self toggleAlphaForViews:1];
                } completion:nil];
            }
            // TODO warning end download spinner here
            return task;
        }];
    }
}

#pragma mark - Data Loading Methods

- (BFTask *)fetchData {
    return [[[[TransactionManager instance] fetchTransactionsForUser:[User currentUser]] continueWithBlock:^id(BFTask *task) {
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
//    NSInteger totalSections = [self.goals count]/ITEMS_IN_SECTION + [self.goals count]%ITEMS_IN_SECTION;
//    if ((section + 1) == totalSections && [self.goals count] % ITEMS_IN_SECTION) {
//        return 1;
//    }
//    return ([self.goals count] <= 1)?[self.goals count]:ITEMS_IN_SECTION;
    return [self.goals count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
//    NSInteger sections = [self.goals count]/ITEMS_IN_SECTION + [self.goals count]%ITEMS_IN_SECTION;
    NSInteger sections = 1;
    return sections;
}

- (GoalCardView *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoalCardView *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GoalCardView" forIndexPath:indexPath];
    // TODO adjust for the section
    cell.goal = self.goals[indexPath.item];
    cell.alpha = 0.0f;
    
    NSInteger direction = 1;
    if (indexPath.item % 2) {
        direction = -1;
    }
    
    CGRect frame = cell.frame;
    CGRect originalFrame = frame;
    frame.origin.x = direction*frame.size.width;
    cell.frame = frame;
    
    [UIView transitionWithView:cv
                      duration:.75
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        //any animatable attribute here.
                        cell.alpha = 1.0f;
                        cell.frame = originalFrame;
                        
                    } completion:^(BOOL finished) {
                        
                        //whatever you want to do upon completion
                        
                    }];
    
    [cell updateColors];
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

//- (void)pageControlChanged:(id)sender
//{
//    NSLog(@"Page Control Changed");
//    UIPageControl *pageControl = sender;
//    // TODO bounce when move to new page
//    CGFloat pageHeight = self.collectionView.frame.size.height * ITEMS_IN_SECTION;
//    CGPoint scrollTo = CGPointMake(0, pageHeight * pageControl.currentPage);
//    [self.collectionView setContentOffset:scrollTo animated:YES];
//}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    // TODO, do some cool stuff with the goals.
}

// Paging with scroll
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if(velocity.y > 0) { // scrolling up at a certain velocity
//        if(self.pageControl.currentPage != 0) {
//            self.pageControl.currentPage--;
//        }
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:self.pageControl.currentPage*ITEMS_IN_SECTION] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    else if (velocity.y < 0) { // scrolling down at a certain velocity
//        self.pageControl.currentPage++;
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:self.pageControl.currentPage*ITEMS_IN_SECTION] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    else { // lock the page back to original
        
    }
}

#pragma mark - NavBar Methods

- (void)createGoal:(id)sender {
    NSLog(@"Loading Create Goal View");
//    [self.navigationController pushViewController:[[CreateGoalViewController alloc] init] animated:YES];
    [self.navigationController pushViewController:[[MultiInputViewController alloc] initWithMultiInputType:Goal_Creation] animated:YES];
    
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

@end
