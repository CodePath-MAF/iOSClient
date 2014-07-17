//
//  TransactionsSet.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionsSet.h"

#import "Transaction.h"

@interface TransactionsSet() {
    NSDictionary *totalByDate;
}

@end

@implementation TransactionsSet

- (id)initWithTransactions:(NSArray *)transactions {
    self = [super init];
    if (self) {
        _transactions = transactions;
    }
    return self;
}

- (NSDate *)dateWithoutTime:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDate *strippedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    return strippedDate;
}

- (NSDictionary *)transactionsTotalByDate {
    // Calculate the totals for the transactions, grouped by date.
    if (!totalByDate) {
        NSMutableDictionary *transactionDict = [[NSMutableDictionary alloc] init];
        for (Transaction *transaction in self.transactions) {
            NSDate *strippedDate = [self dateWithoutTime:transaction.transactionDate];
            float total = [(NSNumber *)[transactionDict objectForKey:strippedDate] ?: [[NSNumber alloc] initWithFloat:0.0] floatValue];
            float newTotal = total + transaction.amount;
            [transactionDict setObject:@(newTotal) forKey:strippedDate];
        }
        totalByDate = transactionDict;
    }
    return totalByDate;
}

- (NSDictionary *)transactionsTotalByCategoryForDate:(NSDate *)date {
    // loop over the array and compile transactionsTotalByCategoryByDate (this should be cached on the instance of the set)
    // fetch the one that corresponds to the given date
    return [[NSDictionary alloc] init];
}

- (float)transactionsTotalForCurrentWeek {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate new]];
    NSInteger currentDay = [components day];
    
    NSDictionary *totalsDict = [self transactionsTotalByDate];
    float total = [(NSNumber *)[totalsDict objectForKey:[[NSCalendar currentCalendar] dateFromComponents:components]] ?: [[NSNumber alloc] initWithFloat:0.f] floatValue];
    for (int i=1; i < 7; i++) {
        [components setDay:currentDay - i];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        float dateTotal = [(NSNumber *)[totalsDict objectForKey:date] ?: [[NSNumber alloc] initWithFloat:0.f] floatValue];
        total += dateTotal;
    }

    return total;
}

- (NSDictionary *)transactionsTotalByCategoryByDate {
    // loop over the array and compile transactionsTotalByCategoryByDate (this should be cached on the instance of the set)
    return [[NSDictionary alloc] init];
}

@end
