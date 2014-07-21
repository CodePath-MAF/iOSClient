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
#import "User.h"

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
        NSInteger paymentInterval = [[(XLFormOptionsObject *)self.formValues[kGoalPaymentInterval] formValue] integerValue];
        
        [[GoalManager createGoalForUser:[User currentUser] name:self.formValues[kGoalName] type:GoalTypeGoal total:[total floatValue] paymentInterval:paymentInterval goalDate:self.formValues[kGoalTargetDate]] continueWithBlock:^id(BFTask *task) {
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
