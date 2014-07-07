//
//  GoalManager.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal.h"

@interface GoalManager : NSObject

+ (void)createGoal:(NSString *)name description:(NSString *)description type:(enum GoalType)type status:(enum GoalStatus)status amountInCents:(NSInteger)amountInCents numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate;

+ (void)updateGoal:(NSString *)goalId keyName:(NSString *)keyName value:(id)value;

+ (void)deleteGoal:(NSString *)goalId;


@end
