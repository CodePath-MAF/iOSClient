//
//  Goal.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Goal.h"
#import "Utilities.h"

@implementation Goal

+ (NSString *)parseClassName {
    return @"Goal";
}

@dynamic user;
@dynamic name;
@dynamic type;
@dynamic status;
@dynamic paymentInterval;
@dynamic amount;
@dynamic paymentAmount;
@dynamic numPayments;
@dynamic goalDate;
@dynamic currentTotal;

@end
