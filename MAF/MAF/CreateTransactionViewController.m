//
//  CreateTransactionViewController.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "XLForm.h"

#import "CreateTransactionForm.h"
#import "CreateTransactionViewController.h"
#import "DashboardViewController.h"
#import "MAFActionFormButtonCell.h"
#import "Transaction.h"
#import "TransactionManager.h"
#import "MAFActionFormButtonDelegate.h"

@interface CreateTransactionViewController() <MAFActionFormButtonDelegate>

@end

@implementation CreateTransactionViewController

- (id)init {
    self = [super init];
    if (self){
        self.form = [CreateTransactionForm formDescriptorWithTitle:@"Create Transaction"];
    }
    return self;
}
- (void)didSelectButton {
    
    NSArray *validationErrors = self.formValidationErrors;
    if (validationErrors.count > 0) {
        NSLog(@"Error saving form: %@", validationErrors);
    } else {
        NSDictionary *formValues = self.formValues;
        NSLog(@"Saving form: %@", formValues);
        // TODO need to figure out what the updated fields for the goal are
        [self.parentViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

//- (void)submitCreateTransactionForm:(UITableViewCell<FXFormFieldCell> *)cell {
//    CreateTransactionForm *form = cell.field.form;
//    [[TransactionManager createTransactionForUser:[PFUser currentUser] goalId:nil amountInCents:form.amountInCents description:form.description type:form.transactionType] continueWithBlock:^id(BFTask *task) {
//        if (task.error) {
//            NSLog(@"Error creating transaction: %@", task.error);
//        } else {
//            NSLog(@"Successfully created transaction: %@", task.result);
//            [self presentViewController:[[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil] animated:YES completion:nil];
//        }
//        return task;
//    }];
//}

@end
