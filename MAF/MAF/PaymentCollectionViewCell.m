//
//  PaymentCollectionViewCell.m
//  MAF
//
//  Created by mhahn on 8/4/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "UIColor+CustomColors.h"

#import "PaymentCollectionViewCell.h"
#import "OpenSansRegularLabel.h"
#import "OpenSansSemiBoldLabel.h"

@interface PaymentCollectionViewCell()

@property (weak, nonatomic) IBOutlet OpenSansRegularLabel *_paymentReminderLabel;
@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *_paymentAmountLabel;

@end

@implementation PaymentCollectionViewCell

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self._paymentAmountLabel.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:goal.paymentAmount]];
    self._paymentAmountLabel.textColor = [UIColor customGreenColor];
}


@end
