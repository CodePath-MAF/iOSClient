//
//  TransactionCategoryManager.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bolts.h"
#import "TransactionCategory.h"

@interface TransactionCategoryManager : NSObject

@property (nonatomic, strong) NSMutableArray *categories;
- (void)fetchCategories;
- (UIColor *)colorForCategory:(TransactionCategory *)category;

+ (TransactionCategoryManager *)instance;


@end
