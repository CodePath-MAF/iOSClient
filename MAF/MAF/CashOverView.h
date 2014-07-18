//
//  CashOverView.h
//  MAF
//
//  Created by Eddie Freeman on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CashOverViewDelegate <NSObject>

@required
- (void)viewTransactions:(id)sender;

@end

@interface CashOverView : UIView

@property (nonatomic, weak) id <CashOverViewDelegate>delegate;
@property (nonatomic, strong) NSNumber *totalCash;

@end
