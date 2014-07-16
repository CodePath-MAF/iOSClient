//
//  TransactionCategoryManager.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionCategory.h"
#import "TransactionCategoryManager.h"

@implementation TransactionCategoryManager

+ (BFTask *)fetchCategories {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [[TransactionCategory query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [task setResult:objects];
        }
    }];
    return task.task;
}

@end
