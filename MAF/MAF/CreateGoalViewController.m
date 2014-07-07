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

@implementation CreateGoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.formController.form = [[CreateGoalForm alloc] init];
    }
    return self;
}

- (void)submitCreateGoalForm:(UITableViewCell<FXFormFieldCell> *)cell {
    CreateGoalForm *form = cell.field.form;
    [[GoalManager createGoalForUserId:[[PFUser currentUser] objectId] name:form.name description:form.description type:form.goalType totalInCents:form.totalInCents paymentInterval:form.paymentInterval paymentAmountInCents:form.paymentAmountInCents numPayments:form.numPayments goalDate:form.dueDate] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error creating goal: %@", task.error);
        } else {
            NSLog(@"Successfully created goal: %@", task.result);
            [self presentViewController:[[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil] animated:YES completion:nil];
        }
        return task;
    }];
}

@end
