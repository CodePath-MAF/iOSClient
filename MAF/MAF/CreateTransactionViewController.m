//
//  CreateTransactionViewController.m
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

static NSInteger const kCategoryPicker = 1;
static NSInteger const kDatePicker = 2;

#import "CreateTransactionViewController.h"
#import "CreateTransactionTableViewCell.h"
#import "Transaction.h"
#import "TransactionCategory.h"
#import "TransactionManager.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Utilities.h"

@interface CreateTransactionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *transactionProgress;
@property (weak, nonatomic) IBOutlet UIView *formContainer;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@property (nonatomic, assign) BOOL spent;
@property (weak, nonatomic) IBOutlet UIButton *spentButton;
@property (weak, nonatomic) IBOutlet UIButton *gainedButton;
- (IBAction)onSpent:(id)sender;
- (IBAction)onGained:(id)sender;

- (IBAction)amountNext:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
- (IBAction)nameNext:(id)sender;
- (IBAction)nameBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
- (IBAction)categoryNext:(id)sender;
- (IBAction)categoryBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *dateView;

- (IBAction)dateNext:(id)sender;
- (IBAction)dateBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *finishedView;
- (IBAction)finished:(id)sender;
- (IBAction)finishedBack:(id)sender;
@property (assign, nonatomic) int currentViewIndex;
@property (assign, nonatomic) int previousViewIndex;
@property (strong, nonatomic) NSArray *allSteps;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transactionProgressHeight;

@property (strong, nonatomic) UIPickerView *categoryPicker;
@property (strong, nonatomic) NSMutableArray *sectionName;
@property (strong, nonatomic) NSMutableArray *sectionNamesWithId;
@property (nonatomic, assign) int selectedCategory;

@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) NSMutableArray *dateStringValues;
@property (strong, nonatomic) NSArray *dateObjectValues;
@property (nonatomic, assign) int selectedDate;

@property (strong, nonatomic) Transaction *transactionInProgress;


@end

@interface CreateTransactionViewController() <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

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
    NSDate *currentDay =[Utilities dateWithoutTime:[NSDate new]];
    self.dateObjectValues = [Utilities getPreviousDates:7 fromDate:currentDay];
    self.dateStringValues = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    for (int i = 0; i < self.dateObjectValues.count; i++) {
        NSString *dayOfWeek;
        if (i == 0) {
            dayOfWeek = @"Today";
        } else if (i == 1) {
            dayOfWeek = @"Yesterday";
        } else {
            dayOfWeek = [dateFormatter stringFromDate:[self.dateObjectValues objectAtIndex:i]];
        }
        [self.dateStringValues addObject:dayOfWeek];
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
    [self.transactionProgress setSeparatorInset:UIEdgeInsetsZero];
    [self.transactionProgress setSeparatorColor:lightGreen];
    self.transactionProgress.backgroundColor = lightGreen;
    self.formContainer.backgroundColor = lightGreen;
    self.amountView.backgroundColor = lightGreen;
    self.nameView.backgroundColor = lightGreen;
    self.categoryView.backgroundColor = lightGreen;
    self.dateView.backgroundColor = lightGreen;
    self.finishedView.backgroundColor = lightGreen;
    self.allSteps = @[self.amountView, self.nameView, self.categoryView, self.dateView, self.finishedView];
    
    self.currentViewIndex = 0;
    self.previousViewIndex = 0;

    self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.categoryPicker.tag = kCategoryPicker;
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource=self;
    self.categoryPicker.backgroundColor = lightGreen;
    
    self.datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.datePicker.showsSelectionIndicator = NO;
    self.datePicker.tag = kDatePicker;
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    self.datePicker.backgroundColor = lightGreen;
    
    [self.spentButton setEnabled:NO];
    self.spent = YES;
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateTransactionTableViewCell *transCell = [tableView dequeueReusableCellWithIdentifier:@"CreateTransactionCell" forIndexPath:indexPath];
    NSArray *labels = [self getContent:indexPath.row];
    [transCell updateCell:labels[0] subLabel:labels[1]];
    return transCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self changeProgress:indexPath.row];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (void)changeProgress:(int)index {
    [self saveState];
    [self.allSteps[self.currentViewIndex] removeFromSuperview];

    if (self.previousViewIndex != self.currentViewIndex){
        self.previousViewIndex = self.currentViewIndex;
    }
    if (!index){
        index = 0;
    }
    self.currentViewIndex = index;
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transactionProgressHeight.constant = 50.0 * self.currentViewIndex;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    if (self.currentViewIndex > self.previousViewIndex) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.previousViewIndex inSection:0];
        [self.transactionProgress insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if (self.previousViewIndex > 0) {
            [self.transactionProgress beginUpdates];
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            for (int i = self.previousViewIndex; i > self.currentViewIndex; i--) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i-1 inSection:0];
                [paths addObject:path];
            }
            [self.transactionProgress deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [self.transactionProgress endUpdates];
        }
    }

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
        self.transactionInProgress.transactionDate = self.dateObjectValues[self.selectedDate];
    }
}

