//
//  CreateTransactionForm.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

// TODO add form validation
// TODO pull categories from Parse and list them as possible choices for the category field

#import "CreateTransactionForm.h"

@implementation CreateTransactionForm

- (NSArray *)extraFields {
    return @[
             @{FXFormFieldTitle: @"Create Transaction", FXFormFieldHeader: @"", FXFormFieldAction: @"submitCreateTransactionForm:"},
             ];
}

- (NSDictionary *)transactionTypeField {
    return @{
         FXFormFieldCell: [FXFormOptionPickerCell class],
         FXFormFieldOptions: @[@(TransactionTypeDebit), @(TransactionTypeCredit)],
         FXFormFieldValueTransformer: ^(id input) {
             return @{@(TransactionTypeCredit): @"Credit", @(TransactionTypeDebit): @"Debit"}[input];
         },
    };
}

@end
