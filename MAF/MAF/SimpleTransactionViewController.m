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

@interface SimpleTransactionViewController ()
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
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
        self.amountLabel.text = [NSString stringWithFormat:@"%.02f", self.amountValue];
    }
    
    // Do any additional setup after loading the view from its nib.
}
                                                                                                                                                              
                                                                                                                                                              

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateTransactionTableViewCell *transCell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    [transCell updateCell:self.tableCellMainLabel subLabel:self.tableCellSubLabel];
    return transCell;
}

- (IBAction)onNext:(UIButton *)sender {
    NSDate *now = [[NSDate alloc] init];
    if (self.currentType == InitialCash) {
        [[[TransactionManager instance] createTransactionForUser:[User currentUser] goalId:nil amount:[self.amountLabel.text floatValue] detail:@"Initial Cash" type:TransactionTypeCredit categoryId:[[TransactionCategoryManager instance] categoryObjectIdForName:@"Income"] transactionDate:now]
         continueWithBlock:^id(BFTask *task) {
             if (task.error) {
                 NSLog(@"Error creating transaction: %@", task.error);
             } else {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             return task;
         }];

    } else {
        [[[TransactionManager instance] createTransactionForUser:[User currentUser] goalId:self.goal.objectId amount:[self.amountLabel.text floatValue] detail:@"Goal Payment" type:TransactionTypeDebit categoryId:[[TransactionCategoryManager instance] categoryObjectIdForName:@"Bills"] transactionDate:now]
         continueWithBlock:^id(BFTask *task) {
             if (task.error) {
                 NSLog(@"Error creating transaction: %@", task.error);
             } else {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             return task;
         }];
    }
}
@end
