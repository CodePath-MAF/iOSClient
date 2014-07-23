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

#import "GoalManager.h"
#import "TransactionManager.h"
#import "SliceProgressBar.h"
#import "GoalDetailViewController.h"
#import "LendingSocialCell.h"
#import "Friend.h"

#import "PNStackedBarChartDataItem.h"
#import "Utilities.h"
#import "SimpleTransactionViewController.h"
#import "TransactionManager.h"
#import "PNChart.h"
#import "ProgressView.h"


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
@property (weak, nonatomic) IBOutlet UILabel *paymentsMadeLabel;
@property (weak, nonatomic) IBOutlet UIView *nextPaymentView;
@property (weak, nonatomic) IBOutlet UIView *milestoneProgressContainer;
@property (strong, nonatomic) SliceProgressBar *milestoneProgressBar;

//- (IBAction)flipTileView:(id)sender; // Not Used right now
- (IBAction)makePayment:(id)sender;

@property (nonatomic, strong) NSMutableArray *lendingFriends;
@property (nonatomic, strong) NSMutableArray *paymentsMade;
@property (nonatomic, assign) CGFloat totalGoalProgress;
@property (nonatomic, assign) NSInteger milestonesHit;
@property (nonatomic, strong) NSTimer *progressTimer;

//@property (assign, nonatomic) NSInteger tileNum; // Not Used right now

@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@end

@implementation GoalDetailViewController

