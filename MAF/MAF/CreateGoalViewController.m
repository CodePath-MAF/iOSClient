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
        NSDictionary *formValues = self.formValues;
        NSLog(@"Saving form: %@", formValues);
        // TODO need to figure out what the updated fields for the goal are
    }

}

//- (void)submitCreateGoalForm:(UITableViewCell<FXFormFieldCell> *)cell {
//    CreateGoalForm *form = cell.field.form;
//    [[GoalManager createGoalForUser:[PFUser currentUser] name:form.name description:form.description type:form.goalType totalInCents:form.totalInCents paymentInterval:form.paymentInterval paymentAmountInCents:form.paymentAmountInCents numPayments:form.numPayments goalDate:form.dueDate] continueWithBlock:^id(BFTask *task) {
//        if (task.error) {
//            NSLog(@"Error creating goal: %@", task.error);
//        } else {
//            NSLog(@"Successfully created goal: %@", task.result);
//            [self presentViewController:[[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil] animated:YES completion:nil];
//        }
//        return task;
//    }];
//}

@end
