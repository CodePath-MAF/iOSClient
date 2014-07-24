//
//  GoalDetailViewController.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#define DUE_TODAY_STRING @"DUE TODAY (%@)"
#define NUM_PAYMENTS_MADE @"%d of %d Milestones Achieved"
#define CIRCLE_FRIENDS_PER_PAGE 4

#import "OpenSansBoldLabel.h"
#import "OpenSansRegularLabel.h"
#import "OpenSansSemiBoldLabel.h"
#import "GoalDetailViewController.h"
#import "LendingSocialCell.h"
#import "Friend.h"
#import "Utilities.h"
#import "SimpleTransactionViewController.h"
#import "TransactionManager.h"
#import "PNChart.h"
#import "ProgressView.h"
#import "Transaction.h"


@interface GoalDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// Lending Circle View Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *lendingPhotoCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *photoCollectionPageControl;
@property (weak, nonatomic) IBOutlet UIView *lendingPhotoView;

// Payment Reminder View Outlets
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTilDueLabel;

// Make Milestone Progress View Outlets
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (weak, nonatomic) IBOutlet UIButton *goalAchievedButton;
@property (weak, nonatomic) IBOutlet UILabel *paymentsMadeLabel;
@property (weak, nonatomic) IBOutlet UIView *milestoneProgressView;

- (IBAction)flipTileView:(id)sender; // Not Used right now
- (IBAction)makePayment:(id)sender;

@property (nonatomic, strong) NSMutableArray *lendingFriends;

@property (assign, nonatomic) NSInteger tileNum; // Not Used right now

@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@property (weak, nonatomic) IBOutlet OpenSansBoldLabel *goalTotal;
@property (weak, nonatomic) IBOutlet OpenSansRegularLabel *saveToDate;

@end

@implementation GoalDetailViewController

- (void)updateLabels {
    NSArray *payments = [[[TransactionManager instance] transactionsSet] transactionsForGoalId:[self.goal objectId]];
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.2f", self.goal.paymentAmount];

    int goalLifetime = [Utilities daysBetweenDate:self.goal.createdAt andDate:self.goal.targetDate];
    float numPayments = roundf((float)goalLifetime/(float)self.goal.paymentInterval);

    float amountPaid = 0;
    for (Transaction *t in payments) {
        amountPaid += t.amount;
    }
    amountPaid = roundf(amountPaid);
    
    float milestonesCount = (float)amountPaid/(float)self.goal.paymentAmount;
    self.paymentsMadeLabel.text = [[NSString stringWithFormat:NUM_PAYMENTS_MADE, (int)milestonesCount, (int)numPayments] uppercaseString];
    self.goalTotal.text = [NSString stringWithFormat:@"$%.02f", self.goal.total];
    self.saveToDate.text = [NSString stringWithFormat:@"$%.02f SAVED TO DATE", amountPaid];
    
    if (self.goal.total == amountPaid) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.goalAchievedButton.alpha = 1;
            self.makePaymentButton.alpha = 0;
            [self.makePaymentButton removeFromSuperview];
        } completion:nil];
    }
}

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    self.title = self.goal.name;
    NSString *timeTilString;
    timeTilString = [Utilities prettyMessageFromTargetDate:self.goal.targetDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval];
    self.timeTilDueLabel.text = timeTilString;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Init Users for Social
        _lendingFriends = [[NSMutableArray alloc] init];
        NSArray *names = @[@"Sofia.R", @"Mark.S", @"Alyssa.T", @"Rob.C", @"Tom.G", @"Jairo.A", @"Eddie.F", @"Guy.M", @"Mike.H", @"Jose.M", @"Felipe.D", @"Amit.B"];
        for (int userCount = 0; userCount < 12; userCount++) {
            NSString *photoName = [[NSString alloc] initWithFormat:@"profile_%d", userCount+1];
            Friend *friend = [[Friend alloc] initWithName:names[userCount] andPhoto:[UIImage imageNamed:photoName]];
            [_lendingFriends insertObject:friend atIndex:userCount];
            
//            NSLog(@"name: %@", name);
//            NSLog(@"photoName: %@", photoName);
        }
