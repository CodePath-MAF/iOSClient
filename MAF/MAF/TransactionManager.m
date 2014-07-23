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
#import "TransactionCategory.h"
#import "TransactionManager.h"
#import "User.h"

@implementation TransactionManager

- (id)init {
    self = [super init];
    if (self) {
        _transactionsSet = [[TransactionsSet alloc] init];
    }
    return self;
}

- (BOOL)hasTransactions {
    return (BOOL)self.transactionsSet.transactions.count;
}

- (BFTask *)createTransactionForUser:(User *)user goalId:(NSString *)goalId amount:(float)amount detail:(NSString *)detail type:(enum TransactionType)type categoryId:(NSString *)categoryId transactionDate:(NSDate *)transactionDate {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    Transaction *transaction = [Transaction object];
    transaction.user = user;
    if (goalId != nil) {
        transaction.goal = [Goal objectWithoutDataWithObjectId:goalId];
    }
    transaction.amount = amount;
    transaction.detail = detail;
    transaction.type = type;
    if (categoryId != nil) {
        transaction.category = [TransactionCategory objectWithoutDataWithObjectId:categoryId];
    }
    transaction.transactionDate = transactionDate;
    
    if (type == TransactionTypeDebit) {
        user.totalCash -= amount;
    } else {
        user.totalCash += amount;
    }

    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [task setError:error];
                } else {
                    [transaction.category fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        [self.transactionsSet addTransactionToSet:transaction];
                        [task setResult:transaction];
                    }];
                }
            }];
        }
    }];
    return task.task;
}

- (BFTask *)updateTransaction:(NSString *)transactionId keyName:(NSString *)keyName value:(id)value {
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

- (BFTask *)deleteTransaction:(NSString *)transactionId {
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

- (BFTask *)fetchTransactionsForUser:(User *)user {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    if (self.transactionsSet.transactions.count) {
        [task setResult:self.transactionsSet.transactions];
    } else {
        PFQuery *query = [Transaction query];
        [query whereKey:@"user" equalTo:user];
        [query includeKey:@"category"];
        [query orderByDescending:@"transactionDate"];
        // TODO should be limiting these so we're returning paginated results
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                [task setError:error];
            } else {
                [self setTransactionsSet:[[TransactionsSet alloc] initWithTransactions:objects]];
                [task setResult:objects];
            }
        }];
    }
    return task.task;
}

- (BFTask *)fetchTransactionsForUser:(User *)user ofType:(enum TransactionType)type {
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

- (void)clearCache {
    [self.transactionsSet clearCache];
}

+ (TransactionManager *)instance {
    static TransactionManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[TransactionManager alloc] init];
    });
    return instance;
}

@end
