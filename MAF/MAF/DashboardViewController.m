//
//  DashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "CreateGoalViewController.h"
#import "CreateTransactionViewController.h"
#import "DashboardViewController.h"
#import "GoalsTableViewController.h"
#import "TransactionsTableViewController.h"

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
  self.parentViewController.title = [[PFUser currentUser] username];
  
//    self.currentUserEmailLabel.text = [[PFUser currentUser] username];
}

- (IBAction)createGoal:(id)sender {
    [self.parentViewController.navigationController pushViewController:[[CreateGoalViewController alloc] init] animated:YES];
}

- (IBAction)createTransaction:(id)sender {
    [self.parentViewController.navigationController pushViewController:[[CreateTransactionViewController alloc] init] animated:YES];
}

- (IBAction)viewGoals:(id)sender {
    // TODO should be wrapped in a navigation conroller
    [self.parentViewController.navigationController pushViewController:[[GoalsTableViewController alloc] initWithNibName:@"GoalsTableViewController" bundle:nil] animated:YES];
    
}

- (IBAction)viewTransactions:(id)sender {
    // TODO should be wrapped in a navigation controller
    [self.parentViewController.navigationController pushViewController:[[TransactionsTableViewController alloc] initWithNibName:@"TransactionsTableViewController" bundle:nil] animated:YES];
}

@end
