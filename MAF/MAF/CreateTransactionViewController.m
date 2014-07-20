//
//  CreateTransactionViewController.m
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CreateTransactionViewController.h"
#import "CreateTransactionTableViewCell.h"
#import "Transaction.h"
#import "TransactionCategory.h"
#import "TransactionManager.h"
#import <Parse/Parse.h>

@interface CreateTransactionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *transactionProgress;
@property (weak, nonatomic) IBOutlet UIView *formContainer;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
- (IBAction)amountNext:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
- (IBAction)nameNext:(id)sender;
- (IBAction)nameBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
- (IBAction)categoryNext:(id)sender;
- (IBAction)categoryBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)dateNext:(id)sender;
- (IBAction)dateBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *finishedView;
- (IBAction)finished:(id)sender;
- (IBAction)finishedBack:(id)sender;
@property (assign, nonatomic) int currentViewIndex;
@property (assign, nonatomic) int previousViewIndex;
@property (strong, nonatomic) NSArray *allSteps;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transactionProgressHeight;

@property (strong, nonatomic) MyPickerView *typePicker;
@property (strong, nonatomic) NSMutableArray *sectionName;
@property (strong, nonatomic) NSMutableArray *sectionNamesWithId;
@property (assign, nonatomic) int cellNumber;
@property (strong, nonatomic) Transaction *transactionInProgress;
@property (nonatomic, assign) int selectedCategory;

@end

@implementation CreateTransactionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCategories:(NSMutableArray *)categories {
    self = [super initWithNibName:@"CreateTransactionViewController" bundle:nil];
    self.sectionName = [[NSMutableArray alloc] init];
    self.sectionNamesWithId = [[NSMutableArray alloc] initWithArray:categories];
    for (TransactionCategory *category in categories) {
        [self.sectionName addObject:category.name];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.transactionInProgress = [Transaction object];
    self.transactionProgress.delegate = self;
    self.transactionProgress.dataSource = self;
    self.nameText.delegate = self;
    self.transactionProgress.rowHeight = 50;
    [self.transactionProgress registerNib:[UINib nibWithNibName:@"CreateTransactionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreateTransactionCell"];
    UIColor *lightGreen = [[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f];
    self.formContainer.backgroundColor = lightGreen;
    self.amountView.backgroundColor = lightGreen;
    self.nameView.backgroundColor = lightGreen;
    self.categoryView.backgroundColor = lightGreen;
    self.dateView.backgroundColor = lightGreen;
    self.finishedView.backgroundColor = lightGreen;
    self.allSteps = @[self.amountView, self.nameView, self.categoryView, self.dateView, self.finishedView];
    self.currentViewIndex = 0;
    self.previousViewIndex = 0;
    self.cellNumber=2;
    if (self.typePicker == nil) {
        self.typePicker = [[MyPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.typePicker.delegate = self;
        self.typePicker.dataSource=self;
        self.typePicker.backgroundColor = lightGreen;
    }
    [self changeProgress:self.currentViewIndex];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentViewIndex;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateTransactionTableViewCell *transCell = [tableView dequeueReusableCellWithIdentifier:@"CreateTransactionCell" forIndexPath:indexPath];
    NSArray *labels = [self getContent:indexPath.row];
    [transCell updateCell:labels[0] subLabel:labels[1]];
    return transCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self changeProgress:indexPath.row];
    
}

- (void)changeProgress:(int)index {
    [self saveState];
    [self.allSteps[self.currentViewIndex] removeFromSuperview];

    if (self.previousViewIndex != self.currentViewIndex){
        self.previousViewIndex = self.currentViewIndex;
    }
    self.currentViewIndex = index;
    self.transactionProgressHeight.constant = 50.0 * self.currentViewIndex;
    [self.transactionProgress reloadData];
    [self.formContainer addSubview:self.allSteps[self.currentViewIndex]];
    [self handleView];
}

- (void)saveState {
    if (self.currentViewIndex == 0) {
        self.transactionInProgress.amount = [self.amountText.text integerValue];
    } else if (self.currentViewIndex == 1) {
        self.transactionInProgress.name = self.nameText.text;
    } else if (self.currentViewIndex == 2) {
    } else if (self.currentViewIndex == 3) {
        self.transactionInProgress.transactionDate = self.datePicker.date;
    }
}

- (void)handleView {
    if (self.currentViewIndex == 0) {
        [self.amountText becomeFirstResponder];
    } else if (self.currentViewIndex == 1) {
        [self.nameText becomeFirstResponder];
    } else if (self.currentViewIndex == 2) {
        [self.categoryView addSubview:self.typePicker];
        [self.typePicker update];
    }
}

// way to save the state of each
// way to populate the table view

- (NSArray *)getContent:(int)index {
    NSString *mainLabel;
    NSString *subLabel;
    if (index == 0) {
        mainLabel = @"Amount";
        subLabel = [NSString stringWithFormat:@"%f", self.transactionInProgress.amount];
    } else if (index == 1) {
        mainLabel = @"Name";
        subLabel = self.transactionInProgress.name;
    } else if (index == 2) {
        mainLabel = @"Category";
        subLabel = self.sectionName[self.selectedCategory];
    } else if (index == 3) {
        mainLabel = @"Date";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        subLabel = [dateFormatter stringFromDate:self.transactionInProgress.transactionDate];
    }
    return @[mainLabel, subLabel];
}

- (IBAction)amountNext:(id)sender {
    [self changeProgress:1];
}
- (IBAction)nameNext:(id)sender {
    [self changeProgress:2];
}
- (IBAction)nameBack:(id)sender {
    [self changeProgress:0];
}
- (IBAction)categoryNext:(id)sender {
    [self changeProgress:3];
}
- (IBAction)categoryBack:(id)sender {
    [self changeProgress:1];
}
- (IBAction)dateNext:(id) sender {
    [self changeProgress:4];
}
- (IBAction)dateBack:(id)sender {
    [self changeProgress:2];
}
- (IBAction)finished:(id)sender {
    
    TransactionCategory *category = self.sectionNamesWithId[self.selectedCategory];
    [[TransactionManager createTransactionForUser:[PFUser currentUser] goalId:nil amount:self.transactionInProgress.amount detail:self.transactionInProgress.name type:TransactionTypeCredit categoryId:category.objectId transactionDate:self.transactionInProgress.transactionDate]
     continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error creating transaction: %@", task.error);
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        return task;
    }];
}
- (IBAction)finishedBack:(id)sender {
    [self changeProgress:3];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.currentViewIndex == 1) {
        [self nameNext:self];
    }
    return YES;
}

#pragma mark MyPickerViewDelegate

- (void)pickerView:(MyPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedCategory = row;
}


- (NSInteger)numberOfComponentsInPickerView:(MyPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger) pickerView:(MyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [self.sectionName count];
    
}

- (NSString *)pickerView:(MyPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.sectionName objectAtIndex:row];
}

@end
