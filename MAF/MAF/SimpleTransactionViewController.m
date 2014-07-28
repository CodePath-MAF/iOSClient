//
//  SimpleTransactionViewController.m
//  MAF
//
//  Created by Guy Morita on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "SimpleTransactionViewController.h"
#import "OpenSansLightTextField.h"
#import "CreateTransactionTableViewCell.h"
#import "User.h"
#import "TransactionManager.h"
#import "TransactionCategoryManager.h"
#import "DashboardViewController.h"
#import "MRProgress.h"

@interface SimpleTransactionViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int numRows;
@property (weak, nonatomic) IBOutlet OpenSansLightTextField *amountLabel;
@property (assign, nonatomic) float amountValue;
@property (strong, nonatomic) NSString *tableCellMainLabel;
@property (strong, nonatomic) NSString *tableCellSubLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (assign, nonatomic) enum SimpleTransactionType currentType;
@property (strong, nonatomic) Goal *goal;
- (IBAction)onNext:(UIButton *)sender;

@property (strong, nonatomic) MRProgressOverlayView *progressView;

@end

@implementation SimpleTransactionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}

- (void)setLabelsAndButtons:(enum SimpleTransactionType)type goal:(Goal *)goal amount:(float)amount {
    self.currentType = type;
    self.goal = goal;
    self.amountValue = amount;
    if (self.currentType == InitialCash) {
        self.numRows = 0;
        [self.navigationItem setHidesBackButton:YES];
        self.title = @"Current Cash";
        self.tableViewHeight.constant = 0;
    } else {
        self.numRows = 1;
        [self.navigationItem setHidesBackButton:YES];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_close_white_up"] style:UIBarButtonItemStylePlain target:self action:@selector(onCancel:)];
        
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_close_white_highlight"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = cancelButton;
        
        self.title = @"Make Payment";
        self.tableCellMainLabel = @"Amount Due";
        self.tableCellSubLabel = [NSString stringWithFormat:@"$%.02f", amount];
        self.tableViewHeight.constant = 50;
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.amountLabel.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateTransactionTableViewCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    UIColor *lightGreen = [[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f];
    self.mainView.backgroundColor = lightGreen;
    self.tableView.backgroundColor = lightGreen;
    [self.amountLabel becomeFirstResponder];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:lightGreen];
    [self.amountLabel setTintColor:[UIColor whiteColor]];
    if (self.amountValue){
        self.amountLabel.text = [NSString stringWithFormat:@"$%.02f", self.amountValue];
    } else {
        self.amountLabel.text = @"$";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"simple transaction view");
}
                                                                                                                                                              
                                                                                                                                                              

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateTransactionTableViewCell *transCell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    [transCell updateCell:self.tableCellMainLabel subLabel:self.tableCellSubLabel];
    return transCell;
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


- (IBAction)onNext:(UIButton *)sender {
    NSDate *now = [[NSDate alloc] init];
    [self.view endEditing:YES];
    [self startProgress:self.navigationController];
    float amount = [[self.amountLabel.text substringFromIndex:1] floatValue];
    if (self.currentType == InitialCash) {
        [[User currentUser] setSetup:YES];
        [[[TransactionManager instance] createTransactionForUser:[User currentUser] goalId:nil amount:amount detail:@"Initial Cash" type:TransactionTypeCredit categoryId:[[TransactionCategoryManager instance] categoryObjectIdForName:@"Income"] transactionDate:now]
         continueWithBlock:^id(BFTask *task) {
             if (task.error) {
                 NSLog(@"Error creating transaction: %@", task.error);
             } else {
                 [self finishProgress:self.navigationController setViewControllers:@[[[DashboardViewController alloc] init]]];
             }
             return task;
         }];

    } else {
        [[[TransactionManager instance] createTransactionForUser:[User currentUser] goalId:self.goal.objectId amount:amount detail:[NSString stringWithFormat:@"Goal Payment for %@", self.goal.name] type:TransactionTypeCredit categoryId:[[TransactionCategoryManager instance] categoryObjectIdForName:@"Bills"] transactionDate:now countAgainstTotalCash:YES]
         continueWithBlock:^id(BFTask *task) {
             if (task.error) {
                 NSLog(@"Error creating transaction: %@", task.error);
             } else {
                 [self finishProgress:self.navigationController];
             }
             return task;
         }];
    }
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
