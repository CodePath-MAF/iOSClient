//
//  TransactionCategoryManager.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionCategory.h"
#import "TransactionCategoryManager.h"
#import "Utilities.h"

@interface TransactionCategoryManager()

@property (nonatomic, strong) NSDictionary *categoryColors;

@end

@implementation TransactionCategoryManager

- (void)fetchCategories {
    [[TransactionCategory query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error fetching categories: %@", error);
        } else {
            self.categories = [[NSMutableArray alloc] initWithArray:objects];
        }
 
    }];
}

- (UIColor *)colorForCategory:(TransactionCategory *)category {
    if (!self.categoryColors) {
        NSMutableDictionary *categoryColorDict = [[NSMutableDictionary alloc] init];
        for (TransactionCategory *category in self.categories) {
            [categoryColorDict setObject:[Utilities colorFromHexString:category.color] forKey:category.name];
        }
        self.categoryColors = [[NSDictionary alloc] initWithDictionary:categoryColorDict];
    }
    return [self.categoryColors objectForKey:category.name];
}

+ (TransactionCategoryManager *)instance {
    static TransactionCategoryManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[TransactionCategoryManager alloc] init];
    });
    return instance;
}

@end
