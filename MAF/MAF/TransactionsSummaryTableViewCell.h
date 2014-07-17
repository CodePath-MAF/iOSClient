//
//  TransactionsSummaryTableViewCell.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionsSet.h"

@interface TransactionsSummaryTableViewCell : UITableViewCell

@property (strong, nonatomic) TransactionsSet *transactionsSet;

@end
