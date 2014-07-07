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

+ (BFTask *)createGoal:(NSString *)userId name:(NSString *)name description:(NSString *)description type:(enum GoalType)type status:(enum GoalStatus)status totalInCents:(NSInteger)totalInCents paymentInterval:(enum GoalPaymentInterval)paymentInterval paymentAmountInCents:(NSInteger)paymentAmountInCents numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate {
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    Goal *goal = [Goal object];
    
    goal.user = [PFUser objectWithoutDataWithObjectId:userId];
    goal.name = name;
    goal.description = description;
    goal.type = type;
    goal.status = status;
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

+ (BFTask *)fetchGoalsForUserId:(NSString *)userId {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    PFQuery *query = [Goal query];
    [query whereKey:@"user" equalTo:userId];
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
