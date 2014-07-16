//
//  TransactionTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionTableViewCell.h"

@interface TransactionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *transactionDescriptionLabel;

@end

@implementation TransactionTableViewCell

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    self.transactionDescriptionLabel.text = transaction.detail;
}

@end
