//
//  TransactionsSet.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"

@interface TransactionsSet : NSObject

@property (nonatomic, strong) NSMutableArray *transactions;

- (id)initWithTransactions:(NSArray *)transactions;
- (NSDictionary *)transactionsTotalByDate;
- (NSDictionary *)transactionsTotalByCategoryForDate:(NSDate *)date;
- (NSDictionary *)transactionsTotalByCategoryByDate;
- (NSDictionary *)transactionsByDate;
- (float)transactionsTotalForToday;
- (float)transactionsTotalForCurrentWeek;

- (float)spentToday;
- (float)spentThisWeek;
- (float)spentThisMonth;
- (float)spentThisYear;

- (float)savedToday;
- (float)savedThisWeek;
- (float)savedThisMonth;
- (float)savedThisYear;

- (void)addTransactionToSet:(Transaction *)transaction;
- (void)addTransactionsToSet:(NSArray *)transactions;

- (NSArray *)transactionsForGoalId:(NSString *)goalId;
- (float)totalPaymentsForGoalId:(NSString *)goalId;

- (void)clearCache;

@end
