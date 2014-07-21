//
//  TransactionTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "Utilities.h"

@interface TransactionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *transactionDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryColorView;

@end

@implementation TransactionTableViewCell

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    self.transactionDetailLabel.text = transaction.detail;
    self.transactionDetailLabel.textColor = [Utilities colorFromHexString:@"#342F33"];
    self.transactionCategoryLabel.text = [transaction.category.name uppercaseString];
    self.transactionCategoryLabel.textColor = [Utilities colorFromHexString:@"#979797"];
    self.categoryColorView.backgroundColor = [Utilities colorFromHexString:transaction.category.color];
    self.transactionAmountLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", transaction.amount];
    self.transactionAmountLabel.textColor = [Utilities colorFromHexString:@"#4A4A4A"];
}

@end
