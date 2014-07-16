//
//  TransactionCategoryManager.h
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bolts.h"

@interface TransactionCategoryManager : NSObject

+ (BFTask *)fetchCategories;

@end
