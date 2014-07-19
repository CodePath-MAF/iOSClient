//
//  Transaction.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "Goal.h"
#import "TransactionCategory.h"

NS_ENUM(NSInteger, TransactionType) {
    TransactionTypeDebit = 1,
    TransactionTypeCredit = 2,
};

@interface Transaction : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Goal *goal;
@property (nonatomic, assign) float amount;
@property (nonatomic, strong) NSString *detail;
//@property (nonatomic, strong) TransactionCategory *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) enum TransactionType type;
@property (nonatomic, assign) TransactionCategory *category;
@property (nonatomic, strong) NSDate *transactionDate;

@end
