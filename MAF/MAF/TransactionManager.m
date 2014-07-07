//
//  TransactionManager.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "Goal.h"
#import "Transaction.h"
#import "TransactionManager.h"

@implementation TransactionManager

+ (void)createTransactionForUser:(NSString *)userId goalId:(NSString *)goalId amountInCents:(NSInteger)amountInCents description:(NSString *)description type:(enum TransactionType)type withBlock:(PFBooleanResultBlock)block {
    
    Transaction *transaction = [Transaction object];
    transaction.user = [PFUser objectWithoutDataWithObjectId:userId];
    transaction.goal = [Goal objectWithoutDataWithObjectId:goalId];
    transaction.amountInCents = amountInCents;
    transaction.description = description;
    transaction.type = type;
    [transaction saveInBackgroundWithBlock:block];
    
}

+ (void)updateTransaction:(NSString *)transactionId keyName:(NSString *)keyName value:(id)value withBlock:(PFBooleanResultBlock)block {
    
    [[Transaction query] getObjectInBackgroundWithId:transactionId block:^(PFObject *transaction, NSError *error) {

        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            [transaction setValue:value forKeyPath:keyName];
            [transaction saveInBackgroundWithBlock:block];
        }
    }];
    
}

+ (void)deleteTransaction:(NSString *)transactionId withBlock:(PFBooleanResultBlock)block {
    [[Transaction query] getObjectInBackgroundWithId:transactionId block:^(PFObject *transaction, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            [transaction deleteInBackgroundWithBlock:block];
        }
    }];
}

@end
