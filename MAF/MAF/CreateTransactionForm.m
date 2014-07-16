//
//  CreateTransactionForm2.m
//  MAF
//
//  Created by mhahn on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Transaction.h"
#import "CreateTransactionForm.h"
#import "MAFActionFormButtonCell.h"

NSString *const kTransactionDescription = @"description";
NSString *const kTransactionType = @"type";
NSString *const kTransactionAmount = @"amount";
NSString *const kTransactionCreate = @"create";

@implementation CreateTransactionForm

+ (XLFormDescriptor *)formDescriptorWithTitle:(NSString *)title {
    XLFormDescriptor *form = [super formDescriptorWithTitle:title];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTransactionDescription rowType:XLFormRowDescriptorTypeText title:@"Description"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTransactionType rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Type"];
    row.required = YES;
    row.selectorOptions = @[
        [XLFormOptionsObject formOptionsObjectWithValue:@(TransactionTypeDebit) displayText:@"Debit"],
        [XLFormOptionsObject formOptionsObjectWithValue:@(TransactionTypeCredit) displayText:@"Credit"],
    ];
    row.value = row.selectorOptions[0];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTransactionAmount rowType:XLFormRowDescriptorTypeInteger title:@"Amount"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor *submitRow = [XLFormRowDescriptor formRowDescriptorWithTag:kTransactionCreate rowType:@"XLFormRowDescriptorTypeCustomCell" title:@"Create Transaction"];
    submitRow.cellClass = [MAFActionFormButtonCell class];
    [section addFormRow:submitRow];
    
    return form;
    
}

@end
