//
//  TransactionManager.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

#import "Transaction.h"

@interface TransactionManager : NSObject

+ (void)createTransactionForUser:(NSString *)userId goalId:(NSString *)goalId amountInCents:(NSInteger)amountInCents description:(NSString *)description type:(enum TransactionType)type withBlock:(PFBooleanResultBlock)block;

+ (void)updateTransaction:(NSString *)transactionId keyName:(NSString *)keyName value:(id)value withBlock:(PFBooleanResultBlock)block;

+ (void)deleteTransaction:(NSString *)transactionId withBlock:(PFBooleanResultBlock)block;

@end
