//
//  GoalDetailViewController.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#define TIME_TIL_DUE_STRING @"DUE IN %d DAYS (%@)"
#define DUE_TODAY_STRING @"DUE TODAY (%@)"
#define NUM_PAYMENTS_MADE @"%d of %d Milestones Achieved"
#define BUTTON_CORNER_RADIUS 18.0f
#define CIRCLE_FRIENDS_PER_PAGE 4

#import "GoalDetailViewController.h"
#import "LendingSocialCell.h"
#import "Friend.h"
#import "Utilities.h"

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
@property (weak, nonatomic) IBOutlet UIView *milestoneProgressView;

- (IBAction)flipTileView:(id)sender; // Not Used right now
- (IBAction)makePayment:(id)sender;

@property (nonatomic, strong) NSMutableArray *lendingFriends;
@property (nonatomic, assign) NSInteger page;

@property (assign, nonatomic) NSInteger tileNum; // Not Used right now

@end

@implementation GoalDetailViewController

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.0f", [self.goal.paymentAmount floatValue]];
    self.paymentsMadeLabel.text = [NSString stringWithFormat:NUM_PAYMENTS_MADE, 0, self.goal.paymentInterval];

    NSString *timeTilString;
    #warning Doesn't work TODO, get the formatting and countdown logic working
//    if ([MHPrettyDate isToday:self.goal.targetDate]) {
//        timeTilString = [NSString stringWithFormat:DUE_TODAY_STRING, [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
//    }
//    else {
//    timeTilString = [NSString stringWithFormat:TIME_TIL_DUE_STRING, [Utilities daysBetweenDate:[NSDate date] andDate:self.goal.targetDate], [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
//    }
//
//self.timeTilDueLabel.text = timeTilString;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Init Users for Social
        _lendingFriends = [[NSMutableArray alloc] init];
        NSLog(@"Loading Lending Friends");
        for (int userCount = 0; userCount < 12; userCount++) {
            NSString *name = [[NSString alloc] initWithFormat:@"Name %d", userCount+1];
            NSString *photoName = [[NSString alloc] initWithFormat:@"profile_%d", userCount+1];
            Friend *friend = [[Friend alloc] initWithName:name andPhoto:[UIImage imageNamed:photoName]];
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
    
    UINib *cellNib = [UINib nibWithNibName:@"LendingSocialCell" bundle:nil];
    [self.lendingPhotoCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LendingSocialCell"];
    
    // Set up Pagination
    self.photoCollectionPageControl.currentPage = self.page;
    
    // Set Up Goal Progress View
    
    // Set Up Make Payment Button
#warning TODO create progress update
    [Utilities setupRoundedButton:self.makePaymentButton
                 withCornerRadius:BUTTON_CORNER_RADIUS  ];
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
    cell.friend = self.lendingFriends[indexPath.row];
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

- (void) updateMilestoneProgress {
#warning TODO use the progress bar perhaps or create your own.
  // Questions to answer:
  // How many paymenst has the user made?
}

- (IBAction)makePayment:(id)sender {
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

@end
