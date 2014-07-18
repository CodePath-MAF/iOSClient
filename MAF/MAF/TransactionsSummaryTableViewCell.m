//
//  TransactionsSummaryTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionsSummaryTableViewCell.h"

@interface TransactionsSummaryTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *transactionsWeeklyTotalLabel;

@end

@implementation TransactionsSummaryTableViewCell

- (void)setTransactionsSet:(TransactionsSet *)transactionsSet {
    _transactionsSet = transactionsSet;
    self.transactionsWeeklyTotalLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", [transactionsSet transactionsTotalForCurrentWeek]];
}

@end