- (void)handleView {
    if (self.currentViewIndex == 0) {
        [self.amountText becomeFirstResponder];
    } else if (self.currentViewIndex == 1) {
        [self.nameText becomeFirstResponder];
    } else if (self.currentViewIndex == 2) {
        [self.categoryView addSubview:self.categoryPicker];
//        [self.categoryPicker update];
    } else if (self.currentViewIndex == 3) {
        [self.dateView addSubview:self.datePicker];
//        [self.datePicker update];
    }
}


- (NSArray *)getContent:(int)index {
    NSString *mainLabel;
    NSString *subLabel;
    if (index == 0) {
        mainLabel = @"Amount";
        subLabel = [NSString stringWithFormat:@"%.02f", self.transactionInProgress.amount];
    } else if (index == 1) {
        mainLabel = @"Name";
        subLabel = self.transactionInProgress.name;
    } else if (index == 2) {
        mainLabel = @"Category";
        subLabel = self.sectionName[self.selectedCategory];
    } else if (index == 3) {
        mainLabel = @"Date";
        subLabel = self.dateStringValues[self.selectedDate];
    }
    return @[mainLabel, subLabel];
}

- (void)toggleSpent {
    if (self.spent) {
        self.spent = NO;
    } else {
        self.spent = YES;
    }
}

- (IBAction)onSpent:(id)sender {
    if (!self.spent){
        [self toggleSpent];
        [self.spentButton setEnabled:NO];
        [self.gainedButton setEnabled:YES];
    }
}

- (IBAction)onGained:(id)sender {
    if (self.spent) {
        [self toggleSpent];
        [self.spentButton setEnabled:YES];
        [self.gainedButton setEnabled:NO];
    }
}

# pragma mark Actions

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
    enum TransactionType type = TransactionTypeDebit;
    if (!self.spent){
        type = TransactionTypeCredit;
    }

    [[[TransactionManager instance] createTransactionForUser:[User currentUser] goalId:nil amount:self.transactionInProgress.amount detail:self.transactionInProgress.name type:type categoryId:category.objectId transactionDate:self.transactionInProgress.transactionDate]
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

#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == kCategoryPicker) {
        self.selectedCategory = row;
    } else {
        self.selectedDate = row;
    }

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == kCategoryPicker) {
        return [self.sectionName count];
    } else {
        return [self.dateStringValues count];
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60.f)];
        [tView setFont:[UIFont fontWithName:@"OpenSans-Light" size:25.f]];
        [tView setTextColor:[UIColor whiteColor]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    [[pickerView.subviews objectAtIndex:1] setHidden:YES];
    [[pickerView.subviews objectAtIndex:2] setHidden:YES];
    if (pickerView.tag == kCategoryPicker) {
        tView.text = [self.sectionName objectAtIndex:row];
    } else {
        tView.text = [self.dateStringValues objectAtIndex:row];
    }
    return tView;
}

@end
