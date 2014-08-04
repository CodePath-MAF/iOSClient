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
#import "SimpleGoalDetailViewController.h"
#import "LendingSocialCell.h"
#import "Friend.h"
#import "Goal.h"
#import "Utilities.h"
#import "SimpleTransactionViewController.h"
#import "TransactionManager.h"
#import "PNChart.h"
#import "ProgressView.h"
#import "Transaction.h"


@interface SimpleGoalDetailViewController ()

// Payment Reminder View Outlets
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTilDueLabel;

// Make Milestone Progress View Outlets
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (weak, nonatomic) IBOutlet UIButton *goalAchievedButton;
@property (weak, nonatomic) IBOutlet UILabel *paymentsMadeLabel;
@property (weak, nonatomic) IBOutlet UIView *milestoneProgressView;

- (IBAction)makePayment:(id)sender;

@property (nonatomic, strong) NSMutableArray *lendingFriends;

@property (assign, nonatomic) NSInteger tileNum; // Not Used right now

@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@property (weak, nonatomic) IBOutlet OpenSansBoldLabel *goalTotal;
@property (weak, nonatomic) IBOutlet OpenSansRegularLabel *saveToDate;

@property (strong, nonatomic) Goal *goal;
@property (strong, nonatomic) NSDictionary *_viewData;

@end

@implementation SimpleGoalDetailViewController

- (void)updateLabels {
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.2f", self.goal.paymentAmount];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];

    self.paymentsMadeLabel.text = [[NSString stringWithFormat:NUM_PAYMENTS_MADE, self.goal.numPaymentsMade, self.goal.numPayments] uppercaseString];
    self.goalTotal.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:self.goal.amount]];
    self.saveToDate.text = [NSString stringWithFormat:@"%@ SAVED TO DATE", [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:self.goal.currentTotal]]];
    self.timeTilDueLabel.text = self._viewData[@"goalDetails"][@"nextPaymentDue"];
    
    if (self.goal.currentTotal >= self.goal.amount) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.goalAchievedButton.alpha = 1;
            self.makePaymentButton.alpha = 0;
            [self.makePaymentButton removeFromSuperview];
        } completion:nil];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = [self frameForContentController];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    self.goalAchievedButton.alpha = 0;
    // Set Up Make Payment Button
    [[self.makePaymentButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:14.f]];

    [Utilities setupRoundedButton:self.makePaymentButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
    [Utilities setupRoundedButton:self.goalAchievedButton withCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateLabels];
    [self drawProgressBar];
}

- (IBAction)makePayment:(id)sender {
    SimpleTransactionViewController *simpleTransVC = [[SimpleTransactionViewController alloc] initWithNibName:@"SimpleTransactionViewController" bundle:nil];
    [simpleTransVC setLabelsAndButtons:MakePayment goal:self.goal amount:self.goal.paymentAmount];
    [self.navigationController pushViewController:simpleTransVC animated:YES];
}

#pragma mark Helper Functions

- (CGRect)frameForContentController {
  CGRect contentFrame = self.view.bounds;
  CGFloat heightOffset = self.navigationController.navigationBar.bounds.size.height;
  contentFrame.origin.y += heightOffset;
  contentFrame.size.height -= heightOffset;
  return contentFrame;
}

- (void)drawProgressBar {
    self.progressView.total = self.goal.amount;
    self.progressView.progress = self.goal.currentTotal;
    [self.progressView setNeedsDisplay];
}

- (void)setViewData:(NSDictionary *)viewData {
    self._viewData = viewData;
    self.goal = viewData[@"goal"];
}

@end
