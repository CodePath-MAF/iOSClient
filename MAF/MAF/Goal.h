//
//  Goal.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>

NS_ENUM(NSInteger, GoalType) {
    GoalTypeLoan = 1,
    GoalTypeDeposit = 2,
    GoalTypeVacation = 3,
};

NS_ENUM(NSInteger, GoalStatus) {
    GoalStatusInProgress = 1,
    GoalStatusAcheived = 2,
};

NS_ENUM(NSInteger, GoalPaymentInterval) {
    GoalPaymentIntervalDaily = 1,
    GoalPaymentIntervalWeekly = 7,
    GoalPaymentIntervalBiWeekly = 14,
    GoalPaymentIntervalMonthly = 30,
};

@interface Goal : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) enum GoalType type;
@property (nonatomic, assign) enum GoalStatus status;
@property (nonatomic, assign) enum GoalPaymentInterval paymentInterval;
@property (nonatomic, assign) float total;
@property (nonatomic, assign) float paymentAmount;
@property (nonatomic, assign) NSInteger numPayments;
@property (nonatomic, strong) NSDate *goalDate;

@end
