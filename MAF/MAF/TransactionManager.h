//
//  TransactionManager.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

#import "Transaction.h"

@interface TransactionManager : NSObject

+ (BFTask *)createTransactionForUser:(NSString *)userId goalId:(NSString *)goalId amountInCents:(NSInteger)amountInCents description:(NSString *)description type:(enum TransactionType)type;

+ (BFTask *)updateTransaction:(NSString *)transactionId keyName:(NSString *)keyName value:(id)value;

+ (BFTask *)deleteTransaction:(NSString *)transactionId;

+ (BFTask *)fetchTransactionsForUserId:(NSString *)userId;

+ (BFTask *)fetchTransactionsForUserId:(NSString *)userId ofType:(enum TransactionType)type;

@end
