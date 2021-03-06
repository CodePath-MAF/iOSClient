//
//  TransactionsSet.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionsSet.h"

#import "Transaction.h"
#import "Utilities.h"

@interface TransactionsSet() {
    NSDictionary *_totalByDate;
    NSDictionary *_transactionsByDate;
    NSDictionary *_transactionsByCategoryByDate;
    NSDictionary *_transactionsByGoal;
    NSMutableSet *_transactionIds;
}

- (float)getTotalForTransactions:(float (^)(Transaction *transaction))shouldIncludeTransaction;

- (void)clearCache;

@end

@implementation TransactionsSet

- (id)init {
    self = [super init];
    if (self) {
        _transactions = [[NSMutableArray alloc] init];
        _transactionIds = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)initWithTransactions:(NSArray *)transactions {
    self = [super init];
    if (self) {
        _transactionIds = [[NSMutableSet alloc] init];
        _transactions = [[NSMutableArray alloc] init];
        [self addTransactionsToSet:transactions];
    }
    return self;
}

- (void)clearCache {
    _totalByDate = nil;
    _transactionsByDate = nil;
    _transactionsByCategoryByDate = nil;
    _transactionsByGoal = nil;
}

- (void)destroy {
    [self clearCache];
    _transactions = [[NSMutableArray alloc] init];
    _transactionIds = [[NSMutableSet alloc] init];
}

- (void)addTransactionToSet:(Transaction *)transaction {
    if (![_transactionIds member:transaction.objectId]) {
        [self clearCache];
        [_transactionIds addObject:transaction.objectId];
        [self.transactions addObject:transaction];
    }
}

- (void)addTransactionsToSet:(NSArray *)transactions {
    for (Transaction *transaction in transactions) {
        [self addTransactionToSet:transaction];
    }
}

- (NSDictionary *)transactionsTotalByDate {
    // Calculate the totals for the transactions, grouped by date.
    if (!_totalByDate) {
        NSMutableDictionary *transactionDict = [[NSMutableDictionary alloc] init];
        for (Transaction *transaction in self.transactions) {
            NSDate *strippedDate = [Utilities dateWithoutTime:transaction.transactionDate];
            float total = [(NSNumber *)[transactionDict objectForKey:strippedDate] ?: [[NSNumber alloc] initWithFloat:0.0] floatValue];
            float newTotal = total + transaction.amount;
            [transactionDict setObject:@(newTotal) forKey:strippedDate];
        }
        _totalByDate = transactionDict;
    }
    return _totalByDate;
}

- (NSDictionary *)transactionsByGoal {
    if (!_transactionsByGoal) {
        NSMutableDictionary *transactionsByGoalDict = [[NSMutableDictionary alloc] init];
        for (Transaction *transaction in self.transactions) {
            NSMutableArray *transactionsByGoal = [transactionsByGoalDict objectForKey:[transaction.goal objectId]] ?: [[NSMutableArray alloc] init];
            [transactionsByGoal addObject:transaction];
            [transactionsByGoalDict setObject:transactionsByGoal forKey:[transaction.goal objectId]];
        }
        _transactionsByGoal = transactionsByGoalDict;
    }
    return _transactionsByGoal;
}

- (float)transactionsTotalForCurrentWeek {
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    NSArray *previousDates = [Utilities getPreviousDates:7 fromDate:today];
    NSDictionary *totalsDict = [self transactionsTotalByDate];
    float total = 0.f;
    for (NSDate *previousDate in previousDates) {
        float dateTotal = [(NSNumber *)[totalsDict objectForKey:previousDate] ?: [[NSNumber alloc] initWithFloat:0.f] floatValue];
        total += dateTotal;
    }

    return total;
}

- (float)transactionsTotalForToday {
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    NSDictionary *totalsDict = [self transactionsTotalByDate];
    return [(NSNumber *)[totalsDict objectForKey:today] floatValue] ?: 0.0;
}

- (NSDictionary *)transactionsByDate {
    if (!_transactionsByDate) {
        NSMutableDictionary *transactionsByDateDict = [[NSMutableDictionary alloc] init];
        for (Transaction *transaction in self.transactions) {
            if (transaction.type == TransactionTypeCredit) {
                NSDate *strippedDate = [Utilities dateWithoutTime:transaction.transactionDate];
                NSMutableArray *transactionsForDate = [transactionsByDateDict objectForKey:strippedDate] ?: [[NSMutableArray alloc] init];
                [transactionsForDate addObject:transaction];
                [transactionsByDateDict setObject:transactionsForDate forKey:strippedDate];
            }
        }
        _transactionsByDate = transactionsByDateDict;
    }
    return _transactionsByDate;
}

- (float)getTotalForTransactions:(float (^)(Transaction *))shouldIncludeTransaction {
    float total = 0;
    for (Transaction *transaction in self.transactions) {
        if (shouldIncludeTransaction(transaction)) {
            total += transaction.amount;
        }
    }
    return total;
}

- (float)spentToday {
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        return (transaction.type == TransactionTypeCredit && [[Utilities dateWithoutTime:transaction.transactionDate] isEqualToDate:today]);
    }];
}

