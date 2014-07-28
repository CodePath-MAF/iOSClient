//
//  TransactionsSummaryTableViewCell.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionsSet.h"

@interface TransactionsSummaryHeaderView : UIView

@property (strong, nonatomic) NSDictionary *viewData;

- (void)setActiveBar:(NSInteger)barIndex activeAlpha:(CGFloat)activeAlpha inactiveAlpha:(CGFloat)inactiveAlpha;
- (void)cleanUpCharts;

@end
