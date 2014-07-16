//
//  GoalDetailViewController.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#define TIME_TIL_DUE_STRING @"DUE IN %d DAYS (%@)"
#define DUE_TODAY_STRING @"DUE TODAY (%@)"

#import "GoalDetailViewController.h"

@interface GoalDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *previousPaymentsButton;
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;

@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTilDueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentsMadeLabel;

- (IBAction)previousPaymentsHit:(id)sender;
- (IBAction)makePayment:(id)sender;

@end

@implementation GoalDetailViewController

- (void)setGoal:(Goal *)goal {
  _goal = goal;
  // TODO do some other stuff perhaps
}

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
  // Do any additional setup after loading the view from its nib.
  
  [self setupRoundedButton:self.makePaymentButton
          withCornerRadius:40.0f
               borderColor:nil];
  
  [self setupRoundedButton:self.previousPaymentsButton
          withCornerRadius:40.0f
               borderColor:nil];
  
  self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"%d", self.goal.paymentAmount];
//  self.timeTilDueLabel.text = [[NSString alloc] initWithFormat:@"%d", self.goal.goalDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previousPaymentsHit:(id)sender {
  NSLog(@"Load Previous Payments");
}

- (IBAction)makePayment:(id)sender {
  NSLog(@"Make a Payment");
}


#pragma mark Helper Functions

- (UIButton *)setupRoundedButton:(UIButton *)button withCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor {
  button.layer.cornerRadius = cornerRadius;
  button.layer.masksToBounds = YES;
  
#warning TODO add border and apply color
  
  return button;
}

@end
