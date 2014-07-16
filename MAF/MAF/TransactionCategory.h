//
//  TransactionCategory.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>

@interface TransactionCategory : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;

@end
