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
NSString *const kGoalDescription = @"description";
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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalName rowType:XLFormRowDescriptorTypeText title:@"Name"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalDescription rowType:XLFormRowDescriptorTypeText title:@"Description"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalType rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Goal Type"];
    row.required = YES;
    row.selectorOptions = @[
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalTypeLoan) displayText:@"Loan"],
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalTypeDeposit) displayText:@"Deposit"],
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalTypeVacation) displayText:@"Vacation"],
    ];
    row.value = row.selectorOptions[0];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalPaymentInterval rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Payment Interval"];
    row.required = YES;
    row.selectorOptions = @[
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalDaily) displayText:@"Daily"],
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalWeekly) displayText:@"Weekly"],
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalBiWeekly) displayText:@"Twice a week"],
//        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalBiMonthly) displayText:@"Twice a month"],
        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalMonthly) displayText:@"Monthly"],
//        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalBiYearly) displayText:@"Twice a year"],
//        [XLFormOptionsObject formOptionsObjectWithValue:@(GoalPaymentIntervalYearly) displayText:@"Yearly"],
    ];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalTotal rowType:XLFormRowDescriptorTypeInteger title:@"Total"];
    row.required = YES;
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalTargetDate rowType:XLFormRowDescriptorTypeDateInline title:@"Target Date"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor *submitRow = [XLFormRowDescriptor formRowDescriptorWithTag:kGoalCreate rowType:@"XLFormRowDescriptorTypeCustom" title:@"Create Goal"];
    submitRow.cellClass = [MAFActionFormButtonCell class];
    [section addFormRow:submitRow];
    
    return form;
    
}

@end
