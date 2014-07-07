//
//  Goal.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>

enum GoalType: NSInteger {
    GoalTypeLoan = 1,
    GoalTypeDeposit = 2,
    GoalTypeVacation = 3,
};

enum GoalStatus: NSInteger {
    GoalStatusInProgress = 1,
    GoalStatusAcheived = 2,
};

enum GoalPaymentInterval: NSInteger {
    GoalPaymentIntervalDaily = 1,
    GoalPaymentIntervalBiWeekly = 2,
    GoalPaymentIntervalWeekly = 3,
    GoalPaymentIntervalBiMonthly = 4,
    GoalPaymentIntervalMonthly = 5,
    GoalPaymentIntervalBiYearly = 6,
    GoalPaymentIntervalYearly = 7,
};

@interface Goal : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) enum GoalType type;
@property (nonatomic, assign) enum GoalStatus status;
@property (nonatomic, assign) enum GoalPaymentInterval paymentInterval;
@property (nonatomic, assign) NSInteger totalInCents;
@property (nonatomic, assign) NSInteger paymentAmountInCents;
@property (nonatomic, assign) NSInteger numPayments;
@property (nonatomic, strong) NSDate *goalDate;

@end
