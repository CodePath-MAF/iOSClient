//
//  CreateTransactionForm2.h
//  MAF
//
//  Created by mhahn on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "XLForm.h"

extern NSString *const kTransactionDetail;
extern NSString *const kTransactionType;
extern NSString *const kTransactionCategory;
extern NSString *const kTransactionAmount;
extern NSString *const kTransactionDate;
extern NSString *const kTransactionCreate;

@interface CreateTransactionForm : XLFormDescriptor

+ (XLFormDescriptor *)formDescriptorWithTitle:(NSString *)title categories:(NSArray *)categories;

@end
