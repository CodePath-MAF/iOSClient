
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
#import "CreateTransactionViewController.h"
#import "TransactionsHeaderView.h"
#import "User.h"

#import "Utilities.h"

#warning TODO make sure this is only showing TransactionTypeCredit

@interface TransactionsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TransactionsSet *transactionsSet;
@property (nonatomic, strong) TransactionTableViewCell *prototypeCell;


@property (weak, nonatomic) IBOutlet TransactionsSummaryHeaderView *summaryView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)reloadData;

@end

@implementation TransactionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Transactions";
    
    self.summaryView = [[[NSBundle mainBundle] loadNibNamed:@"TransactionsSummaryHeaderView" owner:self options:nil] lastObject];
    [self.view addSubview:self.summaryView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    [[self fetchData] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error fetching transactions for user: %@", task.error);
        } else {
            self.transactionsSet = [[TransactionsSet alloc] initWithTransactions:task.result];
            [self reloadData];
        }
        return task;
    }];
}

- (void)reloadData {
    [(TransactionsSummaryHeaderView *)self.summaryView setTransactionsSet:self.transactionsSet];
    [self.summaryView setNeedsDisplay];
    [self.tableView reloadData];
}

- (BFTask *)fetchData {
    return [TransactionManager fetchTransactionsForUser:[User currentUser]];
}

#pragma mark - NavBar Methods

- (void)createTransaction:(id)sender {
    [self.navigationController pushViewController:[[CreateTransactionViewController alloc] initWithCategories:[[TransactionCategoryManager instance] categories]] animated:YES];
}

#pragma mark - Table view data source

- (NSDate *)getDateForSection:(NSInteger)section {
    NSSortDescriptor *descendingDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *sortedKeys = [[[self.transactionsSet transactionsByDate] allKeys] sortedArrayUsingDescriptors:[[NSArray alloc] initWithObjects:descendingDateDescriptor, nil]];
    return sortedKeys[section];
}

- (NSArray *)getTransactionsForSection:(NSInteger)section {
    if (self.transactionsSet) {
        NSDate *sectionDate = [self getDateForSection:section];
        NSArray *sectionTransactions = [[self.transactionsSet transactionsByDate] objectForKey:sectionDate] ?: [[NSArray alloc] init];
        return sectionTransactions;
    } else {
        return [[NSArray alloc] init];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.transactionsSet) {
        return [[self.transactionsSet transactionsByDate] count];
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
    if (self.transactionsSet) {
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
    if (self.transactionsSet) {
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
