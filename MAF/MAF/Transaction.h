//
//  Transaction.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "Goal.h"

enum TransactionType: NSInteger {
    TransactionTypeDebit = 1,
    TransactionTypeCredit = 2,
};

@interface Transaction : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Goal *goal;
@property (nonatomic, assign) NSInteger amountInCents;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) enum TransactionType type;
//@property (nonatomic, strong) NSString *categoryId;

@end
