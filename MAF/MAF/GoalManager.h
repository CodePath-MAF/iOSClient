//
//  GoalManager.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bolts.h"
#import "Goal.h"
#import "User.h"

@interface GoalManager : NSObject

+ (BFTask *)createGoalForUser:(User *)user name:(NSString *)name type:(enum GoalType)type total:(float)total paymentInterval:(enum GoalPaymentInterval)paymentInterval goalDate:(NSDate *)goalDate;

+ (BFTask *)completeGoal:(NSString *)goalId;

+ (BFTask *)updateGoal:(NSString *)goalId keyName:(NSString *)keyName value:(id)value;

+ (BFTask *)deleteGoal:(NSString *)goalId;

+ (BFTask *)fetchGoalsForUser:(User *)user;

@end
