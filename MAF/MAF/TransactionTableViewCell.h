//
//  TransactionTableViewCell.h
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic, strong) Transaction *transaction;

@end
