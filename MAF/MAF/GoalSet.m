//
//  GoalSet.m
//  MAF
//
//  Created by Eddie Freeman on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "GoalSet.h"
#import "Utilities.h"
#import "Goal.h"
#import "TransactionsSet.h"
#import "Transaction.h"

@interface GoalSet () {
    NSDictionary *_totalByDate;
    NSDictionary *_goalsByDate;
    NSDictionary *_transactionsByGoal;
}

@end

@implementation GoalSet

- (id)initWithGoals:(NSArray *)goals {
    self = [super init];
    if (self) {
        _goals = [[NSMutableArray alloc] initWithArray:goals];
    }
    return self;
}

- (NSDictionary *)goalsTotalByDate { // Not Accurate
    if (!_totalByDate) {
        NSMutableDictionary *goalDict = [[NSMutableDictionary alloc] init];
        for (Goal *goal in self.goals) {
            NSDate *strippedDate = [Utilities dateWithoutTime:goal.targetDate]; // This should use a different date/ Created? next Payment Interval?
            float total = [(NSNumber *)[goalDict objectForKey:strippedDate] ?: [[NSNumber alloc] initWithFloat:0.0] floatValue];
            float newTotal = total + goal.total;
            [goalDict setObject:@(newTotal) forKey:strippedDate];
        }
        _totalByDate = goalDict;
    }
    return _totalByDate;
}

- (NSDictionary *)goalsByDate { // Not Accurate
    if (!_goalsByDate) {
        NSMutableDictionary *goalsByDateDict = [[NSMutableDictionary alloc] init];
        for (Goal *goal in self.goals) {
            NSDate *strippedDate = [Utilities dateWithoutTime:goal.targetDate]; // This should use a different date/ Created? next Payment Interval?
            NSMutableArray *goalsForDate = [goalsByDateDict objectForKey:strippedDate] ?: [[NSMutableArray alloc] init];
            [goalsForDate addObject:goal];
            [goalsByDateDict setObject:goalsForDate forKey:strippedDate];
        }
        _goalsByDate = goalsByDateDict;
    }
    return _goalsByDate;
}

- (NSDictionary *)goalsByDescendingNextMilestone { // TODO
    
    return nil;
}

- (NSDictionary *)goalsByAscendingNextMilestone { // TODO
    
    return nil;
}

- (NSDictionary *)transactionsByGoal { // Moved to TransactionSet
    if (!_transactionsByGoal) {
        NSMutableDictionary *goalsByDateDict = [[NSMutableDictionary alloc] init];
        for (Goal *goal in self.goals) {
            NSDate *strippedDate = [Utilities dateWithoutTime:goal.targetDate]; // This should use a different date/ Created? next Payment Interval?
            NSMutableArray *goalsForDate = [goalsByDateDict objectForKey:strippedDate] ?: [[NSMutableArray alloc] init];
            [goalsForDate addObject:goal];
            [goalsByDateDict setObject:goalsForDate forKey:strippedDate];
        }
        _transactionsByGoal = goalsByDateDict;
    }
    return _transactionsByGoal;
}

- (float)goalsTotalForToday { // Not Accurate
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    NSDictionary *totalsDict = [self goalsTotalByDate];
    return [(NSNumber *)[totalsDict objectForKey:today] floatValue] ?: 0.0;
}

- (float)goalsTotalForCurrentWeek { // Not Accurate
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    NSArray *previousDates = [Utilities getPreviousDates:7 fromDate:today];
    NSDictionary *totalsDict = [self goalsTotalByDate];
    float total = 0.f;
    for (NSDate *previousDate in previousDates) {
        float dateTotal = [(NSNumber *)[totalsDict objectForKey:previousDate] ?: [[NSNumber alloc] initWithFloat:0.f] floatValue];
        total += dateTotal;
    }
    return total;
}

@end
