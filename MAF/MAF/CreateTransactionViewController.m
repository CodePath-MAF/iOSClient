//
//  CreateTransactionViewController.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CreateTransactionViewController.h"
#import "CreateTransactionForm.h"
#import "DashboardViewController.h"
#import "TransactionManager.h"

@interface CreateTransactionViewController ()

@end

@implementation CreateTransactionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.formController.form = [[CreateTransactionForm alloc] init];
    }
    return self;
}

- (void)submitCreateTransactionForm:(UITableViewCell<FXFormFieldCell> *)cell {
    CreateTransactionForm *form = cell.field.form;
    [[TransactionManager createTransactionForUser:[PFUser currentUser] goalId:nil amountInCents:form.amountInCents description:form.description type:form.transactionType] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error creating transaction: %@", task.error);
        } else {
            NSLog(@"Successfully created transaction: %@", task.result);
            [self.parentViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        return task;
    }];
}

@end
