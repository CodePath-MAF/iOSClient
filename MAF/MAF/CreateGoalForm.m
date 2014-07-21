//
//  CreateGoalForm2.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CreateGoalForm.h"
#import "Goal.h"
#import "MAFActionFormButtonCell.h"

NSString *const kGoalName = @"name";
NSString *const kGoalDetail = @"detail";
NSString *const kGoalType = @"type";
NSString *const kGoalPaymentInterval = @"paymentInterval";
NSString *const kGoalTotal = @"total";
NSString *const kGoalTargetDate = @"targetDate";
NSString *const kGoalCreate = @"create";

@implementation CreateGoalForm

+ (XLFormDescriptor *)formDescriptorWithTitle:(NSString *)title {
    XLFormDescriptor *form = [super formDescriptorWithTitle:title];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalTotal rowType:XLFormRowDescriptorTypeNumber title:@"Amount"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalName rowType:XLFormRowDescriptorTypeText title:@"Name"];
    row.required = YES;
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalTargetDate rowType:XLFormRowDescriptorTypeDateInline title:@"Due Date"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalPaymentInterval rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Payment Interval"];
    row.required = YES;
    row.selectorOptions = @[
                            [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalDaily) displayText:@"Daily"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalWeekly) displayText:@"Weekly"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalBiWeekly) displayText:@"Twice a week"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalMonthly) displayText:@"Monthly"],
                            ];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor *submitRow = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalCreate rowType:@"XLFormRowDescriptorTypeCustom" title:@"Create Goal"];
    submitRow.cellClass = [MAFActionFormButtonCell class];
    [section addFormRow:submitRow];
    
    return form;
    
}

@end
