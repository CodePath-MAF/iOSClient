//
//  TransactionTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionTableViewCell.h"

@interface TransactionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *transactionDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionAmountLabel;

@end

@implementation TransactionTableViewCell

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    self.transactionDetailLabel.text = transaction.detail;
    self.transactionCategoryLabel.text = transaction.category.name;
    self.transactionAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", transaction.amount];
}

@end
