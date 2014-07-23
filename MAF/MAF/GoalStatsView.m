//
//  GoalStatsView.m
//  MAF
//
//  Created by Eddie Freeman on 7/17/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "GoalStatsView.h"
#import "TransactionsSet.h"

@interface GoalStatsView ()

@property (weak, nonatomic) IBOutlet UILabel *totalSpentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSavedLabel;

@end

@implementation GoalStatsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"GoalStatsView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        [self addSubview:objects[0]];
    }
    return self;
}

- (void)setTransactionSet:(TransactionsSet *)transactionSet {
    _transactionSet = transactionSet;
    self.totalSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", [transactionSet spentToday]];
    self.totalSavedLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", [transactionSet savedToday]];
}

@end
