//
//  DashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "DashboardViewController.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentUserEmailLabel;
- (IBAction)createGoal:(id)sender;
- (IBAction)createTransaction:(id)sender;
- (IBAction)viewGoals:(id)sender;
- (IBAction)viewTransactions:(id)sender;

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.parentViewController.title = @"Dashboard";
  
  self.currentUserEmailLabel.text = [[PFUser currentUser] username];
}

- (IBAction)createGoal:(id)sender {
  [self.delegate createGoal:sender];
}

- (IBAction)createTransaction:(id)sender {
  [self.delegate createTransaction:sender];
}

- (IBAction)viewGoals:(id)sender {
    // TODO should be wrapped in a navigation conroller
  [self.delegate viewGoals:sender];
}

- (IBAction)viewTransactions:(id)sender {
    // TODO should be wrapped in a navigation controller
  [self.delegate viewTransactions:sender];
}

@end
