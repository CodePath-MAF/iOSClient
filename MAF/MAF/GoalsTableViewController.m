//
//  GoalsTableViewController.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import "GoalsTableViewController.h"
#import "GoalTableViewCell.h"
#import "GoalManager.h"

@interface GoalsTableViewController () {
    NSArray *goals;
}

@end

@implementation GoalsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Goals";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *goalCellNib = [UINib nibWithNibName:@"GoalTableViewCell" bundle:nil];
    [self.tableView registerNib:goalCellNib forCellReuseIdentifier:@"GoalCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self fetchData] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error fetching goals for user: %@", task.error);
        } else {
            goals = task.result;
            [self.tableView reloadData];
        }
        return task;
    }];
}

- (BFTask *)fetchData {
    return [GoalManager fetchGoalsForUser:[PFUser currentUser]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [goals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoalCell" forIndexPath:indexPath];
    cell.goal = goals[indexPath.row];
    return cell;
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
