//
//  DashboardTransactionsEmptyView.h
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DashboardTransactionsEmptyViewDelegate <NSObject>

- (void)addTransactionButtonTriggered:(id)sender;

@end

@interface DashboardTransactionsEmptyView : UIView

@property (nonatomic, strong) id<DashboardTransactionsEmptyViewDelegate> delegate;

@end
