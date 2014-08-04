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

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [Utilities colorFromHexString:@"#F3F3F3"];
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.transactionDetailLabel.text = transaction.name;
    self.transactionDetailLabel.textColor = [Utilities colorFromHexString:@"#342F33"];
    self.transactionCategoryLabel.text = [transaction.category.name uppercaseString];
    self.transactionCategoryLabel.textColor = [Utilities colorFromHexString:@"#979797"];
    self.categoryColorView.backgroundColor = [Utilities colorFromHexString:transaction.category.color];
    self.transactionAmountLabel.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:transaction.amount]];
    self.transactionAmountLabel.textColor = [Utilities colorFromHexString:@"#4A4A4A"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
