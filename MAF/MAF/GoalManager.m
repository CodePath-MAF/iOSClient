//
//  GoalManager.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import <Parse/Parse.h>

#import "GoalManager.h"
#import "Goal.h"

@implementation GoalManager

+ (BFTask *)createGoalForUser:(PFUser *)user name:(NSString *)name description:(NSString *)description type:(enum GoalType)type totalInCents:(NSInteger)totalInCents paymentInterval:(enum GoalPaymentInterval)paymentInterval paymentAmountInCents:(NSInteger)paymentAmountInCents numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate {
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    Goal *goal = [Goal object];
    
    goal.user = user;
    goal.name = name;
    goal.description = description;
    goal.type = type;
    goal.status = GoalStatusInProgress;
    goal.totalInCents = totalInCents;
    goal.paymentInterval = paymentInterval;
    goal.paymentAmountInCents = paymentAmountInCents;
    goal.numPayments = numPayments;
    [goal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [task setResult:goal];
        }
    }];
    return task.task;
    
}

+ (BFTask *)updateGoal:(NSString *)goalId keyName:(NSString *)keyName value:(id)value {
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [[Goal query] getObjectInBackgroundWithId:goalId block:^(PFObject *goal, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [goal setObject:value forKey:keyName];
            [goal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [task setError:error];
                } else {
                    [task setResult:goal];
                }
            }];
        }
        
    }];
    return task.task;
    
}

+ (BFTask *)completeGoal:(NSString *)goalId {
    return [self updateGoal:goalId keyName:@"status" value:@(GoalStatusAcheived)];
}

+ (BFTask *)deleteGoal:(NSString *)goalId {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [[Goal query] getObjectInBackgroundWithId:goalId block:^(PFObject *goal, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [goal deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [task setError:error];
                } else {
                    [task setResult:@(succeeded)];
                }
            }];
        }
    }];
    return task.task;
}

+ (BFTask *)fetchGoalsForUser:(PFUser *)user {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    PFQuery *query = [Goal query];
    [query whereKey:@"user" equalTo:user];
    // TODO add limit to this query to support pagination
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [task setError:error];
        } else {
            [task setResult:objects];
        }
    }];
    return task.task;
}

@end
