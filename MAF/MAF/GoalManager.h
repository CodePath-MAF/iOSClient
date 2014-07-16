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

@interface GoalManager : NSObject

+ (BFTask *)createGoalForUser:(PFUser *)user name:(NSString *)name detail:(NSString *)detail type:(enum GoalType)type total:(float)total paymentInterval:(enum GoalPaymentInterval)paymentInterval paymentAmount:(float)paymentAmount numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate;

+ (BFTask *)completeGoal:(NSString *)goalId;

+ (BFTask *)updateGoal:(NSString *)goalId keyName:(NSString *)keyName value:(id)value;

+ (BFTask *)deleteGoal:(NSString *)goalId;

+ (BFTask *)fetchGoalsForUser:(PFUser *)user;

@end
