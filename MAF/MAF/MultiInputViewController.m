//
//  CreateTransactionViewController.m
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

static NSInteger const kCategoryPicker = 1;
static NSInteger const kDayPicker = 2;
static NSInteger const kIntervalPicker = 3;

#import "UILabel+WhiteUIDatePickerLabels.h"

#import "MultiInputViewController.h"
#import "CreateTransactionTableViewCell.h"
#import "Transaction.h"
#import "TransactionCategory.h"
#import "TransactionManager.h"
#import "TransactionCategoryManager.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Utilities.h"
#import "GoalManager.h"
#import "MRProgress.h"

@interface MultiInputViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *transactionProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transactionProgressHeight;
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

@property (strong, nonatomic) IBOutlet UIView *dayView;
- (IBAction)dayBack:(id)sender;
- (IBAction)dayNext:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *dateView;
- (IBAction)dateNext:(id)sender;
- (IBAction)dateBack:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *intervalView;
- (IBAction)intervalNext:(id)sender;
- (IBAction)intervalBack:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *finishedView;
- (IBAction)finished:(id)sender;
- (IBAction)finishedBack:(id)sender;

@property (strong, nonatomic) NSArray *allSteps;
@property (assign, nonatomic) int currentViewIndex;
@property (assign, nonatomic) int previousViewIndex;

@property (strong, nonatomic) UIPickerView *categoryPicker;
@property (strong, nonatomic) NSMutableArray *sectionName;
@property (strong, nonatomic) NSMutableArray *sectionNamesWithId;
@property (nonatomic, assign) int selectedCategory;

@property (strong, nonatomic) UIPickerView *dayPicker;
@property (strong, nonatomic) NSMutableArray *dateStringValues;
@property (strong, nonatomic) NSArray *dateObjectValues;
@property (nonatomic, assign) int selectedDate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) UIPickerView *intervalPicker;
@property (strong, nonatomic) NSArray *intervalNames;
@property (strong, nonatomic) NSArray *intervalEnumNames;
@property (assign, nonatomic) int selectedInterval;

@property (strong, nonatomic) Transaction *transactionInProgress;
@property (strong, nonatomic) Goal *goalInProgress;

@property (assign, nonatomic) enum MultiInputType formType;

@property (nonatomic, strong) MRProgressOverlayView *progressView;

@end

