//
//  Transaction.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Transaction.h"

@implementation Transaction

+ (NSString *)parseClassName {
    return @"Transaction";
}

@dynamic user;
@dynamic goal;
@dynamic amount;
@dynamic detail;
@dynamic name;
@dynamic type;
@dynamic category;
@dynamic transactionDate;

@end
