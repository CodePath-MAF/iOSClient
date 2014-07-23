//
//  EmptyTransactionsView.m
//  MAF
//
//  Created by mhahn on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "User.h"
#import "EmptyTransactionsView.h"
#import "OpenSansSemiBoldLabel.h"
#import "Utilities.h"
#import "CreateTransactionViewController.h"
#import "TransactionCategoryManager.h"

@interface EmptyTransactionsView()

@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *totalCashLabel;
- (IBAction)addTransactionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addTransactionButton;


@end

@implementation EmptyTransactionsView

- (void)updateTotalCash {
    self.totalCashLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", [[User currentUser] totalCash]];
    [Utilities setupRoundedButton:self.addTransactionButton
                 withCornerRadius:BUTTON_CORNER_RADIUS];
}

- (IBAction)addTransactionButton:(id)sender {
    [self.delegate addTransactionButtonTriggered:sender];
}

@end
