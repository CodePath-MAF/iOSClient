//
//  CreateTransactionViewController.h
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, MultiInputType) {
    Goal_Creation = 1,
    Transaction_Creation = 2
};

@interface MultiInputViewController : UIViewController

- (id)initWithMultiInputType:(enum MultiInputType)multiInputType;

@end
