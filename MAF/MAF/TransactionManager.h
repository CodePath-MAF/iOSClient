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
#import "User.h"

@interface TransactionManager : NSObject

+ (BFTask *)createTransactionForUser:(User *)user goalId:(NSString *)goalId amount:(float)amount detail:(NSString *)detail type:(enum TransactionType)type categoryId:(NSString *)categoryId transactionDate:(NSDate *)transactionDate;

+ (BFTask *)updateTransaction:(NSString *)transactionId keyName:(NSString *)keyName value:(id)value;

+ (BFTask *)deleteTransaction:(NSString *)transactionId;

+ (BFTask *)fetchTransactionsForUser:(User *)user;

+ (BFTask *)fetchTransactionsForUser:(User *)user ofType:(enum TransactionType)type;

@end
