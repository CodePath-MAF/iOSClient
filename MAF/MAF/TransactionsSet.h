//
//  TransactionsSet.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionsSet : NSObject

@property (nonatomic, strong) NSArray *transactions;

- (id)initWithTransactions:(NSArray *)transactions;
- (NSDictionary *)transactionsTotalByDate;
- (NSDictionary *)transactionsTotalByCategoryForDate:(NSDate *)date;
- (NSDictionary *)transactionsTotalByCategoryByDate;
- (float)transactionsTotalForCurrentWeek;


@end
