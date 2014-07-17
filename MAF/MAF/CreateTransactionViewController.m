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
#import "TransactionCategoryManager.h"
#import "MAFActionFormButtonDelegate.h"

@interface CreateTransactionViewController() <MAFActionFormButtonDelegate>

@property (strong, nonatomic) NSArray *categories;

@end

@implementation CreateTransactionViewController

- (id)initWithCategories:(NSArray *)categories {
    self = [super init];
    if (self) {
        self.form = [CreateTransactionForm formDescriptorWithTitle:@"Create Transaction" categories:categories];
    }
    return self;
}

- (void)didSelectButton {
    
    NSArray *validationErrors = self.formValidationErrors;
    if (validationErrors.count > 0) {
        NSLog(@"Error saving form: %@", validationErrors);
    } else {
        NSNumber *amount = self.formValues[kTransactionAmount];
        XLFormOptionsObject *type = self.formValues[kTransactionType];
        XLFormOptionsObject *category = self.formValues[kTransactionCategory];
        [[TransactionManager createTransactionForUser:[PFUser currentUser] goalId:nil amount:[amount floatValue] detail:self.formValues[kTransactionDetail] type:(NSInteger)type.formValue categoryId:category.formValue transactionDate:self.formValues[kTransactionDate]] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error creating transaction: %@", task.error);
            } else {
                NSLog(@"Successfully saved transaction: %@", task.result);
                [self.navigationController popViewControllerAnimated:YES];
            }
            return task;
        }];

    }
}

@end