- (float)spentThisWeek {
    NSDateComponents *components = [Utilities getDateComponentsForDate:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        if (transaction.type == TransactionTypeCredit) {
            NSDateComponents *transactionComponents = [Utilities getDateComponentsForDate:transaction.transactionDate];
            return (components.week == transactionComponents.week && components.month == transactionComponents.month && components.year == transactionComponents.year);
        }
        return NO;
    }];
}

- (float)spentThisMonth {
    NSDateComponents *components = [Utilities getDateComponentsForDate:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        if (transaction.type == TransactionTypeCredit) {
            NSDateComponents *transactionComponents = [Utilities getDateComponentsForDate:transaction.transactionDate];
            return (components.month == transactionComponents.month && components.year == transactionComponents.year);
        }
        return NO;
    }];
}

- (float)spentThisYear {
    NSDateComponents *components = [Utilities getDateComponentsForDate:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        if (transaction.type == TransactionTypeCredit) {
            NSDateComponents *transactionComponents = [Utilities getDateComponentsForDate:transaction.transactionDate];
            return (components.year == transactionComponents.year);
        }
        return NO;
    }];
}

- (float)savedToday {
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        return (transaction.type == TransactionTypeDebit && [[Utilities dateWithoutTime:transaction.transactionDate] isEqualToDate:today]);
    }];
}

- (float)savedThisWeek {
    NSDateComponents *components = [Utilities getDateComponentsForDate:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        if (transaction.type == TransactionTypeDebit) {
            NSDateComponents *transactionComponents = [Utilities getDateComponentsForDate:transaction.transactionDate];
            return (components.week == transactionComponents.week && components.month == transactionComponents.month && components.year == transactionComponents.year);
        }
        return NO;
    }];
}

- (float)savedThisMonth {
    NSDateComponents *components = [Utilities getDateComponentsForDate:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        if (transaction.type == TransactionTypeDebit) {
            NSDateComponents *transactionComponents = [Utilities getDateComponentsForDate:transaction.transactionDate];
            return (components.month == transactionComponents.month && components.year == transactionComponents.year);
        }
        return NO;
    }];
}

- (float)savedThisYear {
    NSDateComponents *components = [Utilities getDateComponentsForDate:[NSDate new]];
    return [self getTotalForTransactions:^float(Transaction *transaction) {
        if (transaction.type == TransactionTypeDebit) {
            NSDateComponents *transactionComponents = [Utilities getDateComponentsForDate:transaction.transactionDate];
            return (components.year == transactionComponents.year);
        }
        return NO;
    }];
}

- (NSArray *)transactionsForGoalId:(NSString *)goalId {
    NSPredicate *goalIdPredicate = [NSPredicate predicateWithBlock:^BOOL(Transaction *transaction, NSDictionary *bindings) {
        return [[transaction.goal objectId] isEqualToString:goalId];
    }];
    return [self.transactions filteredArrayUsingPredicate:goalIdPredicate];
}

- (float)totalPaymentsForGoalId:(NSString *)goalId {
    NSArray *transactions = [self transactionsForGoalId:goalId];
    float total = 0;
    for (Transaction *transaction in transactions) {
        total += transaction.amount;
    }
    return total;
}

@end