@interface MultiInputViewController() <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation MultiInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MultiInputViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (id)initWithMultiInputType:(enum MultiInputType)multiInputType {
    self = [super initWithNibName:@"MultiInputViewController" bundle:nil];
    if (self) {
        self.formType = multiInputType;
        if (self.formType == Transaction_Creation){
            self.sectionName = [[NSMutableArray alloc] init];
            NSArray *categories = [[TransactionCategoryManager instance] categories];
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
        } else {
            self.intervalNames = @[@"Daily", @"Weekly", @"Bi-Weekly", @"Monthly", @"Bi-Monthly"];
            self.intervalEnumNames = @[@(GoalPaymentIntervalDaily), @(GoalPaymentIntervalWeekly), @(GoalPaymentIntervalBiWeekly), @(GoalPaymentIntervalMonthly), @(GoalPaymentIntervalBiMonthly)];
            self.selectedInterval = 3;
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.transactionInProgress = [Transaction object];
    self.goalInProgress = [Goal object];
    self.transactionProgress.delegate = self;
    self.transactionProgress.dataSource = self;
    self.nameText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.amountText.delegate = self;
    self.amountText.text = @"$";
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
    self.dayView.backgroundColor = lightGreen;
    self.dateView.backgroundColor = lightGreen;
    self.intervalView.backgroundColor = lightGreen;
    self.finishedView.backgroundColor = lightGreen;
    
    [self.amountText setTintColor:[UIColor whiteColor]];
    [self.nameText setTintColor:[UIColor whiteColor]];
    
    if (self.formType == Transaction_Creation) {
        self.allSteps = @[self.amountView, self.nameView, self.categoryView, self.dayView, self.finishedView];
        
        self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.categoryPicker.showsSelectionIndicator = NO;
        self.categoryPicker.tag = kCategoryPicker;
        self.categoryPicker.delegate = self;
        self.categoryPicker.dataSource=self;
        self.categoryPicker.backgroundColor = lightGreen;
        
        self.dayPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.dayPicker.showsSelectionIndicator = NO;
        self.dayPicker.tag = kDayPicker;
        self.dayPicker.delegate = self;
        self.dayPicker.dataSource = self;
        self.dayPicker.backgroundColor = lightGreen;
        
        [self.spentButton setEnabled:NO];
        self.spent = YES;
    } else {
        self.allSteps = @[self.amountView, self.nameView, self.dateView, self.intervalView, self.finishedView];
        [self.spentButton removeFromSuperview];
        [self.gainedButton removeFromSuperview];
        
        self.datePicker.backgroundColor = lightGreen;
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        self.datePicker.minimumDate = newDate;
        [[[self.datePicker.subviews objectAtIndex:0] subviews][1] setHidden:YES];
        [[[self.datePicker.subviews objectAtIndex:0] subviews][2] setHidden:YES];
        
        self.intervalPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.intervalPicker.showsSelectionIndicator = NO;
        self.intervalPicker.tag = 3;
        self.intervalPicker.delegate = self;
        self.intervalPicker.dataSource = self;
        self.intervalPicker.backgroundColor = lightGreen;
    }

    self.currentViewIndex = 0;
    self.previousViewIndex = 0;
    
    [self changeProgress:self.currentViewIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == 0){
        return NO;
    } else {
        NSString *noPeriods = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        int difference = [textField.text length] - [noPeriods length];
        if (difference == 1 && [string isEqualToString:@"."]) {
            return NO;
        } else {
            NSArray *stringArray = [textField.text componentsSeparatedByString:@"."];
            if ([stringArray count] > 1 && [stringArray[1] length] == 2 && [string length]){
                return NO;
            } else {
                if (range.location == 1 && [string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    return YES;
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
    [self.transactionProgress beginUpdates];
    if (self.currentViewIndex > self.previousViewIndex) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.previousViewIndex inSection:0];
        [self.transactionProgress insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if (self.previousViewIndex > 0) {
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            for (int i = self.previousViewIndex; i > self.currentViewIndex; i--) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i-1 inSection:0];
                [paths addObject:path];
            }
            [self.transactionProgress deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self.transactionProgress endUpdates];

    [self.formContainer addSubview:self.allSteps[self.currentViewIndex]];
    [self handleView];
}

- (void)saveState {
    if (self.formType == Transaction_Creation) {
        if (self.currentViewIndex == 0) {
            self.transactionInProgress.amount = [[self.amountText.text  substringFromIndex:1] floatValue];
        } else if (self.currentViewIndex == 1) {
            self.transactionInProgress.name = self.nameText.text;
        } else if (self.currentViewIndex == 2) {
        } else if (self.currentViewIndex == 3) {
            self.transactionInProgress.transactionDate = self.dateObjectValues[self.selectedDate];
        }
    } else {
        if (self.currentViewIndex == 0) {
            self.goalInProgress.amount = [[self.amountText.text  substringFromIndex:1] floatValue];
        } else if (self.currentViewIndex == 1) {
            self.goalInProgress.name = self.nameText.text;
        } else if (self.currentViewIndex == 2) {
            self.goalInProgress.goalDate = self.datePicker.date;
        } else if (self.currentViewIndex == 3) {
            self.goalInProgress.paymentInterval = [self.intervalEnumNames[self.selectedInterval] integerValue];
        }
    }
}

- (void)handleView {
    if (self.formType == Transaction_Creation) {
        if (self.currentViewIndex == 0) {
            self.title = @"Amount";
            [self.amountText becomeFirstResponder];
        } else if (self.currentViewIndex == 1) {
            self.title = @"Name";
            [self.nameText becomeFirstResponder];
        } else if (self.currentViewIndex == 2) {
            self.title = @"Category";
            [self.categoryView addSubview:self.categoryPicker];
            if (self.spent == NO){
                [self.categoryPicker selectRow:2 inComponent:0 animated:YES];
            }
        } else if (self.currentViewIndex == 3) {
            self.title = @"Date";
            [self.dayView addSubview:self.dayPicker];
        } else {
            self.title = @"Add Transaction";
        }
    } else {
        if (self.currentViewIndex == 0) {
            self.title = @"Goal Amount";
            [self.amountText becomeFirstResponder];
        } else if (self.currentViewIndex == 1) {
            self.title = @"Name";
            [self.nameText becomeFirstResponder];
        } else if (self.currentViewIndex == 2) {
            self.title = @"Due Date";
        } else if (self.currentViewIndex == 3) {
            self.title = @"Payment Interval";
            [self.intervalView addSubview:self.intervalPicker];
            [self.intervalPicker selectRow:self.selectedInterval inComponent:0 animated:YES];
        } else if (self.currentViewIndex == 4) {
            self.title = @"Add New Goal";

        }
    }
}


- (NSArray *)getContent:(int)index {
    NSString *mainLabel;
    NSString *subLabel;
    if (self.formType == Transaction_Creation){
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

    } else {
        if (index == 0) {
            mainLabel = @"Amount";
            subLabel = [NSString stringWithFormat:@"%.02f", self.goalInProgress.amount];
        } else if (index == 1) {
            mainLabel = @"Name";
            subLabel = self.goalInProgress.name;
        } else if (index == 2) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            mainLabel = @"Date";
            subLabel = [dateFormatter stringFromDate:self.datePicker.date];
        } else if (index == 3) {
            mainLabel = @"Payment Interval";
            subLabel = self.intervalNames[self.selectedInterval];
        }
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
- (IBAction)dayNext:(id) sender {
    [self changeProgress:4];
}
- (IBAction)dayBack:(id)sender {
    [self changeProgress:2];
}
- (IBAction)dateNext:(id)sender {
    [self changeProgress:3];
}
- (IBAction)dateBack:(id)sender {
    [self changeProgress:1];
}
- (IBAction)intervalNext:(id)sender {
    [self changeProgress:4];
}

- (IBAction)intervalBack:(id)sender {
    [self changeProgress:2];
}
- (IBAction)finished:(id)sender {
    
    if (self.formType == Transaction_Creation){
        TransactionCategory *category = self.sectionNamesWithId[self.selectedCategory];
        enum TransactionType type = TransactionTypeDebit;
        if (!self.spent){
            type = TransactionTypeCredit;
        }

        [self startProgress:self.navigationController];
        [[[TransactionManager instance] createTransactionForUser:[User currentUser] goalId:nil amount:self.transactionInProgress.amount  detail:self.transactionInProgress.name type:type categoryId:category.objectId transactionDate:self.transactionInProgress.transactionDate]
         continueWithBlock:^id(BFTask *task) {
             if (task.error) {
                 NSLog(@"Error creating transaction: %@", task.error);
             } else {
                 [self finishProgress:self.navigationController];
             }
             return task;
         }];
    } else {
        [self startProgress:self.navigationController];
        [[GoalManager createGoalForUser:[User currentUser] name:self.goalInProgress.name type:GoalTypeGoal amount:self.goalInProgress.amount paymentInterval:self.goalInProgress.paymentInterval goalDate:self.datePicker.date] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error creating goal: %@", task.error);
            } else {
                [self finishProgress:self.navigationController];
            }
            return task;
        }];

    }
    

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
    } else if (pickerView.tag == kDayPicker){
        self.selectedDate = row;
    } else {
        self.selectedInterval = row;
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
    } else if (pickerView.tag == kDayPicker){
        return [self.dateStringValues count];
    } else {
        return [self.intervalNames count];
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
    } else if (pickerView.tag == kDayPicker){
        tView.text = [self.dateStringValues objectAtIndex:row];
    } else {
        tView.text = [self.intervalNames objectAtIndex:row];
    }
    return tView;
}

- (void)startProgress:(UINavigationController *)navigationController {
    
    self.progressView = [MRProgressOverlayView showOverlayAddedTo:navigationController.view title:@"" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [self.progressView setTintColor:[[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f]];
}

- (void)finishProgress:(UINavigationController *)navigationController {
    
    [self.progressView setMode:MRProgressOverlayViewModeCheckmark];
    [self performBlock:^{
        [MRProgressOverlayView dismissAllOverlaysForView:navigationController.view animated:YES];
        [navigationController popViewControllerAnimated:YES];
    } afterDelay:0.5];
    
}

- (void)finishProgress:(UINavigationController *)navigationController setViewControllers:(NSArray *)viewControllers {
    
    [self.progressView setMode:MRProgressOverlayViewModeCheckmark];
    [self performBlock:^{
        [MRProgressOverlayView dismissAllOverlaysForView:navigationController.view animated:YES];
        [navigationController setViewControllers:viewControllers animated:YES];
    } afterDelay:0.5];
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
