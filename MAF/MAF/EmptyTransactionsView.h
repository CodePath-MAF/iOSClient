//
//  EmptyTransactionsView.h
//  MAF
//
//  Created by mhahn on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyTransactionsViewDelegate <NSObject>

- (void)addTransactionButtonTriggered:(id)sender;

@end

@interface EmptyTransactionsView : UIView

- (void)updateTotalCash;

@property (nonatomic, strong) id<EmptyTransactionsViewDelegate> delegate;

@end
