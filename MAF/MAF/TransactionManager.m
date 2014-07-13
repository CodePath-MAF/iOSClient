//
//  TransactionManager.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import <Parse/Parse.h>
#import "Goal.h"
#import "Transaction.h"
#import "TransactionManager.h"

@implementation TransactionManager

+ (BFTask *)createTransactionForUser:(PFUser *)user goalId:(NSString *)goalId amountInCents:(NSInteger)amountInCents description:(NSString *)description type:(enum TransactionType)type {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    Transaction *transaction = [Transaction object];
    transaction.user = user;
    if (goalId != nil) {
        transaction.goal = [Goal objectWithoutDataWithObjectId:goalId];
    }
    transaction.amountInCents = amountInCents;
    transaction.description = description;
    transaction.type = type;
    [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [task setResult:transaction];
        }
    }];
    return task.task;
}

+ (BFTask *)updateTransaction:(NSString *)transactionId keyName:(NSString *)keyName value:(id)value {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [[Transaction query] getObjectInBackgroundWithId:transactionId block:^(PFObject *transaction, NSError *error) {

        if (error) {
            [task setError:error];
        } else {
            [transaction setValue:value forKeyPath:keyName];
            [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [task setError:error];
                } else {
                    [task setResult:transaction];
                }
            }];
        }
    }];
    return task.task;
}

+ (BFTask *)deleteTransaction:(NSString *)transactionId {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [[Transaction query] getObjectInBackgroundWithId:transactionId block:^(PFObject *transaction, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [transaction deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [task setError:error];
                } else {
                    [task setResult:@(succeeded)];
                }
            }];
        }
    }];
    return task.task;
}

+ (BFTask *)fetchTransactionsForUser:(PFUser *)user {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    PFQuery *query = [Transaction query];
    [query whereKey:@"user" equalTo:user];
    // TODO should be limiting these so we're returning paginated results
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [task setResult:objects];
        }
    }];
    return task.task;
}

+ (BFTask *)fetchTransactionsForUser:(PFUser *)user ofType:(enum TransactionType)type {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    PFQuery *query = [Transaction query];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"type" equalTo:@(type)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [task setResult:objects];
        }
    }];
    return task.task;
}

@end