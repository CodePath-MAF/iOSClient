//
//  CreateGoalViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CreateGoalForm.h"
#import "CreateGoalViewController.h"
#import "DashboardViewController.h"
#import "GoalManager.h"
#import "MAFActionFormButtonDelegate.h"

@interface CreateGoalViewController() <MAFActionFormButtonDelegate>

@end

@implementation CreateGoalViewController

- (id)init {
    self = [super init];
    if (self) {
        self.form = [CreateGoalForm formDescriptorWithTitle:@"Create Goal"];
    }
    return self;
}

- (void)didSelectButton {
    
    NSArray *validationErrors = self.formValidationErrors;
    if (validationErrors.count > 0) {
        NSLog(@"Error saving form: %@", validationErrors);
    } else {
        NSNumber *total = self.formValues[kGoalTotal];
        XLFormOptionsObject *type = self.formValues[kGoalType];
        XLFormOptionsObject *paymentInterval = self.formValues[kGoalPaymentInterval];
        [[GoalManager createGoalForUser:[PFUser currentUser] name:self.formValues[kGoalName] detail:self.formValues[kGoalDetail] type:(NSInteger)type.formValue total:[total floatValue] paymentInterval:(NSInteger)paymentInterval.formValue paymentAmount:0 numPayments:0 goalDate:self.formValues[kGoalTargetDate]] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error creating goal: %@", task.error);
            } else {
                NSLog(@"Successfully created goal: %@", task.result);
                [self.navigationController popViewControllerAnimated:YES];
            }
            return task;
        }];

    }
}

@end
