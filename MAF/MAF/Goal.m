//
//  Goal.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Goal.h"

@implementation Goal

+ (NSString *)parseClassName {
    return @"Goal";
}

@dynamic user;
@dynamic name;
@dynamic detail;
@dynamic type;
@dynamic status;
@dynamic paymentInterval;
@dynamic total;
@dynamic paymentAmount;
@dynamic numPayments;
@dynamic targetDate;

@end
