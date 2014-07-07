//
//  CreateGoalForm.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

#import "Goal.h"

@interface CreateGoalForm : NSObject <FXForm>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) enum GoalType goalType;
@property (nonatomic, assign) enum GoalPaymentInterval paymentInterval;
@property (nonatomic, assign) NSInteger totalInCents;
@property (nonatomic, assign) NSInteger paymentAmountInCents;
@property (nonatomic, assign) NSInteger numPayments;
@property (nonatomic, strong) NSDate *dueDate;

@end
