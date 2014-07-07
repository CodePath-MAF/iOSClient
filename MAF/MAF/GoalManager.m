//
//  GoalManager.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "GoalManager.h"
#import "Goal.h"

@implementation GoalManager

+ (void)createGoal:(NSString *)name description:(NSString *)description type:(enum GoalType)type status:(enum GoalStatus)status amountInCents:(NSInteger)amountInCents numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate {
    
    Goal *goal = [Goal object];
    goal.name = name;
    goal.description = description;
    goal.type = type;
    goal.status = status;
    goal.amountInCents = amountInCents;
    goal.numPayments = numPayments;
    goal.goalDate = goalDate;
    [goal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Failed to save goal: %@", error);
        } else {
            NSLog(@"Goal saved");
        }
    }];
    
}

+ (void)updateGoal:(NSString *)goalId keyName:(NSString *)keyName value:(id)value {
    
    [[Goal query] getObjectInBackgroundWithId:goalId block:^(PFObject *object, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            Goal *goal = ((Goal *)object);
            [goal setObject:value forKey:keyName];
            [goal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Failed to update goal: %@", error);
                } else {
                    NSLog(@"Goal updated");
                }
            }];
        }
        
    }];
    
}

+ (void)deleteGoal:(NSString *)goalId {
    [[Goal query] getObjectInBackgroundWithId:goalId block:^(PFObject *goal, NSError *error) {
        if (error) {
            NSLog(@"Error fetching goal: %@ (id %@)", error, goalId);
        } else {
            [goal deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error deleting goal: %@ (id %@)", error, goalId);
                } else {
                    NSLog(@"Successfully deleted goal");
                }
            }];
        }
    }];
}

@end
