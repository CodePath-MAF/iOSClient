//
//  TransactionCategory.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "TransactionCategory.h"

@implementation TransactionCategory

+ (NSString *)parseClassName {
    return @"Category";
}

@dynamic name;

@end
