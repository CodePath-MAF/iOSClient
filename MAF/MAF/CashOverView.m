//
//  CashOverView.m
//  MAF
//
//  Created by Eddie Freeman on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CashOverView.h"

@interface CashOverView()

@property (weak, nonatomic) IBOutlet UILabel *totalCashLabel;

@end

@implementation CashOverView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        NSLog(@"Init with Coder CashOverView");
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"CashOverView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        UIView *view = objects[0];
        
        view.frame = self.frame; // (3)
        view.autoresizingMask = self.autoresizingMask;
        
        [self addSubview:view];
    }
    return self;
}

- (void)setTotalCash:(float)totalCash {
    _totalCash = totalCash;
#warning TODO we should maybe make this font red
    self.totalCashLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", totalCash];
}

- (void)onTapView:(id)sender {
    NSLog(@"Loading Transactions View");
    [self.delegate viewTransactions:sender];
}

@end