//        NSLog(@"lending user Count: %d", [self.lendingFriends count]);
        
        // Custom initialization
        self.view.frame = [self frameForContentController];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
    
    // Check if Lending Circle Goal Type
    //    self.goal.type ==
    self.lendingPhotoView.hidden = NO;
    
    // Set Up Social Collection View
    self.lendingPhotoCollectionView.delegate = self;
    self.lendingPhotoCollectionView.dataSource = self;
    self.goalAchievedButton.alpha = 0;
    
    UINib *cellNib = [UINib nibWithNibName:@"LendingSocialCell" bundle:nil];
    [self.lendingPhotoCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LendingSocialCell"];
    
    // Set up Pagination
    self.photoCollectionPageControl.currentPage = 0;
    [self.photoCollectionPageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    // Set Up Goal Progress View
    
    // Set Up Make Payment Button
#warning TODO create progress update
    [[self.makePaymentButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:14.f]];

    [Utilities setupRoundedButton:self.makePaymentButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
    [Utilities setupRoundedButton:self.goalAchievedButton withCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateLabels];
    [self drawProgressBar];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger pageCount = [self.lendingFriends count]/CIRCLE_FRIENDS_PER_PAGE;
    self.photoCollectionPageControl.numberOfPages = pageCount;
    return pageCount;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return CIRCLE_FRIENDS_PER_PAGE;
}

- (LendingSocialCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LendingSocialCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"LendingSocialCell" forIndexPath:indexPath];
    cell.friend = self.lendingFriends[(indexPath.section * CIRCLE_FRIENDS_PER_PAGE) + indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected %d Cell", indexPath.row);
    // TODO: share goal progress with friends
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Deselected %d Cell", indexPath.row);
    // TODO: Deselect item
}

#pragma mark - Page Controller

- (void)pageControlChanged:(id)sender
{
    NSLog(@"Page Control Changed");
    UIPageControl *pageControl = sender;
    // TODO bounce when move to new page
    CGFloat pageWidth = self.lendingPhotoCollectionView.frame.size.width;
    NSLog(@"widthFrame: %f", pageWidth);
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    NSLog(@"scrollTo: %f", scrollTo.x);
    [self.lendingPhotoCollectionView setContentOffset:scrollTo animated:YES];
}

// Paging with scoll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.lendingPhotoCollectionView.frame.size.width;
    self.photoCollectionPageControl.currentPage = self.lendingPhotoCollectionView.contentOffset.x / pageWidth;
}

#pragma mark - interaction methods

- (IBAction)flipTileView:(id)sender {
  self.tileNum++; // increment the tile to load
  switch (self.tileNum) {
    case 0:
      NSLog(@"Load Previous Payments View");
      break;
    case 1:
      NSLog(@"Load Social Sharing View");
      break;
    case 2:
      NSLog(@"Load Goals Breakdown Chart View");
      break;
    default: // reset tileNum if there isn't a case
      self.tileNum = 0;
      break;
  }
}

- (IBAction)makePayment:(id)sender {
    SimpleTransactionViewController *simpleTransVC = [[SimpleTransactionViewController alloc] initWithNibName:@"SimpleTransactionViewController" bundle:nil];
    [simpleTransVC setLabelsAndButtons:MakePayment goal:self.goal amount:self.goal.paymentAmount];
    [self.navigationController pushViewController:simpleTransVC animated:YES];  
    NSLog(@"Make a Payment");
}

#pragma mark Helper Functions

- (CGRect)frameForContentController {
  CGRect contentFrame = self.view.bounds;
  CGFloat heightOffset = self.navigationController.navigationBar.bounds.size.height;
  contentFrame.origin.y += heightOffset;
  contentFrame.size.height -= heightOffset;
  
  NSLog(@"%f", heightOffset);
  return contentFrame;
}

- (void)drawProgressBar {
    float goalProgress = [[[TransactionManager instance] transactionsSet] totalPaymentsForGoalId:self.goal.objectId];
    self.progressView.total = self.goal.total;
    self.progressView.progress = goalProgress;
    [self.progressView setNeedsDisplay];
}

@end
