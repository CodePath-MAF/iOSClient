//
//  TransactionsTableViewController.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import "TransactionsTableViewController.h"
#import "TransactionTableViewCell.h"
#import "TransactionsSummaryTableViewCell.h"
#import "TransactionManager.h"
#import "TransactionsSet.h"
#import "TransactionCategoryManager.h"
#import "CreateTransactionViewController.h"
#import "User.h"

#import "Utilities.h"

#warning TODO make sure this is only showing TransactionTypeCredit

@interface TransactionsTableViewController ()

@property (nonatomic, strong) TransactionsSet *transactionsSet;
@property (nonatomic, strong) TransactionTableViewCell *prototypeCell;

- (void)reloadData;

@end

@implementation TransactionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Transactions";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Create Add Transaction Button
    UIBarButtonItem *addTransactionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createTransaction:)];
    
    self.navigationItem.rightBarButtonItem = addTransactionButton;
    

    UINib *transactionCellNib = [UINib nibWithNibName:@"TransactionTableViewCell" bundle:nil];
    [self.tableView registerNib:transactionCellNib forCellReuseIdentifier:@"TransactionCell"];
    
    UINib *transactionsSummaryCellNib = [UINib nibWithNibName:@"TransactionsSummaryTableViewCell" bundle:nil];
    [self.tableView registerNib:transactionsSummaryCellNib forCellReuseIdentifier:@"TransactionSummary"];
    
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
    return sortedKeys[section - 1];
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
        return [[self.transactionsSet transactionsByDate] count] + 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        NSArray *sectionTransactions = [self getTransactionsForSection:section];
        return [sectionTransactions count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionSummary" forIndexPath:indexPath];
        [(TransactionsSummaryTableViewCell *)cell setTransactionsSet:self.transactionsSet];
#warning TODO clean this up, we don't want it to redraw everytime, only if it updates. also, it would be better if it didn't start from 0, so like it did an incremental update
        [cell setNeedsDisplay];
    } else {
        NSArray *sectionTransactions = [self getTransactionsForSection:indexPath.section];
        cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
        [(TransactionTableViewCell *)cell setTransaction:sectionTransactions[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200.f;
    } else {
        return 80.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    } else {
        return 32.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section != 0 && self.transactionsSet) {
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
