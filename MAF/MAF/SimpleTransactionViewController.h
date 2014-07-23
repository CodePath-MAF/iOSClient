//
//  SimpleTransactionViewController.h
//  MAF
//
//  Created by Guy Morita on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

NS_ENUM(NSInteger, SimpleTransactionType) {
    InitialCash = 1,
    MakePayment = 2,
};

@interface SimpleTransactionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (void)setLabelsAndButtons:(enum SimpleTransactionType)type goal:(Goal *)goal amount:(float)amount;

@end
