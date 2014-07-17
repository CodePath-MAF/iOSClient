//
//  DashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>

#import "DashboardViewController.h"

#import "CreateGoalViewController.h"
#import "CreateTransactionViewController.h"
#import "GoalsTableViewController.h"
#import "TransactionsTableViewController.h"
#import "TransactionCategoryManager.h"

@interface DashboardViewController ()

@property (strong, nonatomic) NSArray *categories;
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
    self.title = @"Dashboard";
    self.currentUserEmailLabel.text = [[PFUser currentUser] username];
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
    
    self.navigationItem.leftBarButtonItem = profileButton;
    
    UIBarButtonItem *goalButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createGoal:)];
    
    self.navigationItem.rightBarButtonItem = goalButton;
}

- (IBAction)createGoal:(id)sender {
    [self.navigationController pushViewController:[[CreateGoalViewController alloc] init] animated:YES];
}

- (IBAction)createTransaction:(id)sender {
    if (!self.categories) {
        [[TransactionCategoryManager fetchCategories] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                // TODO raise an error message with TSMessages
                NSLog(@"Error fetchign categories: %@", task.error);
            } else {
                self.categories = task.result;
                [self pushCreateTransactionViewController];
            }
            return task;
        }];
    } else {
        [self pushCreateTransactionViewController];
    }
}

- (void)pushCreateTransactionViewController {
    [self.navigationController pushViewController:[[CreateTransactionViewController alloc] init] animated:YES];
}

- (IBAction)viewGoals:(id)sender {
    [self.navigationController pushViewController:[[GoalsTableViewController alloc] init] animated:YES];
}

- (IBAction)viewTransactions:(id)sender {
    [self.navigationController pushViewController:[[TransactionsTableViewController alloc] init] animated:YES];
}

- (void)showProfile:(id)sender {
#warning show profile view here
    NSLog(@"Show Profile");
}

@end