- (void)updateLabels {
    NSArray *payments = [[[TransactionManager instance] transactionsSet] transactionsForGoalId:[self.goal objectId]];
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.2f", self.goal.paymentAmount];
    self.paymentsMadeLabel.text = [NSString stringWithFormat:NUM_PAYMENTS_MADE, payments.count, self.goal.paymentInterval];
}

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    self.title = self.goal.name;
    NSString *timeTilString;
    if ([MHPrettyDate isToday:self.goal.targetDate]) {
        timeTilString = [NSString stringWithFormat:DUE_TODAY_STRING, [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
    }
    else {
    timeTilString = [NSString stringWithFormat:TIME_TIL_DUE_STRING, [Utilities daysBetweenDate:[NSDate date] andDate:self.goal.targetDate], [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
    }

    NSLog(@"goal total: %f", self.goal.total);
    
    // Don't do this, LETS BE SOCIAL
//    if(self.goal.type != GoalTypeLendingCircle) {
//        [self.lendingPhotoView removeFromSuperview];
//#warning TODO figure out how to adjust the other next payment view to move up
//    }
    
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
            
            // Grab from transactionSet
            self.paymentsMade = [[NSMutableArray alloc] initWithArray:@[@(12.5), @(62.24), @(25.61), @(29.5)]];
        }
        
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
    if(self.goal.type == GoalTypeLendingCircle) {
        // adjust view
    }
    
    // Set Up Social Collection View
    self.lendingPhotoCollectionView.delegate = self;
    self.lendingPhotoCollectionView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"LendingSocialCell" bundle:nil];
    [self.lendingPhotoCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LendingSocialCell"];
    
    // Set Up Pagination
    self.photoCollectionPageControl.currentPage = 0;
    [self.photoCollectionPageControl addTarget:self
                                        action:@selector(pageControlChanged:)
                              forControlEvents:UIControlEventValueChanged];
    
    // Set Up Goal Progress View
    [self loadMilestoneProgress];
    
    // Set Up Make Payment Button
#warning TODO create progress update
    [Utilities setupRoundedButton:self.makePaymentButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
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

#pragma mark - Update Goal Progress Methods

// Not Used Anymore
//- (IBAction)flipTileView:(id)sender {
//  self.tileNum++; // increment the tile to load
//  switch (self.tileNum) {
//    case 0:
//      NSLog(@"Load Previous Payments View");
//      break;
//    case 1:
//      NSLog(@"Load Social Sharing View");
//      break;
//    case 2:
//      NSLog(@"Load Goals Breakdown Chart View");
//      break;
//    default: // reset tileNum if there isn't a case
//      self.tileNum = 0;
//      break;
//  }
//}

- (NSArray *)getDataItems {
//    NSArray *transactions = [[TransactionManager instance] transactions];
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
//    for (Transaction *transaction in categories) {
//        float categoryTotal = [(NSNumber *)[categoriesForDate objectForKey:category.name] floatValue] ?: 0;
//        if (categoryTotal) {
//            dateTotal += categoryTotal;
//            PNStackedBarChartDataItem *item = [PNStackedBarChartDataItem dataItemWithValue:categoryTotal color:[[TransactionCategoryManager instance] colorForCategory:category]];
//            [dataItems addObject:item];
//        }
//    }
    NSLog(@"Getting Data Items For Progress");
    for (NSNumber *number in self.paymentsMade) {
        
        UIColor *lightGreen = [[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f];
        PNStackedBarChartDataItem *item = [PNStackedBarChartDataItem dataItemWithValue:[number floatValue] color:lightGreen];
        [dataItems addObject:item];
    }
    
//    if (dateTotal > _maxValue) {
//        _maxValue = dateTotal;
//    }
    return dataItems;
}

- (void)updateMilestoneProgress {
    NSLog(@"SUM: %0.2f", self.totalGoalProgress);
    NSInteger currentMilestoneCount = self.milestonesHit;
    NSInteger newMilestoneCount = self.totalGoalProgress/self.goal.paymentAmount;
    
    if(currentMilestoneCount < newMilestoneCount) {
        NSLog(@"Milestone Hit!");
        self.paymentsMadeLabel.text = [NSString stringWithFormat:NUM_PAYMENTS_MADE, ++self.milestonesHit, self.goal.numPayments];
        if (self.milestonesHit == self.goal.numPayments) {
            // SUCCESS!
            NSLog(@"GOAL ACHIEVED!");
            self.makePaymentButton.enabled = NO;
            [self disableMakePaymentButton];
//            [GoalManager completeGoal:self.goal.objectId];
        }
    }
    
    self.milestoneProgressBar.currentProgress = self.totalGoalProgress;
    // TODO progress bar with chunk
#warning TODO use the progress bar perhaps or create your own.
  // Questions to answer:
  // How many payments has the user made?
    
    
}

- (IBAction)makePayment:(id)sender {
//    SimpleTransactionViewController *simpleTransVC = [[SimpleTransactionViewController alloc] initWithNibName:@"SimpleTransactionViewController" bundle:nil];
//    [simpleTransVC setLabelsAndButtons:MakePayment goal:self.goal amount:self.goal.paymentAmount];
//    [self.navigationController pushViewController:simpleTransVC animated:YES];
    CGFloat payment = arc4random_uniform(60) + .25;
    NSLog(@"payment: %f", payment);
    [self.paymentsMade addObject:@(payment)];
    self.totalGoalProgress += payment;
//    [GoalManager updateGoal:self.goal.objectId keyName:@"currentProgress" value:@(self.totalGoalProgress)];
    
    NSLog(@"%@", self.paymentsMade);
    // TODO Load Make Payment View
    UIColor *green = [[UIColor alloc] initWithRed:40.0f/255.0f green:240.0f/255.0f blue:200.0f/255.0 alpha:1.0f/1.0f];
    
    PNStackedBarChartDataItem *item = [PNStackedBarChartDataItem dataItemWithValue:payment color:green];
    [self.milestoneProgressBar updateProgressWithItem:item];
    
    [self.milestoneProgressBar removeFromSuperview];
    [self.milestoneProgressBar setNeedsDisplay];
    [self.milestoneProgressContainer addSubview:self.milestoneProgressBar];
    [self updateMilestoneProgress];
}

- (void)loadMilestoneProgress {
    for (NSNumber *payment in self.paymentsMade) {
        self.totalGoalProgress += [payment floatValue];
    }
    
    [self updateMilestoneProgress];
}

#pragma mark Helper Functions

- (void)disableMakePaymentButton {
    // Set Disabled State for Button
    [self.makePaymentButton setTitle:@"  GOAL ACHIEVED!" forState:UIControlStateDisabled];
    [self.makePaymentButton setImage:[UIImage imageNamed:@"btn_check_white_highlight"] forState:UIControlStateDisabled];
    self.makePaymentButton.enabled = NO;
    
}

- (CGRect)frameForContentController {
  CGRect contentFrame = self.view.bounds;
  CGFloat heightOffset = self.navigationController.navigationBar.bounds.size.height;
  contentFrame.origin.y += heightOffset;
  contentFrame.size.height -= heightOffset;
  return contentFrame;
}

- (void)drawProgressBar {
    float goalProgress = [[[TransactionManager instance] transactionsSet] totalPaymentsForGoalId:self.goal.objectId];
    self.progressView.total = self.goal.total;
    self.progressView.progress = goalProgress;
    [self.progressView setNeedsDisplay];
}

@end
