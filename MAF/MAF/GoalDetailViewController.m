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

#import "GoalDetailViewController.h"
#import "Utilities.h"

@interface GoalDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *previousPaymentsButton;
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;

@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTilDueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentsMadeLabel;

- (IBAction)flipTileView:(id)sender;
- (IBAction)makePayment:(id)sender;

@property (assign, nonatomic) NSInteger tileNum;

@end

@implementation GoalDetailViewController

- (void)setGoal:(Goal *)goal {
  _goal = goal;
  self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.0f", [self.goal.paymentAmountInCents floatValue]/CENTS_TO_DOLLARS_CONSTANT];
  self.paymentsMadeLabel.text = [NSString stringWithFormat:NUM_PAYMENTS_MADE, 0, self.goal.paymentInterval];
  
  NSString *timeTilString;
#warning Doesn't work TODO, get the formatting and countdown logic working
  if ([MHPrettyDate isToday:self.goal.targetDate]) {
    timeTilString = [NSString stringWithFormat:DUE_TODAY_STRING, [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
  }
  else {
    timeTilString = [NSString stringWithFormat:TIME_TIL_DUE_STRING, [Utilities daysBetweenDate:[NSDate date] andDate:self.goal.targetDate], [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
  }
  
  self.timeTilDueLabel.text = timeTilString;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.view.frame = [self frameForContentController];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
#warning TODO create progress update
  
  [self setupRoundedButton:self.makePaymentButton
          withCornerRadius:BUTTON_CORNER_RADIUS
               borderColor:[UIColor darkGrayColor]];
  
  [self setupRoundedButton:self.previousPaymentsButton
          withCornerRadius:BUTTON_CORNER_RADIUS
               borderColor:[UIColor darkGrayColor]];
  
  
//  self.timeTilDueLabel.text = [[NSString alloc] initWithFormat:@"%d", self.goal.goalDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (UIButton *)setupRoundedButton:(UIButton *)button withCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor {
  button.layer.cornerRadius = cornerRadius;
  button.layer.masksToBounds = YES;
  button.layer.borderColor = borderColor.CGColor;
  button.layer.borderWidth = 2.0f;
  
  return button;
}

- (CGRect)frameForContentController {
  CGRect contentFrame = self.view.bounds;
  CGFloat heightOffset = self.navigationController.navigationBar.bounds.size.height;
  contentFrame.origin.y += heightOffset;
  contentFrame.size.height -= heightOffset;
  
  NSLog(@"%f", heightOffset);
  return contentFrame;
}

@end
