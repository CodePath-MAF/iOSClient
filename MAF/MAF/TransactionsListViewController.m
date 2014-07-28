
//
//  TransactionsTableViewController.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import "TransactionsListViewController.h"
#import "TransactionTableViewCell.h"
#import "TransactionsSummaryHeaderView.h"
#import "TransactionManager.h"
#import "TransactionsSet.h"
#import "TransactionCategoryManager.h"
#import "MultiInputViewController.h"
#import "TransactionsHeaderView.h"
#import "EmptyTransactionsView.h"
#import "User.h"
#import "Transaction.h"

#import "Utilities.h"

#warning TODO make sure this is only showing TransactionTypeCredit

@interface TransactionsListViewController () <UITableViewDataSource, UITableViewDelegate, EmptyTransactionsViewDelegate>

@property (nonatomic, strong) TransactionTableViewCell *prototypeCell;
@property (nonatomic, strong) EmptyTransactionsView *emptyView;


@property (weak, nonatomic) IBOutlet TransactionsSummaryHeaderView *summaryView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation TransactionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Expenses";
    
    self.summaryView = [[[NSBundle mainBundle] loadNibNamed:@"TransactionsSummaryHeaderView" owner:self options:nil] lastObject];
    self.summaryView.alpha = 0.f;
    [self.view addSubview:self.summaryView];
    
    self.emptyView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyTransactionsView" owner:self options:nil] firstObject];
    self.emptyView.delegate = self;
    self.emptyView.alpha = 0.f;
    [self.view addSubview:self.emptyView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0;
    
    // Create Add Transaction Button
    UIBarButtonItem *addTransactionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_white_up"] style:UIBarButtonItemStylePlain target:self action:@selector(createTransaction:)];
    [addTransactionButton setImageInsets:UIEdgeInsetsMake(10.0f, 0, 0, 0)];
    self.navigationItem.rightBarButtonItem = addTransactionButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    
    UINib *transactionCellNib = [UINib nibWithNibName:@"TransactionTableViewCell" bundle:nil];
    [self.tableView registerNib:transactionCellNib forCellReuseIdentifier:@"TransactionCell"];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[TransactionManager instance] hasTransactionsOfType:TransactionTypeCredit]) {
        [[self fetchData] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error fetching transactions for user: %@", task.error);
            } else {
                [self routeToView];
            }
            return task;
        }];
    } else {
        self.emptyView.alpha = 0;
        [self routeToView];
    }
}

- (void)routeToView {
    [self.summaryView setTransactionsSet:[[TransactionManager instance] transactionsSet]];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (![[TransactionManager instance] hasTransactionsOfType:TransactionTypeCredit]) {
            [self.emptyView updateTotalCash];
            self.emptyView.alpha = 1;
        } else {
            [self.summaryView setNeedsDisplay];
            self.summaryView.alpha = 1;
            self.tableView.alpha = 1;
            [self.tableView reloadData];
        }
    } completion:nil];
}

- (BFTask *)fetchData {
    return [[TransactionManager instance] fetchTransactionsForUser:[User currentUser] ofType:TransactionTypeCredit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.summaryView cleanUpCharts];
}

#pragma mark - NavBar Methods

- (void)createTransaction:(id)sender {
    [self.navigationController pushViewController:[[MultiInputViewController alloc] initWithMultiInputType:Transaction_Creation] animated:YES];
}

- (void)addTransactionButtonTriggered:(id)sender {
    [self.navigationController pushViewController:[[MultiInputViewController alloc] initWithMultiInputType:Transaction_Creation] animated:YES];
}

#pragma mark - Table view data source

- (NSDate *)getDateForSection:(NSInteger)section {
    NSSortDescriptor *descendingDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *sortedKeys = [[[[[TransactionManager instance] transactionsSet] transactionsByDate] allKeys] sortedArrayUsingDescriptors:[[NSArray alloc] initWithObjects:descendingDateDescriptor, nil]];
    return sortedKeys[section];
}

- (NSArray *)getTransactionsForSection:(NSInteger)section {
    if ([[TransactionManager instance] hasTransactionsOfType:TransactionTypeCredit]) {
        NSDate *sectionDate = [self getDateForSection:section];
        NSArray *sectionTransactions = [[[[TransactionManager instance] transactionsSet] transactionsByDate] objectForKey:sectionDate] ?: [[NSArray alloc] init];
        return sectionTransactions;
    } else {
        return [[NSArray alloc] init];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[TransactionManager instance] hasTransactionsOfType:TransactionTypeCredit]) {
        return [[[[TransactionManager instance] transactionsSet] transactionsByDate] count];
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionTransactions = [self getTransactionsForSection:section];
    return [sectionTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionTransactions = [self getTransactionsForSection:indexPath.section];
    TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    cell.transaction = sectionTransactions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[TransactionManager instance] hasTransactionsOfType:TransactionTypeCredit]) {
        NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
        NSDate *sectionDate = [self getDateForSection:section];
        if ([today isEqualToDate:sectionDate]) {
            return @"Today";
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:sectionDate]];
        }
    } else {
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[TransactionManager instance] hasTransactionsOfType:TransactionTypeCredit]) {
        NSString *title;
        NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
        NSDate *sectionDate = [self getDateForSection:section];
        if ([today isEqualToDate:sectionDate]) {
            title = @"Today";
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            title = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:sectionDate]];
        }
        TransactionsHeaderView *headerView = [[TransactionsHeaderView alloc] init];
        [headerView setTitle:title];
        return headerView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger firstVisibleSection = [[[self.tableView indexPathsForVisibleRows] firstObject] section];
    [self.summaryView setActiveBar:(6 - firstVisibleSection) activeAlpha:1.0f inactiveAlpha:0.5f];
}

@end
