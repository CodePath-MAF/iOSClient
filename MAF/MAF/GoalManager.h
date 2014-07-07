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

+ (BFTask *)createGoal:(NSString *)userId name:(NSString *)name description:(NSString *)description type:(enum GoalType)type status:(enum GoalStatus)status totalInCents:(NSInteger)totalInCents paymentInterval:(enum GoalPaymentInterval)paymentInterval paymentAmountInCents:(NSInteger)paymentAmountInCents numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate;

+ (BFTask *)updateGoal:(NSString *)goalId keyName:(NSString *)keyName value:(id)value;

+ (BFTask *)deleteGoal:(NSString *)goalId;

+ (BFTask *)fetchGoalsForUserId:(NSString *)userId;

@end
