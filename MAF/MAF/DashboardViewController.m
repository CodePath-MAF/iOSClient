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

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentUserEmailLabel;
- (IBAction)createGoal:(id)sender;
- (IBAction)createTransaction:(id)sender;
- (IBAction)viewGoals:(id)sender;

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
    self.currentUserEmailLabel.text = [[PFUser currentUser] username];
}

- (IBAction)createGoal:(id)sender {
    [self presentViewController:[[CreateGoalViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)createTransaction:(id)sender {
    [self presentViewController:[[CreateTransactionViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)viewGoals:(id)sender {
    [self presentViewController:[[GoalsTableViewController alloc] initWithNibName:@"GoalsTableViewController" bundle:nil] animated:YES completion:nil];
    
}

@end
