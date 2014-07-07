//
//  CreateGoalForm.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CreateGoalForm.h"

// TODO add form validation (this would go in the CreateGoalViewController?)

@implementation CreateGoalForm

- (NSArray *)extraFields {
    return @[
        @{FXFormFieldTitle: @"Create Goal", FXFormFieldHeader: @"", FXFormFieldAction: @"submitCreateGoalForm:"},
    ];
}

// TODO if we use the master of this repo: https://github.com/nicklockwood/FXForms we can get FXFormFieldDefault to default the goal type
- (NSDictionary *)goalTypeField {
    return @{
        FXFormFieldCell: [FXFormOptionPickerCell class],
        FXFormFieldOptions: @[@(GoalTypeLoan), @(GoalTypeDeposit), @(GoalTypeVacation)],
        FXFormFieldValueTransformer: ^(id input) {
            return @{@(GoalTypeLoan): @"Loan", @(GoalTypeDeposit): @"Deposit", @(GoalTypeVacation): @"Vacation"}[input];
        },
    };
}

- (NSDictionary *)paymentIntervalField {
    return @{
         FXFormFieldCell: [FXFormOptionPickerCell class],
         FXFormFieldOptions: @[@(GoalPaymentIntervalDaily), @(GoalPaymentIntervalBiWeekly), @(GoalPaymentIntervalWeekly), @(GoalPaymentIntervalBiMonthly), @(GoalPaymentIntervalMonthly), @(GoalPaymentIntervalBiYearly), @(GoalPaymentIntervalYearly)],
         FXFormFieldValueTransformer: ^(id input) {
             return @{@(GoalPaymentIntervalDaily): @"Daily", @(GoalPaymentIntervalBiWeekly): @"Twice a week", @(GoalPaymentIntervalWeekly): @"Weekly", @(GoalPaymentIntervalBiMonthly): @"Twice a month", @(GoalPaymentIntervalMonthly): @"Monthly", @(GoalPaymentIntervalBiYearly): @"Twice a year", @(GoalPaymentIntervalYearly): @"Yearly",
            }[input];
         },
    };
}

@end
